using HarmonyLib;
using Verse;

namespace ContentedLivestock
{
    /// <summary>
    /// Remembers what an animal last ate.
    /// </summary>
    /// <remarks>
    /// <c>Thing.Ingested</c> is the single funnel every meal passes through, grazing included —
    /// a grazing animal ingests the living <c>Plant</c> itself — and unlike
    /// <c>IngestedCalculateAmounts</c> it is not virtual, so one patch sees every food in the
    /// game without knowing anything about it.
    ///
    /// The thing may be destroyed by the time the postfix runs; only its def and its type are
    /// read, and both outlive it.
    /// </remarks>
    [HarmonyPatch(typeof(Thing), nameof(Thing.Ingested))]
    public static class Patch_Ingested
    {
        public static void Postfix(Thing __instance, Pawn ingester)
        {
            if (ingester?.RaceProps == null || !ingester.RaceProps.Animal) return;
            Contentment.NeedOf(ingester)?.Notify_Ate(__instance);
        }
    }
}
