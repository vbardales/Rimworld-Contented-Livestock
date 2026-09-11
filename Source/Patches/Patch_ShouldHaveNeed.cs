using HarmonyLib;
using RimWorld;
using Verse;

namespace ContentedLivestock
{
    /// <summary>
    /// Decides which pawns carry the contentment need.
    /// </summary>
    /// <remarks>
    /// A <c>NeedDef</c> can restrict itself downward — <c>minIntelligence</c> is what keeps mood,
    /// recreation and comfort off animals — but there is no matching ceiling, so no def alone can
    /// say "animals and nothing else". Vanilla's own <c>Food</c> and <c>Rest</c> get onto animals
    /// precisely by leaving <c>minIntelligence</c> at its default; leaving it there would put
    /// contentment on every colonist too. Hence one small postfix.
    ///
    /// <c>requiredComps</c> would have covered the producers-only case declaratively, but it is a
    /// conjunction: it can ask for a gatherable comp, or for an egg layer, never for either.
    /// </remarks>
    [HarmonyPatch(typeof(Pawn_NeedsTracker), "ShouldHaveNeed")]
    public static class Patch_ShouldHaveNeed
    {
        public static void Postfix(Pawn_NeedsTracker __instance, NeedDef nd, ref bool __result)
        {
            if (nd != ContentedLivestockDefOf.Nelim_Contentment) return;
            __result = Contentment.AppliesTo(__instance.pawn);
        }
    }

    /// <summary>
    /// Grants or takes away the need the moment an animal joins or leaves the colony.
    /// </summary>
    /// <remarks>
    /// The tracker only revisits <c>ShouldHaveNeed</c> when something asks it to. Without this,
    /// a freshly tamed muffalo would carry no contentment until the next save was reloaded, and a
    /// sold one would keep simulating for a faction that is no longer yours.
    /// </remarks>
    [HarmonyPatch(typeof(Pawn), nameof(Pawn.SetFaction))]
    public static class Patch_SetFaction
    {
        public static void Postfix(Pawn __instance)
        {
            if (__instance.needs == null) return;
            if (__instance.RaceProps == null || !__instance.RaceProps.Animal) return;
            __instance.needs.AddOrRemoveNeedsAsAppropriate();
        }
    }
}
