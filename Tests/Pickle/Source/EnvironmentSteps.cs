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
    /// Steps for the scenarios that need the world to be arranged: an animal that eats, a cold that comes
    /// and goes, a fenced pen. Each one names, in its failure message, the thing of the game it could not
    /// find or the premise it could not set up, because these are the steps most likely to meet a game that
    /// does not behave as assumed.
    /// </summary>
    [PickleSteps]
    public class EnvironmentSteps
    {
        private static async Task RunTicks(PickleContext ctx, int ticks)
        {
            var previous = Find.TickManager.CurTimeSpeed;
            Find.TickManager.CurTimeSpeed = TimeSpeed.Superfast;
            try { await ctx.WaitTicks(ticks); }
            finally { Find.TickManager.CurTimeSpeed = previous; }
        }

        [When("Contented Livestock lets the game run {int} ticks", TimeoutSeconds = 60f)]
        public async Task LetItRun(PickleContext ctx, int ticks) => await RunTicks(ctx, ticks);

        // ---------------------------------------------------------------- signs and comparisons of contributions

        [Then("Contented Livestock the {word} contribution to {string} is positive")]
        public void Positive(PickleContext ctx, string kind, string name)
        {
            float value = SettingsEffectSteps.Contribution(ctx, kind, name);
            ctx.Assert(value >= 0.005f, $"the {kind} contribution to {name} is {value:0.000}, expected a positive one");
        }

        [Then("Contented Livestock the {word} contribution to {string} is negative")]
        public void Negative(PickleContext ctx, string kind, string name)
        {
            float value = SettingsEffectSteps.Contribution(ctx, kind, name);
            ctx.Assert(value <= -0.005f, $"the {kind} contribution to {name} is {value:0.000}, expected a negative one");
        }

        [Then("Contented Livestock the {word} contribution to {string} is lower than the one to {string}")]
        public void Lower(PickleContext ctx, string kind, string name, string other)
        {
            float a = SettingsEffectSteps.Contribution(ctx, kind, name);
            float b = SettingsEffectSteps.Contribution(ctx, kind, other);
            ctx.Assert(a < b - 0.005f, $"the {kind} contribution is {a:0.000} for {name} and {b:0.000} for {other}: expected the first to be lower");
        }

        // ---------------------------------------------------------------- feeding (scenario 4)

        /// <summary>
        /// Feeds an animal through the game's own Thing.Ingested, the funnel the mod patches, with a real
        /// thing of the def: a rooted grass plant for grazing, a stack of hay or of kibble otherwise. Setting
        /// the need's memory directly would prove nothing about the patch or about telling grazing from hay.
        /// </summary>
        [When("Contented Livestock lets {string} eat {word}")]
        public void Eat(PickleContext ctx, string name, string food)
        {
            var pawn = Driver.PawnNamed(ctx, name);
            var map = Driver.Map(ctx);
            string defName = food == "grass" ? "Plant_Grass" : food == "hay" ? "Hay" : food == "kibble" ? "Kibble" : null;
            ctx.Require(defName != null, $"'{food}' is not one of grass, hay, kibble");
            var def = DefDatabase<ThingDef>.GetNamedSilentFail(defName);
            ctx.Require(def != null, $"no ThingDef named '{defName}'");

            var thing = ThingMaker.MakeThing(def);
            if (thing is Plant plant) plant.Growth = 1f;
            else thing.stackCount = 5;
            ctx.Require(GenPlace.TryPlaceThing(thing, pawn.Position, map, ThingPlaceMode.Near),
                $"no room to put {defName} beside {name}");
            thing.Ingested(pawn, 0.3f);
        }

        [When("Contented Livestock moves the last meal of {string} back by {int} game hours")]
        public void MealBack(PickleContext ctx, string name, int hours)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            var field = typeof(Need_Contentment).GetField("lastFeedTick", Driver.InstanceAny);
            ctx.Require(field != null, "Need_Contentment has no lastFeedTick field any more");
            field.SetValue(need, (int)field.GetValue(need) - hours * 2500);
        }

        [Then("Contented Livestock the contentment target of {string} is above that of {string}")]
        public void TargetAbove(PickleContext ctx, string name, string other)
        {
            var a = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            var b = Contentment.NeedOf(Driver.PawnNamed(ctx, other));
            ctx.Require(a != null && b != null, "both animals need a contentment need");
            ctx.Assert(a.TargetLevel() > b.TargetLevel() + 0.005f,
                $"the target of {name} is {a.TargetLevel():0.000}, that of {other} {b.TargetLevel():0.000}: expected the first to be higher");
        }

        /// <summary>One game day is 400 intervals of 150 ticks; at the default speed that is one full swing.</summary>
        [When("Contented Livestock lets {string} live {int} need intervals")]
        public void Live(PickleContext ctx, string name, int count)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            for (int i = 0; i < count; i++) need.NeedInterval();
        }

        [Then("Contented Livestock contentment of {string} is above that of {string}")]
        public void LevelAbove(PickleContext ctx, string name, string other)
        {
            var a = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            var b = Contentment.NeedOf(Driver.PawnNamed(ctx, other));
            ctx.Require(a != null && b != null, "both animals need a contentment need");
            ctx.Assert(a.CurLevel > b.CurLevel + 0.005f,
                $"{name} is at {a.CurLevel:0.000} and {other} at {b.CurLevel:0.000}: expected the first to be higher");
        }

        // ---------------------------------------------------------------- cold (scenario 5)

        private static GameCondition cold;

        /// <summary>
        /// A cold snap whose offset is worked out from the animal's own cold limit, so the test does not
        /// depend on the fixture's weather or on any animal's band being what it was assumed to be.
        /// </summary>
        [When("Contented Livestock starts a cold snap that puts the outdoors {int} degrees below the cold limit of {string}")]
        public void StartCold(PickleContext ctx, int degrees, string name)
        {
            var map = Driver.Map(ctx);
            var pawn = Driver.PawnNamed(ctx, name);
            var def = DefDatabase<GameConditionDef>.GetNamedSilentFail("ColdSnap");
            ctx.Require(def != null, "no GameConditionDef named ColdSnap");

            float limit = pawn.ComfortableTemperatureRange().min;
            float offset = limit - degrees - map.mapTemperature.OutdoorTemp;
            cold = GameConditionMaker.MakeCondition(def, 60000);
            var field = cold.GetType().GetField("tempOffset", Driver.InstanceAny);
            ctx.Require(field != null, $"{cold.GetType().Name} has no tempOffset field: the offset of the cold snap cannot be set");
            field.SetValue(cold, offset);
            map.gameConditionManager.RegisterCondition(cold);
        }

        [When("Contented Livestock ends the cold snap")]
        public void EndCold(PickleContext ctx)
        {
            ctx.Require(cold != null, "no cold snap was started");
            cold.End();
        }

        // ---------------------------------------------------------------- pen (scenario 8)

        private static readonly Dictionary<string, float> recordedSpace = new Dictionary<string, float>();

        private static IntVec3 PenOrigin(Map map, int size) => new IntVec3(map.Center.x - size / 2, 0, map.Center.z - size / 2);

        /// <summary>
        /// A closed ring of fence around a square of soil at the middle of the map, with a pen marker inside.
        /// Whatever stood there is cleared first. Nothing else is assumed: the next step checks that the game
        /// recognises the pen.
        /// </summary>
        [Given("Contented Livestock builds a fenced pen {int} cells wide on soil at the middle of the map")]
        public void BuildPen(PickleContext ctx, int size)
        {
            var map = Driver.Map(ctx);
            var fence = DefDatabase<ThingDef>.GetNamedSilentFail("Fence");
            var marker = DefDatabase<ThingDef>.GetNamedSilentFail("PenMarker");
            ctx.Require(fence != null, "no ThingDef named Fence");
            ctx.Require(marker != null, "no ThingDef named PenMarker");
            var stuff = GenStuff.DefaultStuffFor(fence);
            var origin = PenOrigin(map, size);

            for (int x = origin.x - 1; x <= origin.x + size; x++)
            {
                for (int z = origin.z - 1; z <= origin.z + size; z++)
                {
                    var cell = new IntVec3(x, 0, z);
                    ctx.Require(cell.InBounds(map), $"the pen would leave the map at {cell}");
                    foreach (var thing in cell.GetThingList(map).ToList())
                        if (thing.def.destroyable && !(thing is Pawn)) thing.Destroy();
                    bool ring = x == origin.x - 1 || x == origin.x + size || z == origin.z - 1 || z == origin.z + size;
                    if (ring)
                    {
                        var post = ThingMaker.MakeThing(fence, stuff);
                        post.SetFaction(Faction.OfPlayer);
                        GenSpawn.Spawn(post, cell, map);
                    }
                    else map.terrainGrid.SetTerrain(cell, TerrainDefOf.Soil);
                }
            }

            var pen = ThingMaker.MakeThing(marker);
            pen.SetFaction(Faction.OfPlayer);
            GenSpawn.Spawn(pen, origin, map);
        }

        [Given("Contented Livestock spawns the player animal {string} as {string} inside the pen")]
        public void SpawnInPen(PickleContext ctx, string name, string kindName)
        {
            var map = Driver.Map(ctx);
            AnimalSteps.Spawn(ctx, name, kindName, Faction.OfPlayer, 3f, map.Center, 1);
        }

        private static CompAnimalPenMarker PenOf(PickleContext ctx, string name)
        {
            var pawn = Driver.PawnNamed(ctx, name);
            var marker = AnimalPenUtility.GetCurrentPenOf(pawn, allowUnenclosedPens: true);
            ctx.Require(marker != null, $"{name} is not inside a pen the game recognises: the fence may not be closed, or the map has not updated its regions yet");
            return marker;
        }

        private static void Figures(PickleContext ctx, string name, out float grown, out float eaten)
        {
            var food = PenOf(ctx, name).PenFoodCalculator;
            ctx.Require(food != null, $"the pen of {name} has no food calculator");
            grown = food.NutritionPerDayToday;
            eaten = food.SumNutritionConsumptionPerDay;
        }

        [Then("Contented Livestock the pen holding {string} grows less than its animals eat")]
        public void PenGrowsLess(PickleContext ctx, string name)
        {
            Figures(ctx, name, out float grown, out float eaten);
            ctx.Assert(grown < eaten, $"the pen of {name} grows {grown:0.00} nutrition a day and its animals eat {eaten:0.00}: it sustains them, so the premise of a pen it cannot feed does not hold");
        }

        /// <summary>The pen's own two figures, and the mod's formula on them, computed here without the mod's code.</summary>
        [Then("Contented Livestock the pasture contribution to {string} follows its pen's own figures")]
        public void FollowsPen(PickleContext ctx, string name)
        {
            Figures(ctx, name, out float grown, out float eaten);
            float expected = eaten <= 0f ? 0.1f : Mathf.Clamp((grown / eaten - 1f) * 0.2f, -0.2f, 0.2f);
            float actual = SettingsEffectSteps.Contribution(ctx, "space", name);
            ctx.Assert(Mathf.Abs(actual - expected) < 0.006f,
                $"the pen of {name} grows {grown:0.00} and its animals eat {eaten:0.00} a day, so the contribution should be {expected:0.000}, and it is {actual:0.000}");
        }

        [When("Contented Livestock records the pasture contribution of {string}")]
        public void RecordSpace(PickleContext ctx, string name)
            => recordedSpace[name] = SettingsEffectSteps.Contribution(ctx, "space", name);

        [Then("Contented Livestock the pasture contribution to {string} is above the recorded one")]
        public void SpaceAbove(PickleContext ctx, string name)
        {
            ctx.Require(recordedSpace.ContainsKey(name), $"no pasture contribution was recorded for {name}");
            float now = SettingsEffectSteps.Contribution(ctx, "space", name);
            ctx.Assert(now > recordedSpace[name] + 0.002f, $"the pasture contribution to {name} is {now:0.000}, it was {recordedSpace[name]:0.000}: expected it to rise");
        }

        [When("Contented Livestock removes the animal {string} from the map")]
        public void Remove(PickleContext ctx, string name) => Driver.PawnNamed(ctx, name).Destroy();

        [When("Contented Livestock selects the pen marker of the pen holding {string}")]
        public void SelectMarker(PickleContext ctx, string name)
        {
            var marker = PenOf(ctx, name);
            Find.Selector.ClearSelection();
            Find.Selector.Select(marker.parent);
            Find.CameraDriver.JumpToCurrentMapLoc(marker.parent.Position);
        }
    }
}
