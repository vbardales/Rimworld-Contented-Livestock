using RimWorld;
using RimWorks.Pickle;
using UnityEngine;
using Verse;

namespace ContentedLivestock.PickleSteps
{
    [PickleSteps]
    public class AnimalSteps
    {
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

        private static void Spawn(PickleContext ctx, string name, string kindName, Faction faction)
        {
            var kind = DefDatabase<PawnKindDef>.GetNamedSilentFail(kindName);
            ctx.Require(kind != null, $"no PawnKindDef named '{kindName}'");
            var pawn = PawnGenerator.GeneratePawn(new PawnGenerationRequest(
                kind, faction, forceGenerateNewPawn: true, fixedGender: Gender.Female, fixedBiologicalAge: 3f));
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

        [Then("Contented Livestock production factor for {string} is {int} percent")]
        public void Rate(PickleContext ctx, string name, int expected)
        {
            var actual = Mathf.RoundToInt(Contentment.RateFactor(Driver.PawnNamed(ctx, name)) * 100f);
            ctx.Assert(actual == expected, $"production factor for {name} is {actual} percent, expected {expected}");
        }
    }
}
