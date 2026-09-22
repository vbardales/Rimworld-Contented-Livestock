using RimWorld;
using RimWorks.Pickle;
using System.Threading.Tasks;
using UnityEngine;
using Verse;

namespace ContentedLivestock.PickleSteps
{
    [PickleSteps]
    public class AnimalSteps
    {
        private static float recordedFullness;
        private static IntVec3 FreeCell(PickleContext ctx)
        {
            var map = Driver.Map(ctx);
            IntVec3 cell;
            var found = CellFinder.TryFindRandomCellNear(map.Center, map, 20,
                c => c.Standable(map) && c.GetEdifice(map) == null && c.GetFirstPawn(map) == null,
                out cell);
            ctx.Require(found, "no free standable cell was found near the map center");
            return cell;
        }

        [Given("Contented Livestock spawns the player animal {string} as {string}")]
        public void SpawnPlayerAnimal(PickleContext ctx, string name, string kindName)
        {
            Spawn(ctx, name, kindName, Faction.OfPlayer);
        }

        [Given("Contented Livestock spawns the wild animal {string} as {string}")]
        public void SpawnWildAnimal(PickleContext ctx, string name, string kindName)
        {
            Spawn(ctx, name, kindName, null);
        }

        [Given("Contented Livestock spawns the player pawn {string} as {string}")]
        public void SpawnPlayerPawn(PickleContext ctx, string name, string kindName)
        {
            Spawn(ctx, name, kindName, Faction.OfPlayer, 25f);
        }

        private static void Spawn(PickleContext ctx, string name, string kindName, Faction faction,
            float biologicalAge = 3f)
        {
            var kind = DefDatabase<PawnKindDef>.GetNamedSilentFail(kindName);
            ctx.Require(kind != null, $"no PawnKindDef named '{kindName}'");
            var pawn = PawnGenerator.GeneratePawn(new PawnGenerationRequest(
                kind, faction, forceGenerateNewPawn: true, fixedGender: Gender.Female,
                fixedBiologicalAge: biologicalAge));
            pawn.Name = new NameSingle(name);
            GenSpawn.Spawn(pawn, FreeCell(ctx), Driver.Map(ctx));
            pawn.needs.AddOrRemoveNeedsAsAppropriate();
        }

        [When("Contented Livestock sets producers-only to {word} and applies settings")]
        public void SetProducersOnly(PickleContext ctx, string value)
        {
            bool parsed;
            ctx.Require(bool.TryParse(value, out parsed), $"'{value}' is not true or false");
            Driver.Settings(ctx).producersOnly = parsed;
            Driver.Mod(ctx).WriteSettings();
        }

        [When("Contented Livestock gives {string} to the player faction")]
        public void JoinPlayer(PickleContext ctx, string name) => Driver.PawnNamed(ctx, name).SetFaction(Faction.OfPlayer);

        [When("Contented Livestock removes {string} from every faction")]
        public void LeavePlayer(PickleContext ctx, string name) => Driver.PawnNamed(ctx, name).SetFaction(null);

        [When("Contented Livestock selects animal {string} for visual evidence")]
        public void SelectForEvidence(PickleContext ctx, string name)
        {
            var pawn = Driver.PawnNamed(ctx, name);
            Find.Selector.ClearSelection();
            Find.Selector.Select(pawn);
            Find.CameraDriver.JumpToCurrentMapLoc(pawn.Position);
            InspectPaneUtility.OpenTab(typeof(ITab_Pawn_Needs));
        }

        [Then("Contented Livestock animal {string} has the contentment need")]
        public void HasNeed(PickleContext ctx, string name)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Assert(need != null, $"{name} has no Nelim_Contentment need");
        }

        [Then("Contented Livestock animal {string} has no contentment need")]
        public void HasNoNeed(PickleContext ctx, string name)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Assert(need == null, $"{name} unexpectedly has a Nelim_Contentment need");
        }

        [Then("Contented Livestock animal {string} starts at {int} percent contentment")]
        public void InitialLevel(PickleContext ctx, string name, int expected)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            var actual = Mathf.RoundToInt(need.CurLevelPercentage * 100f);
            ctx.Assert(actual == expected, $"{name} starts at {actual} percent, expected {expected}");
        }

        [When("Contented Livestock sets {string} to {int} percent contentment")]
        public void SetLevel(PickleContext ctx, string name, int percent)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            need.CurLevelPercentage = percent / 100f;
        }

        [When("Contented Livestock records that {string} ate {string}")]
        public void Ate(PickleContext ctx, string name, string defName)
        {
            var def = DefDatabase<ThingDef>.GetNamedSilentFail(defName);
            ctx.Require(def != null, $"no ThingDef named '{defName}'");
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            need.Notify_Ate(ThingMaker.MakeThing(def));
        }

        [Then("Contented Livestock animal {string} is at {int} percent contentment")]
        public void CurrentLevel(PickleContext ctx, string name, int expected)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            var actual = Mathf.RoundToInt(need.CurLevelPercentage * 100f);
            ctx.Assert(actual == expected, $"{name} is at {actual} percent, expected {expected}");
        }

        [Then("Contented Livestock animal {string} has feed offset {int} percent")]
        public void FeedOffset(PickleContext ctx, string name, int expected)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            var actual = Mathf.RoundToInt(need.FeedOffset() * 100f);
            ctx.Assert(actual == expected, $"{name}'s feed offset is {actual} percent, expected {expected}");
        }

        [When("Contented Livestock records the milk fullness of {string}")]
        public void RecordMilkFullness(PickleContext ctx, string name)
        {
            var comp = Driver.PawnNamed(ctx, name).TryGetComp<CompMilkable>();
            ctx.Require(comp != null, $"{name} has no CompMilkable");
            recordedFullness = comp.fullness;
        }

        [When("Contented Livestock waits one game hour", TimeoutSeconds = 60f)]
        public async Task WaitOneHour(PickleContext ctx)
        {
            var previous = Find.TickManager.CurTimeSpeed;
            Find.TickManager.CurTimeSpeed = TimeSpeed.Superfast;
            try
            {
                await ctx.WaitTicks(2500);
            }
            finally
            {
                Find.TickManager.CurTimeSpeed = previous;
            }
        }

        [Then("Contented Livestock milk fullness of {string} has increased")]
        public void MilkFullnessIncreased(PickleContext ctx, string name)
        {
            var comp = Driver.PawnNamed(ctx, name).TryGetComp<CompMilkable>();
            ctx.Require(comp != null, $"{name} has no CompMilkable");
            ctx.Assert(comp.fullness > recordedFullness,
                $"{name}'s milk fullness is {comp.fullness:0.000000}, not above {recordedFullness:0.000000}");
        }

        [Then("Contented Livestock production factor for {string} is {int} percent")]
        public void Rate(PickleContext ctx, string name, int expected)
        {
            var actual = Mathf.RoundToInt(Contentment.RateFactor(Driver.PawnNamed(ctx, name)) * 100f);
            ctx.Assert(actual == expected, $"production factor for {name} is {actual} percent, expected {expected}");
        }
    }
}
