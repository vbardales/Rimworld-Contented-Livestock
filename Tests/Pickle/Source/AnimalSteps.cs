using RimWorld;
using RimWorks.Pickle;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using Verse;

namespace ContentedLivestock.PickleSteps
{
    [PickleSteps]
    public class AnimalSteps
    {
        private static float recordedFullness;
        private static readonly System.Collections.Generic.Dictionary<string, float> recordedByName =
            new System.Collections.Generic.Dictionary<string, float>();

        private static IntVec3 FreeCell(PickleContext ctx, IntVec3? near = null, int radius = 20)
        {
            var map = Driver.Map(ctx);
            IntVec3 cell;
            var found = CellFinder.TryFindRandomCellNear(near ?? map.Center, map, radius,
                c => c.Standable(map) && c.GetEdifice(map) == null && c.GetFirstPawn(map) == null,
                out cell);
            ctx.Require(found, "no free standable cell was found near {(near ?? map.Center)}");
            return cell;
        }

        [Given("Contented Livestock spawns the player animal {string} as {string}")]
        public void SpawnPlayerAnimal(PickleContext ctx, string name, string kindName)
        {
            Spawn(ctx, name, kindName, Faction.OfPlayer);
        }

        /// <summary>
        /// Spawns beside a chosen cell instead of the map centre, for presentation scenes where the
        /// animal has to stand in a particular part of a fixture map. Close, so two of them frame together.
        /// </summary>
        [Given("Contented Livestock spawns the player animal {string} as {string} near x {int} and z {int}")]
        public void SpawnPlayerAnimalNear(PickleContext ctx, string name, string kindName, int x, int z)
        {
            Spawn(ctx, name, kindName, Faction.OfPlayer, 3f, new IntVec3(x, 0, z), 5);
        }

        [Given("Contented Livestock spawns the wild animal {string} as {string}")]
        public void SpawnWildAnimal(PickleContext ctx, string name, string kindName)
        {
            Spawn(ctx, name, kindName, null);
        }

        [Given("Contented Livestock spawns the player pawn {string} as {string}")]
        public void SpawnPlayerPawn(PickleContext ctx, string name, string kindName)
        {
            Spawn(ctx, name, kindName, Faction.OfPlayer, 25f);
        }

        private static void Spawn(PickleContext ctx, string name, string kindName, Faction faction,
            float biologicalAge = 3f, IntVec3? near = null, int radius = 20)
        {
            var kind = DefDatabase<PawnKindDef>.GetNamedSilentFail(kindName);
            ctx.Require(kind != null, $"no PawnKindDef named '{kindName}'");
            var pawn = PawnGenerator.GeneratePawn(new PawnGenerationRequest(
                kind, faction, forceGenerateNewPawn: true, fixedGender: Gender.Female,
                fixedBiologicalAge: biologicalAge));
            pawn.Name = new NameSingle(name);
            GenSpawn.Spawn(pawn, FreeCell(ctx, near, radius), Driver.Map(ctx));
            pawn.needs.AddOrRemoveNeedsAsAppropriate();
        }

        [When("Contented Livestock sets producers-only to {word} and applies settings")]
        public void SetProducersOnly(PickleContext ctx, string value)
        {
            bool parsed;
            ctx.Require(bool.TryParse(value, out parsed), $"'{value}' is not true or false");
            Driver.Settings(ctx).producersOnly = parsed;
            Driver.Mod(ctx).WriteSettings();
        }

        [When("Contented Livestock gives {string} to the player faction")]
        public void JoinPlayer(PickleContext ctx, string name) => Driver.PawnNamed(ctx, name).SetFaction(Faction.OfPlayer);

        [When("Contented Livestock removes {string} from every faction")]
        public void LeavePlayer(PickleContext ctx, string name) => Driver.PawnNamed(ctx, name).SetFaction(null);

        [When("Contented Livestock transfers {string} to a neutral trader faction")]
        public void TransferToTrader(PickleContext ctx, string name)
        {
            var faction = Find.FactionManager.AllFactionsListForReading.FirstOrDefault(f =>
                !f.IsPlayer && !f.def.hidden && f.def.humanlikeFaction && !f.HostileTo(Faction.OfPlayer));
            ctx.Require(faction != null, "no neutral visible humanlike faction is available as trader owner");
            Driver.PawnNamed(ctx, name).SetFaction(faction);
        }

