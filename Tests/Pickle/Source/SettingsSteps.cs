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

    }
}
