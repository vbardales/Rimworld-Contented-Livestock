using RimWorld;
using Verse;

namespace ContentedLivestock
{
    /// <summary>
    /// The rules that decide which animals have a contentment need, and what that contentment is
    /// worth when the game asks how fast an udder, a fleece or an egg fills.
    /// </summary>
    /// <remarks>
    /// Everything the mod does passes through <see cref="RateFactor"/>. An animal with no
    /// contentment need — a wild one, a stranger's, or any animal at all when the need has been
    /// switched off — returns exactly 1, which is the vanilla rate. That is the property that
    /// makes the mod safe to add to and remove from a running save: absence of the need is not a
    /// special case, it is the neutral value.
    /// </remarks>
    public static class Contentment
    {
        /// <summary>Does this animal keep a contentment need at all?</summary>
        public static bool AppliesTo(Pawn pawn)
        {
            if (pawn == null || pawn.Dead) return false;
            if (pawn.RaceProps == null || !pawn.RaceProps.Animal) return false;
            if (pawn.Faction == null || !pawn.Faction.IsPlayer) return false;

            var settings = ContentedLivestockMod.Settings;
            if (settings != null && settings.producersOnly && !Produces(pawn)) return false;

            return true;
        }

        /// <summary>Milk, wool, eggs — anything whose accumulation this mod can slow or stop.</summary>
        public static bool Produces(Pawn pawn)
        {
            if (!(pawn is ThingWithComps thing)) return false;
            return thing.GetComp<CompHasGatherableBodyResource>() != null
                || thing.GetComp<CompEggLayer>() != null;
        }

        /// <summary>The animal's contentment, or 1 when it has no such need.</summary>
        public static float LevelOf(Pawn pawn)
        {
            var need = NeedOf(pawn);
            return need == null ? 1f : need.CurLevel;
        }

        public static Need_Contentment NeedOf(Pawn pawn)
        {
            if (pawn?.needs == null) return null;
            return pawn.needs.TryGetNeed(ContentedLivestockDefOf.Nelim_Contentment) as Need_Contentment;
        }

        /// <summary>
        /// What one tick of accumulation is worth for this animal. Zero below the floor: the
        /// animal stops filling, but keeps whatever it had — a bad week costs the week, not the
        /// progress already made.
        /// </summary>
        public static float RateFactor(Pawn pawn)
        {
            var settings = ContentedLivestockMod.Settings;
            if (settings == null) return 1f;

            var need = NeedOf(pawn);
            if (need == null) return 1f;

            return settings.RateAt(need.CurLevel);
        }
    }
}