        [When("Contented Livestock selects animal {string} for visual evidence")]
        public void SelectForEvidence(PickleContext ctx, string name)
        {
            var pawn = Driver.PawnNamed(ctx, name);
            Find.Selector.ClearSelection();
            Find.Selector.Select(pawn);
            Find.CameraDriver.JumpToCurrentMapLoc(pawn.Position);
            InspectPaneUtility.OpenTab(typeof(ITab_Pawn_Needs));
        }

        [Then("Contented Livestock animal {string} has the contentment need")]
        public void HasNeed(PickleContext ctx, string name)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Assert(need != null, $"{name} has no Nelim_Contentment need");
        }

        [Then("Contented Livestock animal {string} has no contentment need")]
        public void HasNoNeed(PickleContext ctx, string name)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Assert(need == null, $"{name} unexpectedly has a Nelim_Contentment need");
        }

        [Then("Contented Livestock animal {string} starts at {int} percent contentment")]
        public void InitialLevel(PickleContext ctx, string name, int expected)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            var actual = Mathf.RoundToInt(need.CurLevelPercentage * 100f);
            ctx.Assert(actual == expected, $"{name} starts at {actual} percent, expected {expected}");
        }

        [When("Contented Livestock sets {string} to {int} percent contentment")]
        public void SetLevel(PickleContext ctx, string name, int percent)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            need.CurLevelPercentage = percent / 100f;
        }

        [When("Contented Livestock records that {string} ate {string}")]
        public void Ate(PickleContext ctx, string name, string defName)
        {
            var def = DefDatabase<ThingDef>.GetNamedSilentFail(defName);
            ctx.Require(def != null, $"no ThingDef named '{defName}'");
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            need.Notify_Ate(ThingMaker.MakeThing(def));
        }

        [Then("Contented Livestock animal {string} is at {int} percent contentment")]
        public void CurrentLevel(PickleContext ctx, string name, int expected)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            var actual = Mathf.RoundToInt(need.CurLevelPercentage * 100f);
            ctx.Assert(actual == expected, $"{name} is at {actual} percent, expected {expected}");
        }

        [Then("Contented Livestock animal {string} has feed offset {int} percent")]
        public void FeedOffset(PickleContext ctx, string name, int expected)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            var actual = Mathf.RoundToInt(need.FeedOffset() * 100f);
            ctx.Assert(actual == expected, $"{name}'s feed offset is {actual} percent, expected {expected}");
        }

        [When("Contented Livestock wounds {string} with a bleeding cut")]
        public void WoundWithCut(PickleContext ctx, string name)
        {
            var pawn = Driver.PawnNamed(ctx, name);
            pawn.TakeDamage(new DamageInfo(DamageDefOf.Cut, 10f));
            ctx.Assert(pawn.health.hediffSet.PainTotal > 0f, $"{name} has no pain after the cut");
            ctx.Assert(pawn.health.hediffSet.BleedRateTotal > 0f, $"{name} has no bleeding after the cut");
        }

        [When("Contented Livestock heals every injury on {string}")]
        public void HealAll(PickleContext ctx, string name)
        {
            var pawn = Driver.PawnNamed(ctx, name);
            foreach (var hediff in pawn.health.hediffSet.hediffs.ToList())
                pawn.health.RemoveHediff(hediff);
        }

        [Then("Contented Livestock health offset for {string} is negative but capped")]
        public void HealthOffsetNegativeAndCapped(PickleContext ctx, string name)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            var offset = need.HealthOffset();
            ctx.Assert(offset < 0f, $"{name}'s health offset is not negative: {offset:0.000}");
            ctx.Assert(offset >= -0.35f, $"{name}'s health offset is below the -35% cap: {offset:0.000}");
        }

        [Then("Contented Livestock health offset for {string} is zero")]
        public void HealthOffsetZero(PickleContext ctx, string name)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            ctx.Assert(Mathf.Abs(need.HealthOffset()) < 0.0001f,
                $"{name}'s health offset is {need.HealthOffset():0.000}, expected zero");
        }

        [When("Contented Livestock opens the live contentment tip for {string}")]
        public void OpenContentmentTip(PickleContext ctx, string name)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            Find.WindowStack.Add(new Dialog_MessageBox(need.GetTipString()));
        }

        /// <summary>
        /// The same tip, moved to the top left so it does not cover the animal the camera has just
        /// centred on. Nothing else of the interface sits there: the Needs pane is bottom left, the
        /// colonist bar top centre, the alerts on the right.
        /// </summary>
        [When("Contented Livestock opens the live contentment tip for {string} at the top left")]
        public void OpenContentmentTipTopLeft(PickleContext ctx, string name)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            var dialog = new Dialog_MessageBox(need.GetTipString());
            Find.WindowStack.Add(dialog);
            dialog.windowRect.x = 30f;
            dialog.windowRect.y = 30f;
        }

        /// <summary>
        /// A fixture accumulates letters (here "Area revealed" and "Fallen monolith") that have nothing
        /// to do with what the picture shows.
        /// </summary>
        [When("Contented Livestock dismisses every letter")]
        public void DismissLetters(PickleContext ctx)
        {
            foreach (var letter in Find.LetterStack.LettersListForReading.ToList())
                Find.LetterStack.RemoveLetter(letter);
        }

        private static CompMilkable MilkComp(PickleContext ctx, string name)
        {
            var pawn = Driver.PawnNamed(ctx, name);
            var comp = pawn.TryGetComp<CompMilkable>();
            // Name the race: a fixture can already hold a pawn of that name, and PawnNamed takes the first.
            ctx.Require(comp != null, $"{name} has no CompMilkable (found a {pawn.def.defName}, id {pawn.thingIDNumber})");
            return comp;
        }

        [When("Contented Livestock records the milk fullness of {string}")]
        public void RecordMilkFullness(PickleContext ctx, string name)
        {
            var comp = MilkComp(ctx, name);
            recordedFullness = comp.fullness;
            recordedByName[name] = comp.fullness;
        }

        [Then("Contented Livestock milk gained by {string} exceeds the milk gained by {string}")]
        public void MilkGainExceeds(PickleContext ctx, string more, string less)
        {
            float Gain(string name)
            {
                var comp = MilkComp(ctx, name);
                ctx.Require(recordedByName.ContainsKey(name), $"no milk fullness was recorded for {name}");
                return comp.fullness - recordedByName[name];
            }
            var gainMore = Gain(more);
            var gainLess = Gain(less);
            ctx.Assert(gainMore > gainLess,
                $"{more} gained {gainMore:0.000000} and {less} gained {gainLess:0.000000}: expected the first to be larger");
        }

        [When("Contented Livestock waits one game hour", TimeoutSeconds = 60f)]
        public async Task WaitOneHour(PickleContext ctx)
        {
            var previous = Find.TickManager.CurTimeSpeed;
            Find.TickManager.CurTimeSpeed = TimeSpeed.Superfast;
            try
            {
                await ctx.WaitTicks(2500);
            }
            finally
            {
                Find.TickManager.CurTimeSpeed = previous;
            }
        }

        [Then("Contented Livestock milk fullness of {string} has increased")]
        public void MilkFullnessIncreased(PickleContext ctx, string name)
        {
            var comp = Driver.PawnNamed(ctx, name).TryGetComp<CompMilkable>();
            ctx.Require(comp != null, $"{name} has no CompMilkable");
            ctx.Assert(comp.fullness > recordedFullness,
                $"{name}'s milk fullness is {comp.fullness:0.000000}, not above {recordedFullness:0.000000}");
        }

        [Then("Contented Livestock milk fullness of {string} has not changed")]
        public void MilkFullnessUnchanged(PickleContext ctx, string name)
        {
            var comp = Driver.PawnNamed(ctx, name).TryGetComp<CompMilkable>();
            ctx.Require(comp != null, $"{name} has no CompMilkable");
            ctx.Assert(Mathf.Abs(comp.fullness - recordedFullness) < 0.000001f,
                $"{name}'s milk fullness moved from {recordedFullness:0.000000} to {comp.fullness:0.000000}");
        }

        [Then("Contented Livestock production factor for {string} is {int} percent")]
        public void Rate(PickleContext ctx, string name, int expected)
        {
            var actual = Mathf.RoundToInt(Contentment.RateFactor(Driver.PawnNamed(ctx, name)) * 100f);
            ctx.Assert(actual == expected, $"production factor for {name} is {actual} percent, expected {expected}");
        }
    }
}
