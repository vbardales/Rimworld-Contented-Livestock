using Verse;

namespace ContentedLivestock
{
    public class ContentedLivestockSettings : ModSettings
    {
        /// <summary>Below this level of contentment nothing accumulates at all.</summary>
        public float floorLevel = 0.25f;

        /// <summary>At and above this level the animal fills at its normal rate or better.</summary>
        public float plateauLevel = 0.60f;

        /// <summary>Rate multiplier just above the floor.</summary>
        public float minRateFactor = 0.40f;

        /// <summary>Rate multiplier at full contentment.</summary>
        public float maxRateFactor = 1.40f;

        /// <summary>Only animals that actually produce something get the need.</summary>
        public bool producersOnly = true;

        /// <summary>How much of a full swing contentment can travel in one day.</summary>
        public float adjustSpeed = 1f;

        public bool feedMatters = true;
        public bool penMatters = true;
        public bool temperatureMatters = true;
        public bool healthMatters = true;
        public bool companyMatters = true;

        public void Reset()
        {
            floorLevel = 0.25f;
            plateauLevel = 0.60f;
            minRateFactor = 0.40f;
            maxRateFactor = 1.40f;
            producersOnly = true;
            adjustSpeed = 1f;
            feedMatters = true;
            penMatters = true;
            temperatureMatters = true;
            healthMatters = true;
            companyMatters = true;
        }

        public override void ExposeData()
        {
            base.ExposeData();
            Scribe_Values.Look(ref floorLevel, "floorLevel", 0.25f);
            Scribe_Values.Look(ref plateauLevel, "plateauLevel", 0.60f);
            Scribe_Values.Look(ref minRateFactor, "minRateFactor", 0.40f);
            Scribe_Values.Look(ref maxRateFactor, "maxRateFactor", 1.40f);
            Scribe_Values.Look(ref producersOnly, "producersOnly", true);
            Scribe_Values.Look(ref adjustSpeed, "adjustSpeed", 1f);
            Scribe_Values.Look(ref feedMatters, "feedMatters", true);
            Scribe_Values.Look(ref penMatters, "penMatters", true);
            Scribe_Values.Look(ref temperatureMatters, "temperatureMatters", true);
            Scribe_Values.Look(ref healthMatters, "healthMatters", true);
            Scribe_Values.Look(ref companyMatters, "companyMatters", true);
        }
    }
}
