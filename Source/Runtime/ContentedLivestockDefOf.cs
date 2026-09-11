using RimWorld;
using Verse;

namespace ContentedLivestock
{
    [DefOf]
    public static class ContentedLivestockDefOf
    {
        public static NeedDef Nelim_Contentment;

        static ContentedLivestockDefOf() => DefOfHelper.EnsureInitializedInCtor(typeof(ContentedLivestockDefOf));
    }
}
