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
    }
}
