using RimWorld;
using Verse;

namespace ContentedLivestock
{
    public class MainButtonWorker_ContentedLivestock : MainButtonWorker
    {
        // Keep vanilla Visible: customization tools own def.buttonVisible.
        public override void Activate()
        {
            if (ContentedLivestockMod.Instance == null) return;
            Find.WindowStack.Add(new Dialog_ModSettings(ContentedLivestockMod.Instance));
        }
    }
}
