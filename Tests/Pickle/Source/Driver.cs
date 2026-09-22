using System;
using System.Linq;
using System.Reflection;
using System.Collections.Generic;
using RimWorks.Pickle;
using Verse;

namespace ContentedLivestock.PickleSteps
{
    public static class Driver
    {
        internal const BindingFlags InstanceAny = BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic;

        public static ContentedLivestockMod Mod(PickleContext ctx)
        {
            var mod = LoadedModManager.GetMod<ContentedLivestockMod>();
            ctx.Require(mod != null, "ContentedLivestockMod is not loaded in this process");
            return mod;
        }

        public static ContentedLivestockSettings Settings(PickleContext ctx)
        {
            Mod(ctx);
            ctx.Require(ContentedLivestockMod.Settings != null, "ContentedLivestockMod.Settings is null");
            return ContentedLivestockMod.Settings;
        }

        public static Map Map(PickleContext ctx)
        {
            ctx.Require(Current.Game != null && Find.CurrentMap != null,
                "no current map: load the test-colony fixture before this step");
            return Find.CurrentMap;
        }

        public static Pawn PawnNamed(PickleContext ctx, string name)
        {
            IReadOnlyList<Pawn> pawns = Map(ctx).mapPawns.AllPawnsSpawned;
            var pawn = pawns.FirstOrDefault(p =>
                (p.Name is NameSingle single && single.Name == name) || p.LabelShort == name);
            ctx.Require(pawn != null, $"no spawned pawn named '{name}'");
            return pawn;
        }

        public static RimWorld.Dialog_ModSettings SettingsDialog(PickleContext ctx)
        {
            var dialog = Find.WindowStack.Windows.OfType<RimWorld.Dialog_ModSettings>().FirstOrDefault();
            ctx.Require(dialog != null, "no Dialog_ModSettings is open");
            return dialog;
        }

        public static Verse.Mod DialogMod(PickleContext ctx, RimWorld.Dialog_ModSettings dialog)
        {
            var field = typeof(RimWorld.Dialog_ModSettings).GetFields(InstanceAny)
                .FirstOrDefault(f => typeof(Verse.Mod).IsAssignableFrom(f.FieldType));
            ctx.Require(field != null, "Dialog_ModSettings has no Mod-typed field in this game build");
            return field.GetValue(dialog) as Verse.Mod;
        }
    }
}
