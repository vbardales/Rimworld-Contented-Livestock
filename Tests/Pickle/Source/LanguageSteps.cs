using System.Linq;
using RimWorks.Pickle;
using Verse;

namespace ContentedLivestock.PickleSteps
{
    [PickleSteps]
    public class LanguageSteps
    {
        private const string Prefix = "ContentedLivestock.";
        private const int OwnedKeys = 36;

        [Then("every Contented Livestock keyed text exists in the language this pass runs")]
        public void EveryKey(PickleContext ctx)
        {
            var active = LanguageDatabase.activeLanguage;
            ctx.Require(active != null, "no active language is loaded");
            var english = LanguageDatabase.defaultLanguage;
            // A non-English pass may not have loaded the English fallback yet: load it so the count is not 0.
            if (english.keyedReplacements.Count == 0 && !english.dataIsLoaded)
            {
                english.LoadData();
            }
            var keys = english.keyedReplacements.Keys
                .Where(k => k.StartsWith(Prefix)).ToList();
            ctx.Assert(keys.Count >= OwnedKeys,
                $"only {keys.Count} English keys start with '{Prefix}', expected at least {OwnedKeys}");
            var missing = keys.Where(k => !active.HaveTextForKey(k)).ToList();
            ctx.Assert(missing.Count == 0,
                $"{active.folderName} has no text for: {string.Join(", ", missing.ToArray())}");
        }
    }
}
