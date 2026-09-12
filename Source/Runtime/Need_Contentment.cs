using System.Text;
using RimWorld;
using UnityEngine;
using Verse;

namespace ContentedLivestock
{
    /// <summary>
    /// How settled an animal is. Not a mood: an animal has no <c>Need_Mood</c> and gets no
    /// thoughts. This is a slow state built from the four things a farmer actually controls —
    /// what the animal eats, the room or pasture it lives in, the temperature it lives at, and
    /// the shape it is in — plus the company it keeps.
    /// </summary>
    /// <remarks>
    /// The level never jumps. Every interval it walks toward a target at
    /// <see cref="ContentedLivestockSettings.adjustSpeed"/> of a full swing per day, so a herd
    /// that loses its pasture takes about a day to stop producing and about a day to come back.
    /// That delay is the whole point: it makes neglect legible without making it instant, and it
    /// stops a single cold night from emptying every udder in the barn.
    ///
    /// Contributions are signed offsets around a neutral 0.5. An animal that is fed hay in a
    /// shed at a comfortable temperature sits near the middle and produces at very nearly the
    /// vanilla rate; the mod is meant to reward husbandry, not to tax it.
    /// </remarks>
    public class Need_Contentment : Need
    {
        private const int SpaceRecheckTicks = 2500;
        private const float FeedMemoryTicks = 120000f;

        /// <summary>-1 to +1: what the animal last ate, before it is weighted and faded.</summary>
        private float feedQuality;
        private int lastFeedTick = -999999;

        private float cachedSpaceOffset;
        private float cachedCompanyOffset;
        private int cachedAtTick = -999999;

        public Need_Contentment(Pawn pawn) : base(pawn)
        {
            threshPercents = new System.Collections.Generic.List<float>();
        }

        public override void SetInitialLevel() => CurLevel = 0.5f;

        public override void ExposeData()
        {
            base.ExposeData();
            Scribe_Values.Look(ref feedQuality, "feedQuality", 0f);
            Scribe_Values.Look(ref lastFeedTick, "lastFeedTick", -999999);
        }

        /// <summary>Called by the ingestion patch when this animal finishes eating something.</summary>
        public void Notify_Ate(Thing food)
        {
            feedQuality = FeedValue(food);
            lastFeedTick = Find.TickManager.TicksGame;
        }

        public override void NeedInterval()
        {
            if (IsFrozen) return;

            var settings = ContentedLivestockMod.Settings;
            RefreshThresholdMarkers(settings);

            float step = Mathf.Max(settings.adjustSpeed, 0.05f) * (150f / 60000f);
            CurLevel = Mathf.MoveTowards(CurLevel, TargetLevel(), step);
        }

        /// <summary>
        /// Puts the two markers on the bar where they mean something: the level at which the
        /// animal stops filling, and the level above which it beats the vanilla rate.
        /// </summary>
        private void RefreshThresholdMarkers(ContentedLivestockSettings settings)
        {
            if (threshPercents.Count == 2
                && Mathf.Approximately(threshPercents[0], settings.floorLevel)
                && Mathf.Approximately(threshPercents[1], settings.plateauLevel)) return;

            threshPercents.Clear();
            threshPercents.Add(settings.floorLevel);
            threshPercents.Add(settings.plateauLevel);
        }

        /// <summary>Where contentment is heading, given how the animal is being kept right now.</summary>
        public float TargetLevel()
        {
            RefreshCachesIfDue();
            return Mathf.Clamp01(0.5f
                + FeedOffset()
                + cachedSpaceOffset
                + TemperatureOffset()
                + HealthOffset()
                + cachedCompanyOffset);
        }

        // ---------------------------------------------------------------- contributions

        /// <summary>
        /// What the animal last ate, fading toward neutral over two days. Grazing a living plant
        /// is the best thing that can happen to a grazer; kibble is the worst thing short of
        /// carrion.
        /// </summary>
        public float FeedOffset()
        {
            if (!ContentedLivestockMod.Settings.feedMatters) return 0f;
            float age = (Find.TickManager.TicksGame - lastFeedTick) / FeedMemoryTicks;
            return feedQuality * Mathf.Clamp01(1f - age) * 0.25f;
        }

        private static float FeedValue(Thing food)
        {
            if (food == null) return 0f;

            // Grazing: the thing eaten is the plant itself, still rooted. Hay is an item and so
            // never a Plant, which is what separates a pasture from a hopper without guessing at
            // food-type flags that both share.
            if (food is Plant) return 1f;

            if (food is Corpse corpse)
            {
                var rot = corpse.GetComp<CompRottable>();
                return rot != null && rot.Stage != RotStage.Fresh ? -0.4f : 0.4f;
            }

            var def = food.def;
            if (def == ThingDefOf.Hay) return 0f;
            if (def == ThingDefOf.Kibble) return -0.6f;
            if (def == ThingDefOf.MealNutrientPaste) return -0.6f;

            var ingestible = def.ingestible;
            if (ingestible == null) return 0f;

            if (ingestible.foodType.HasFlag(FoodTypeFlags.Meal)) return 0.4f;
            if (ingestible.foodType.HasFlag(FoodTypeFlags.VegetableOrFruit)) return 0.6f;
            if (ingestible.foodType.HasFlag(FoodTypeFlags.Meat)) return 0.4f;
            if (ingestible.foodType.HasFlag(FoodTypeFlags.Plant)) return 0.3f;
            return 0f;
        }

