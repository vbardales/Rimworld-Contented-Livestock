using HarmonyLib;
using RimWorld;
using Verse;

namespace ContentedLivestock
{
    /// <summary>
    /// Slows, stops or speeds the filling of an udder or a fleece according to contentment.
    /// </summary>
    /// <remarks>
    /// This wraps the tick rather than the yield, and that is a deliberate choice. The obvious
    /// target is <c>ResourceAmount</c>, but it is a property each subclass overrides — patching
    /// the base would miss <c>CompShearable</c>, and patching every subclass would miss every
    /// modded one. <c>CompTick</c> is declared once, on the base, and no vanilla subclass
    /// overrides it, so one patch covers milk, wool and anything a mod hangs off the same comp.
    ///
    /// It also reads better in play: a contented cow is ready sooner, a neglected one later, and
    /// one kept below the floor simply never fills. Nothing is ever taken away — the postfix only
    /// touches a positive delta, so gathering (which zeroes <c>fullness</c>) and any other reset
    /// pass through untouched. A herd that goes hungry for a week loses the week, not the
    /// progress it had already made.
    ///
    /// The prefix reads the field rather than recomputing the increment, so the mod never has to
    /// know vanilla's formula, and keeps working if that formula changes.
    /// </remarks>
    [HarmonyPatch(typeof(CompHasGatherableBodyResource), "CompTick")]
    public static class Patch_GatherableFullness
    {
        public static void Prefix(CompHasGatherableBodyResource __instance, out float __state)
        {
            __state = __instance.fullness;
        }

        public static void Postfix(CompHasGatherableBodyResource __instance, float __state)
        {
            float delta = __instance.fullness - __state;
            if (delta <= 0f) return;
            if (!(__instance.parent is Pawn pawn)) return;

            float factor = Contentment.RateFactor(pawn);
            if (factor == 1f) return;

            __instance.fullness = __state + delta * factor;
        }
    }

    /// <summary>
    /// The same rule for eggs. <c>CompEggLayer</c> is not a gatherable-body-resource comp — it
    /// keeps its own <c>eggProgress</c> and lays on its own schedule — so it needs its own patch,
    /// built the same way.
    /// </summary>
    /// <remarks>
    /// Only a rising delta is scaled, which leaves the reset after laying alone, and leaves the
    /// unfertilized stall alone too: when vanilla holds <c>eggProgress</c> still because there is
    /// no male, the delta is zero and there is nothing here to scale.
    /// </remarks>
    [HarmonyPatch(typeof(CompEggLayer), "CompTick")]
    public static class Patch_EggProgress
    {
        public static void Prefix(CompEggLayer __instance, out float __state)
        {
            __state = __instance.eggProgress;
        }

        public static void Postfix(CompEggLayer __instance, float __state)
        {
            float delta = __instance.eggProgress - __state;
            if (delta <= 0f) return;
            if (!(__instance.parent is Pawn pawn)) return;

            float factor = Contentment.RateFactor(pawn);
            if (factor == 1f) return;

            __instance.eggProgress = __state + delta * factor;
        }
    }
}
