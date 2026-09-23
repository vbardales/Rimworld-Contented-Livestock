using System.Collections.Generic;
using System.IO;
using System.Reflection;
using RimWorks.Pickle;
using Verse;

namespace ContentedLivestock.PickleSteps
{
    [PickleSteps]
    public class SettingsSandbox
    {
        private static Dictionary<string, object> snapshot;
        private static string settingsPath;
        private static string backupPath;
        private static string chainMarkerPath;
        private static bool keepForNextLaunch;
        private static bool chainReader;

        private static FieldInfo[] Fields => typeof(ContentedLivestockSettings)
            .GetFields(BindingFlags.Public | BindingFlags.Instance | BindingFlags.DeclaredOnly);

        private static bool Loaded => LoadedModManager.GetMod<ContentedLivestockMod>() != null
                                      && ContentedLivestockMod.Settings != null;

        [BeforeScenario]
        public void Save(PickleContext ctx)
        {
            if (!Loaded) return;
            var mod = Driver.Mod(ctx);
            settingsPath = LoadedModManager.GetSettingsFilename(mod.Content.FolderName, mod.GetType().Name);
            backupPath = settingsPath + ".contented-pickle-backup";
            chainMarkerPath = settingsPath + ".contented-pickle-chain";
            chainReader = File.Exists(chainMarkerPath);
            keepForNextLaunch = false;
            if (chainReader) return;
            if (File.Exists(backupPath))
            {
                File.Copy(backupPath, settingsPath, true);
                File.Delete(backupPath);
            }
            if (File.Exists(settingsPath)) File.Copy(settingsPath, backupPath, true);

            snapshot = new Dictionary<string, object>();
            foreach (var field in Fields) snapshot[field.Name] = field.GetValue(ContentedLivestockMod.Settings);
        }

        [AfterScenario]
        public void Restore(PickleContext ctx)
        {
            if (!Loaded) return;
            if (keepForNextLaunch) return;
            if (chainReader)
            {
                // The writer scenario took a snapshot and skipped its own restore, so in a
                // single-process run that snapshot is still here and holds the pre-chain values.
                // Putting back only the file left the eleven distinctive values live in memory
                // for every scenario after this one. In a real two-process chain the reader
                // process starts with no snapshot and the process ends soon after: nothing to do.
                if (snapshot != null)
                {
                    foreach (var field in Fields) field.SetValue(ContentedLivestockMod.Settings, snapshot[field.Name]);
                    snapshot = null;
                    Driver.Mod(ctx).WriteSettings();
                }
                if (File.Exists(backupPath))
                {
                    File.Copy(backupPath, settingsPath, true);
                    File.Delete(backupPath);
                }
                else if (File.Exists(settingsPath)) File.Delete(settingsPath);
                if (File.Exists(chainMarkerPath)) File.Delete(chainMarkerPath);
                chainReader = false;
                return;
            }
            if (snapshot != null)
            {
                foreach (var field in Fields) field.SetValue(ContentedLivestockMod.Settings, snapshot[field.Name]);
                snapshot = null;
                Driver.Mod(ctx).WriteSettings();
            }
            if (File.Exists(backupPath))
            {
                File.Copy(backupPath, settingsPath, true);
                File.Delete(backupPath);
            }
            else if (File.Exists(settingsPath)) File.Delete(settingsPath);
        }

        public static void KeepForNextLaunch(PickleContext ctx)
        {
            ctx.Require(!string.IsNullOrEmpty(chainMarkerPath), "the settings sandbox has no chain marker path");
            File.WriteAllText(chainMarkerPath, "Contented Livestock Pickle restart chain");
            keepForNextLaunch = true;
        }
    }
}
