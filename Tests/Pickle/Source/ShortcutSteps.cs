using RimWorld;
using RimWorks.Pickle;
using Verse;

namespace ContentedLivestock.PickleSteps
{
    [PickleSteps]
    public class ShortcutSteps
    {
        private const string DefName = "Nelim_ContentedLivestockSettings";

        private static MainButtonDef Shortcut(PickleContext ctx)
        {
            var def = DefDatabase<MainButtonDef>.GetNamedSilentFail(DefName);
            ctx.Require(def != null, $"no MainButtonDef named '{DefName}'");
            return def;
        }

        [Then("the Contented Livestock shortcut is hidden on a clean configuration")]
        public void Hidden(PickleContext ctx)
        {
            var def = Shortcut(ctx);
            ctx.Assert(!def.buttonVisible && !def.Worker.Visible,
                $"the shortcut is visible with buttonVisible={def.buttonVisible} and Worker.Visible={def.Worker.Visible}");
        }

        [When("Contented Livestock reveals its shortcut as a customization mod would")]
        public void Reveal(PickleContext ctx) => Shortcut(ctx).buttonVisible = true;

        [When("Contented Livestock hides its shortcut again")]
        public void Hide(PickleContext ctx) => Shortcut(ctx).buttonVisible = false;

        [Then("the Contented Livestock shortcut is drawn and enabled")]
        public void Drawn(PickleContext ctx)
        {
            var worker = Shortcut(ctx).Worker;
            ctx.Assert(worker.Visible, "the revealed shortcut is still not drawn");
            ctx.Assert(!worker.Disabled, "the revealed shortcut is greyed out");
        }

        [When("Contented Livestock activates its shortcut")]
        public void Activate(PickleContext ctx) => Shortcut(ctx).Worker.Activate();

        [AfterScenario]
        public void RestoreVisibility(PickleContext ctx)
        {
            var def = DefDatabase<MainButtonDef>.GetNamedSilentFail(DefName);
            if (def != null) def.buttonVisible = false;
        }
    }
}