        /// <summary>
        /// Room to live in. Grazers are judged on their pen's pasture: RimWorld already computes
        /// whether the grass grows back faster than the herd eats it, and that number is exactly
        /// the question. Everything else is judged on floor space per animal in its room.
        /// </summary>
        private float ComputeSpaceOffset()
        {
            if (!ContentedLivestockMod.Settings.penMatters) return 0f;
            if (!pawn.Spawned || pawn.Map == null) return 0f;

            if (AnimalPenUtility.NeedsToBeManagedByRope(pawn))
            {
                var marker = AnimalPenUtility.GetCurrentPenOf(pawn, allowUnenclosedPens: true);
                if (marker == null) return 0f;

                var food = marker.PenFoodCalculator;
                if (food == null) return 0f;

                float grown = food.NutritionPerDayToday;
                float eaten = food.SumNutritionConsumptionPerDay;
                if (eaten <= 0f) return 0.1f;
                return Mathf.Lerp(-0.2f, 0.2f, Mathf.Clamp01(grown / eaten));
            }

            var room = pawn.GetRoom();
            if (room == null) return 0f;
            if (room.PsychologicallyOutdoors) return 0.05f;

            int companions = 0;
            var animals = pawn.Map.mapPawns.SpawnedColonyAnimals;
            for (int i = 0; i < animals.Count; i++)
                if (animals[i].GetRoom() == room) companions++;

            if (companions <= 0) companions = 1;
            float cellsEach = room.CellCount / (float)companions;
            return Mathf.Lerp(-0.2f, 0.1f, Mathf.InverseLerp(2f, 8f, cellsEach));
        }

        /// <summary>
        /// Heat and cold. The band is the animal's own comfortable range, so a husky and a
        /// dromedary are asking for opposite barns, and a heater in winter does for a coop what
        /// it does in Stardew.
        /// </summary>
        public float TemperatureOffset()
        {
            if (!ContentedLivestockMod.Settings.temperatureMatters) return 0f;
            if (!pawn.Spawned) return 0f;

            FloatRange comfy = pawn.ComfortableTemperatureRange();
            float ambient = pawn.AmbientTemperature;
            if (comfy.Includes(ambient)) return 0.05f;

            float outside = ambient > comfy.max ? ambient - comfy.max : comfy.min - ambient;
            return -Mathf.Clamp01(outside / 15f) * 0.3f;
        }

        /// <summary>Pain, blood loss and hunger. A hurt animal is not a contented one.</summary>
        public float HealthOffset()
        {
            if (!ContentedLivestockMod.Settings.healthMatters) return 0f;
            if (pawn.health?.hediffSet == null) return 0f;

            float penalty = Mathf.Clamp01(pawn.health.hediffSet.PainTotal) * 0.2f
                + Mathf.Clamp01(pawn.health.hediffSet.BleedRateTotal) * 0.1f;

            var food = pawn.needs?.food;
            if (food != null)
            {
                if (food.Starving) penalty += 0.3f;
                else if (food.CurCategory == HungerCategory.UrgentlyHungry) penalty += 0.18f;
                else if (food.CurCategory == HungerCategory.Hungry) penalty += 0.07f;
            }

            return -Mathf.Min(penalty, 0.35f);
        }

        /// <summary>A bonded animal, and a herd animal that is not alone.</summary>
        private float ComputeCompanyOffset()
        {
            if (!ContentedLivestockMod.Settings.companyMatters) return 0f;

            float offset = 0f;
            if (pawn.relations != null
                && pawn.relations.GetFirstDirectRelationPawn(PawnRelationDefOf.Bond, null) != null)
                offset += 0.1f;

            if (pawn.RaceProps.herdAnimal && pawn.Spawned && pawn.Map != null)
            {
                bool nearKin = false;
                var animals = pawn.Map.mapPawns.SpawnedColonyAnimals;
                for (int i = 0; i < animals.Count && !nearKin; i++)
                {
                    var other = animals[i];
                    if (other != pawn && other.def == pawn.def
                        && other.Position.InHorDistOf(pawn.Position, 12f))
                        nearKin = true;
                }
                if (!nearKin) offset -= 0.1f;
            }

            return offset;
        }

        private void RefreshCachesIfDue()
        {
            int now = Find.TickManager.TicksGame;
            if (now - cachedAtTick < SpaceRecheckTicks) return;

            // Stagger the first refresh across animals so a big herd never recomputes together.
            cachedAtTick = now + (pawn.thingIDNumber % 200);
            cachedSpaceOffset = ComputeSpaceOffset();
            cachedCompanyOffset = ComputeCompanyOffset();
        }

        // ---------------------------------------------------------------- display

        public override string GetTipString()
        {
            var text = new StringBuilder();
            text.AppendLine(base.GetTipString());
            text.AppendLine();

            float rate = Contentment.RateFactor(pawn);
            text.AppendLine(rate <= 0f
                ? "ContentedLivestock.Tip.Halted".Translate()
                : "ContentedLivestock.Tip.Rate".Translate(rate.ToStringPercent()));
            text.AppendLine();

            AppendLine(text, "ContentedLivestock.Tip.Feed", FeedOffset());
            AppendLine(text, "ContentedLivestock.Tip.Space", cachedSpaceOffset);
            AppendLine(text, "ContentedLivestock.Tip.Temperature", TemperatureOffset());
            AppendLine(text, "ContentedLivestock.Tip.Health", HealthOffset());
            AppendLine(text, "ContentedLivestock.Tip.Company", cachedCompanyOffset);

            return text.ToString().TrimEndNewlines();
        }

        private static void AppendLine(StringBuilder text, string key, float offset)
        {
            if (Mathf.Abs(offset) < 0.005f) return;
            string sign = offset > 0f ? "+" : "";
            text.AppendLine(key.Translate(sign + offset.ToStringPercent("F0")));
        }
    }
}
