using System;
using System.Globalization;
using System.Reflection;
using System.Threading.Tasks;
using RimWorld;
using RimWorks.Pickle;
using Verse;

namespace ContentedLivestock.PickleSteps
{
    [PickleSteps]
    public class SettingsSteps
    {
        private static FieldInfo Field(PickleContext ctx, string name)
        {
            var field = typeof(ContentedLivestockSettings).GetField(name, BindingFlags.Public | BindingFlags.Instance);
            ctx.Require(field != null, $"ContentedLivestockSettings has no public field '{name}'");
            return field;
        }

        [When("I open the Contented Livestock settings dialog")]
        public async Task Open(PickleContext ctx)
        {
            Find.WindowStack.Add(new Dialog_ModSettings(Driver.Mod(ctx)));
            await ctx.WaitFrames(3);
        }

        [Then("Contented Livestock sees its own settings dialog open")]
        public void AssertOwnDialog(PickleContext ctx)
        {
            var actual = Driver.DialogMod(ctx, Driver.SettingsDialog(ctx));
            ctx.Assert(actual == Driver.Mod(ctx),
                $"the open settings dialog belongs to '{actual?.Content?.Name ?? "unknown"}', not Contented Livestock");
        }

        [Then("Contented Livestock setting {string} reads {string}")]
        public void AssertSetting(PickleContext ctx, string name, string expected)
        {
            var actual = Convert.ToString(Field(ctx, name).GetValue(Driver.Settings(ctx)), CultureInfo.InvariantCulture);
            ctx.Assert(actual == expected, $"ContentedLivestockSettings.{name} reads '{actual}', expected '{expected}'");
        }

        [When("Contented Livestock sets setting {string} to {string} and writes settings")]
        public void SetSetting(PickleContext ctx, string name, string value)
        {
            var field = Field(ctx, name);
            object parsed = field.FieldType == typeof(bool)
                ? (object)bool.Parse(value)
                : float.Parse(value, CultureInfo.InvariantCulture);
            field.SetValue(Driver.Settings(ctx), parsed);
            Driver.Mod(ctx).WriteSettings();
        }

        [When("Contented Livestock keeps its settings for the next launch")]
        public void KeepForNextLaunch(PickleContext ctx) => SettingsSandbox.KeepForNextLaunch(ctx);

        /// <summary>
        /// Puts every setting back to its shipped default and applies it.
        /// </summary>
        /// <remarks>
        /// The settings sandbox snapshots and restores them around every scenario, except the restart
        /// chain: the writer keeps them on purpose and the reader used to put back only the file,
        /// so in a whole-companion run the distinctive values stayed live in memory afterwards.
        /// The restart pair writes eleven deliberately non-default values, and on 2026-09-23 that
        /// took down two later scenarios that had passed when run alone under a filter - the
        /// eligibility one saw a husky with the need because producersOnly was still false, and
        /// the health one measured an offset of exactly zero because healthMatters was still false.
        /// Neither was a fault of the mod.
        ///
        /// The sandbox now restores them itself; this step is the explicit precondition, and the proof
        /// in feature 10 that the restore took. Reset() rather than eleven assignments: it is the mod's own method, it is covered by
        /// the out-of-game suite, and a twelfth setting added later is cleaned up here without
        /// anyone remembering to come back. WriteSettings() normalizes and calls
        /// AddOrRemoveNeedsAsAppropriate on every animal alive, so the restore reaches the pawns
        /// already on the map rather than only the stored values.
        /// </remarks>
        [When("Contented Livestock restores its default settings")]
        public void RestoreDefaults(PickleContext ctx)
        {
            Driver.Settings(ctx).Reset();
            Driver.Mod(ctx).WriteSettings();
        }

    }
}
