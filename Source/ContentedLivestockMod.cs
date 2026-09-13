using HarmonyLib;
using RimWorld;
using UnityEngine;
using Verse;

namespace ContentedLivestock
{
    public class ContentedLivestockMod : Mod
    {
        public const string HarmonyId = "nelim.contentedlivestock";

        public static ContentedLivestockMod Instance { get; private set; }
        public static ContentedLivestockSettings Settings { get; private set; }
        public static Harmony HarmonyInstance { get; private set; }

        private Vector2 scrollPosition;
        private float viewHeight;

        public ContentedLivestockMod(ModContentPack content) : base(content)
        {
            Instance = this;
            Settings = GetSettings<ContentedLivestockSettings>();

            HarmonyInstance = new Harmony(HarmonyId);
            HarmonyInstance.PatchAll();
        }

        public override string SettingsCategory() => "ContentedLivestock.Settings.Category".Translate();

        public override void WriteSettings()
        {
            Settings.Normalize();
            if (Current.Game != null)
            {
                foreach (var pawn in PawnsFinder.AllMapsWorldAndTemporary_Alive)
                {
                    if (pawn.RaceProps == null || !pawn.RaceProps.Animal || pawn.needs == null) continue;
                    pawn.needs.AddOrRemoveNeedsAsAppropriate();
                    Contentment.NeedOf(pawn)?.InvalidateEnvironmentCache();
                }
            }
            base.WriteSettings();
        }

        public override void DoSettingsWindowContents(Rect inRect)
        {
            var settings = Settings;
            settings.Normalize();
            var viewRect = new Rect(0f, 0f, inRect.width - 20f, Mathf.Max(viewHeight, inRect.height));

            Widgets.BeginScrollView(inRect, ref scrollPosition, viewRect);
            var listing = new Listing_Standard();
            listing.Begin(viewRect);

            listing.Label("ContentedLivestock.Settings.Intro".Translate());
            listing.Label("ContentedLivestock.Settings.Scope".Translate());
            listing.GapLine();

            listing.Label("ContentedLivestock.Settings.CurveHeader".Translate());

            settings.floorLevel = PercentRow(listing,
                "ContentedLivestock.Settings.Floor", settings.floorLevel, 0f, 0.5f,
                "ContentedLivestock.Settings.FloorTip");
            settings.plateauLevel = PercentRow(listing,
                "ContentedLivestock.Settings.Plateau", settings.plateauLevel, 0.3f, 0.9f,
                "ContentedLivestock.Settings.PlateauTip");
            settings.minRateFactor = PercentRow(listing,
                "ContentedLivestock.Settings.MinRate", settings.minRateFactor, 0f, 1f,
                "ContentedLivestock.Settings.MinRateTip");
            settings.maxRateFactor = PercentRow(listing,
                "ContentedLivestock.Settings.MaxRate", settings.maxRateFactor, 1f, 2f,
                "ContentedLivestock.Settings.MaxRateTip");

            // The floor can never sit above the plateau: the curve between them would invert.
            settings.plateauLevel = Mathf.Max(settings.plateauLevel, settings.floorLevel + 0.05f);

            settings.adjustSpeed = PercentRow(listing,
                "ContentedLivestock.Settings.Speed", settings.adjustSpeed, 0.25f, 4f,
                "ContentedLivestock.Settings.SpeedTip");

            listing.GapLine();
            listing.Label("ContentedLivestock.Settings.InputsHeader".Translate());

            listing.CheckboxLabeled("ContentedLivestock.Settings.Feed".Translate(),
                ref settings.feedMatters, "ContentedLivestock.Settings.FeedTip".Translate());
            listing.CheckboxLabeled("ContentedLivestock.Settings.Space".Translate(),
                ref settings.penMatters, "ContentedLivestock.Settings.SpaceTip".Translate());
            listing.CheckboxLabeled("ContentedLivestock.Settings.Temperature".Translate(),
                ref settings.temperatureMatters, "ContentedLivestock.Settings.TemperatureTip".Translate());
            listing.CheckboxLabeled("ContentedLivestock.Settings.Health".Translate(),
                ref settings.healthMatters, "ContentedLivestock.Settings.HealthTip".Translate());
            listing.CheckboxLabeled("ContentedLivestock.Settings.Company".Translate(),
                ref settings.companyMatters, "ContentedLivestock.Settings.CompanyTip".Translate());

            listing.GapLine();
            listing.CheckboxLabeled("ContentedLivestock.Settings.ProducersOnly".Translate(),
                ref settings.producersOnly, "ContentedLivestock.Settings.ProducersOnlyTip".Translate());

            listing.Gap();
            if (listing.ButtonText("ContentedLivestock.Settings.Reset".Translate()))
            {
                Find.WindowStack.Add(Dialog_MessageBox.CreateConfirmation(
                    "ContentedLivestock.Settings.ConfirmReset".Translate(),
                    settings.Reset,
                    destructive: true));
            }

            viewHeight = listing.CurHeight + 12f;
            settings.Normalize();
            listing.End();
            Widgets.EndScrollView();
        }

        /// <summary>A slider shown as a percentage, stored as a factor.</summary>
        private static float PercentRow(Listing_Standard listing, string key, float value,
            float min, float max, string tooltipKey = null)
        {
            int percent = Mathf.RoundToInt(value * 100f);
            string label = key.Translate(percent);
            string tooltip = tooltipKey == null ? null : (string)tooltipKey.Translate();
            float updated = listing.SliderLabeled(label, percent, min * 100f, max * 100f, 0.62f, tooltip);
            return Mathf.Clamp(Mathf.Round(updated) / 100f, min, max);
        }
    }
}
