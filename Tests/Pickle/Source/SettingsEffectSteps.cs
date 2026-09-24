using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using RimWorld;
using RimWorks.Pickle;
using UnityEngine;
using Verse;

namespace ContentedLivestock.PickleSteps
{
    /// <summary>
    /// Steps for scenarios 15 and 16: what the settings window shows and keeps, and what each setting does
    /// to an animal once play resumes. The sliders and check boxes have no name Pickle can click, so they are
    /// set in code to the value the widget would give, and the window is left to draw them; the reset button
    /// and its confirmation are real buttons and are clicked.
    /// </summary>
    [PickleSteps]
    public class SettingsEffectSteps
    {
        // ---------------------------------------------------------------- settings window (scenario 15)

        [When("Contented Livestock lets the settings dialog draw")]
        public async Task LetItDraw(PickleContext ctx) => await ctx.WaitFrames(3);

        [Then("Contented Livestock setting {string} reads about {int} percent")]
        public void ReadsAbout(PickleContext ctx, string name, int percent)
        {
            var field = typeof(ContentedLivestockSettings).GetField(name, BindingFlags.Public | BindingFlags.Instance);
            ctx.Require(field != null, $"ContentedLivestockSettings has no public field '{name}'");
            float value = System.Convert.ToSingle(field.GetValue(Driver.Settings(ctx)));
            int actual = Mathf.RoundToInt(value * 100f);
            ctx.Assert(actual == percent, $"{name} reads {actual} percent, expected {percent}");
        }

        [Then("Contented Livestock the reset confirmation is open")]
        public void ConfirmationOpen(PickleContext ctx)
            => ctx.Assert(Find.WindowStack.Windows.OfType<Dialog_MessageBox>().Any(), "no confirmation dialog is open");

        [Then("Contented Livestock the reset confirmation is not open")]
        public void ConfirmationClosed(PickleContext ctx)
            => ctx.Assert(!Find.WindowStack.Windows.OfType<Dialog_MessageBox>().Any(), "a confirmation dialog is still open");

        [Then("Contented Livestock its settings dialog is still open")]
        public void SettingsStillOpen(PickleContext ctx)
            => ctx.Assert(Find.WindowStack.Windows.OfType<Dialog_ModSettings>().Any(), "the settings dialog is not open any more");

        // ---------------------------------------------------------------- contributions and their tip lines (scenario 16)

        private static string Capitalised(string word) => char.ToUpperInvariant(word[0]) + word.Substring(1);

        internal static float Contribution(PickleContext ctx, string kind, string name)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            var method = typeof(Need_Contentment).GetMethod(Capitalised(kind) + "Offset", Driver.InstanceAny);
            ctx.Require(method != null, $"Need_Contentment has no {Capitalised(kind)}Offset method: the kinds are feed, space, temperature, health, company");
            return (float)method.Invoke(need, null);
        }

        // The tip hides a line whose offset is under half a percent, so "not zero" uses the same threshold.
        [Then("Contented Livestock the {word} contribution to {string} is zero")]
        public void ContributionZero(PickleContext ctx, string kind, string name)
        {
            float value = Contribution(ctx, kind, name);
            ctx.Assert(Mathf.Abs(value) < 0.005f, $"the {kind} contribution to {name} is {value:0.000}, expected zero");
        }

        [Then("Contented Livestock the {word} contribution to {string} is not zero")]
        public void ContributionNotZero(PickleContext ctx, string kind, string name)
        {
            float value = Contribution(ctx, kind, name);
            ctx.Assert(Mathf.Abs(value) >= 0.005f, $"the {kind} contribution to {name} is {value:0.000}, expected something other than zero");
        }

        /// <summary>The text before the value of a tip line, so the check holds in whatever the wording is.</summary>
        private static string TipPrefix(PickleContext ctx, string kind)
        {
            string key = "ContentedLivestock.Tip." + Capitalised(kind);
            ctx.Require(key.CanTranslate(), $"no keyed text {key}");
            string text = key.Translate("\u0001").ToString();
            int at = text.IndexOf('\u0001');
            ctx.Require(at > 0, $"{key} does not start with text before its value");
            return text.Substring(0, at);
        }

        private static bool TipHasLine(PickleContext ctx, string kind, string name)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            return need.GetTipString().Contains(TipPrefix(ctx, kind));
        }

        [Then("Contented Livestock the tip of {string} has a {word} line")]
        public void TipHas(PickleContext ctx, string name, string kind)
            => ctx.Assert(TipHasLine(ctx, kind, name), $"the tip of {name} has no {kind} line");

        [Then("Contented Livestock the tip of {string} has no {word} line")]
        public void TipHasNot(PickleContext ctx, string name, string kind)
            => ctx.Assert(!TipHasLine(ctx, kind, name), $"the tip of {name} still has a {kind} line");

        // ---------------------------------------------------------------- speed of change (scenario 16)

        private static readonly Dictionary<string, float> recordedLevel = new Dictionary<string, float>();

        [When("Contented Livestock records the contentment level of {string}")]
        public void RecordLevel(PickleContext ctx, string name)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            recordedLevel[name] = need.CurLevel;
        }

        /// <summary>
        /// Runs the need's own interval a number of times. The animal must be far enough above its target
        /// that it cannot arrive within them, or the distance travelled would say nothing about the speed.
        /// </summary>
        [When("Contented Livestock runs {int} need intervals for {string}")]
        public void RunIntervals(PickleContext ctx, int count, string name)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            float expected = Driver.Settings(ctx).adjustSpeed * (150f / 60000f) * count;
            float gap = need.CurLevel - need.TargetLevel();
            ctx.Require(gap > expected + 0.02f,
                $"{name} is {gap:0.000} above its target and would travel {expected:0.000}: too close to tell a speed");
            for (int i = 0; i < count; i++) need.NeedInterval();
        }

        /// <summary>One interval with no distance check: what is asked here is where it ends up, not how far it went.</summary>
        [When("Contented Livestock lets {string} take one need interval")]
        public void OneInterval(PickleContext ctx, string name)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            need.NeedInterval();
        }

        [Then("Contented Livestock contentment of {string} has fallen by {int} hundredths of a point, give or take {int}")]
        public void FallenBy(PickleContext ctx, string name, int hundredths, int tolerance)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null && recordedLevel.ContainsKey(name), $"no level was recorded for {name}");
            float fallen = (recordedLevel[name] - need.CurLevel) * 10000f;
            ctx.Assert(Mathf.Abs(fallen - hundredths) <= tolerance,
                $"{name}'s contentment fell by {fallen:0} hundredths of a point, expected {hundredths} give or take {tolerance}");
        }

        [When("Contented Livestock puts {string} half a point above its target")]
        public void HalfPointAbove(PickleContext ctx, string name)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            need.CurLevel = need.TargetLevel() + 0.005f;
        }

        [Then("Contented Livestock contentment of {string} has come to rest on its target without going below it")]
        public void AtTarget(PickleContext ctx, string name)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            float target = need.TargetLevel();
            ctx.Assert(need.CurLevel >= target - 0.0001f, $"{name}'s contentment {need.CurLevel:0.0000} went below its target {target:0.0000}");
            ctx.Assert(need.CurLevel <= target + 0.0001f, $"{name}'s contentment {need.CurLevel:0.0000} has not reached its target {target:0.0000}");
        }
    }
}
