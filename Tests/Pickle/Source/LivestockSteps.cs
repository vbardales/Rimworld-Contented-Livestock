using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using RimWorld;
using RimWorks.Pickle;
using UnityEngine;
using Verse;

namespace ContentedLivestock.PickleSteps
{
    /// <summary>
    /// Steps for the scenarios that read company, harvesting and egg laying. Everything that reaches a
    /// non-public member of the game goes through reflection, so a rename shows up as a step that says
    /// which member it wanted rather than as an access exception.
    /// </summary>
    [PickleSteps]
    public class LivestockSteps
    {
        // ---------------------------------------------------------------- company (scenario 7)

        [Given("Contented Livestock spawns the player animal {string} as {string} beside {string}")]
        public void SpawnBeside(PickleContext ctx, string name, string kindName, string reference)
        {
            var anchor = Driver.PawnNamed(ctx, reference);
            AnimalSteps.Spawn(ctx, name, kindName, Faction.OfPlayer, 3f, anchor.Position, 3);
        }

        /// <summary>
        /// Company is cached and only recomputed every 2500 ticks. Waiting a game day, as the manual
        /// scenario does, is for the *level* to move; the offset itself is what this reads, right away.
        /// </summary>
        [When("Contented Livestock refreshes the surroundings of {string}")]
        public void RefreshSurroundings(PickleContext ctx, string name)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            need.InvalidateEnvironmentCache();
            need.TargetLevel();
        }

        private static int CompanyPercent(PickleContext ctx, string name)
        {
            var need = Contentment.NeedOf(Driver.PawnNamed(ctx, name));
            ctx.Require(need != null, $"{name} has no contentment need");
            var method = typeof(Need_Contentment).GetMethod("CompanyOffset", Driver.InstanceAny);
            ctx.Require(method != null, "Need_Contentment has no CompanyOffset method any more");
            return Mathf.RoundToInt((float)method.Invoke(need, null) * 100f);
        }

        [Then("Contented Livestock company for {string} is a penalty of {int} percent")]
        public void CompanyPenalty(PickleContext ctx, string name, int percent)
        {
            int actual = CompanyPercent(ctx, name);
            ctx.Assert(actual == -percent, $"{name}'s company is {actual} percent, expected a penalty of {percent}");
        }

        [Then("Contented Livestock company for {string} is a bonus of {int} percent")]
        public void CompanyBonus(PickleContext ctx, string name, int percent)
        {
            int actual = CompanyPercent(ctx, name);
            ctx.Assert(actual == percent, $"{name}'s company is {actual} percent, expected a bonus of {percent}");
        }

        [Then("Contented Livestock company for {string} is zero")]
        public void CompanyZero(PickleContext ctx, string name)
        {
            int actual = CompanyPercent(ctx, name);
            ctx.Assert(actual == 0, $"{name}'s company is {actual} percent, expected zero");
        }

        [When("Contented Livestock bonds {string} to the colonist {string}")]
        public void Bond(PickleContext ctx, string animalName, string colonistName)
        {
            var animal = Driver.PawnNamed(ctx, animalName);
            var colonist = Driver.PawnNamed(ctx, colonistName);
            ctx.Require(colonist.RaceProps.Humanlike && colonist.Faction == Faction.OfPlayer,
                $"{colonistName} is not a colonist");
            if (!colonist.relations.DirectRelationExists(PawnRelationDefOf.Bond, animal))
                colonist.relations.AddDirectRelation(PawnRelationDefOf.Bond, animal);
            if (!animal.relations.DirectRelationExists(PawnRelationDefOf.Bond, colonist))
                animal.relations.AddDirectRelation(PawnRelationDefOf.Bond, colonist);
            ctx.Assert(animal.relations.GetFirstDirectRelationPawn(PawnRelationDefOf.Bond, null) == colonist,
                $"{animalName} does not report a bond with {colonistName}");
        }

        /// <summary>
        /// Sends a colonist somewhere else, for a picture. After a camera jump Pickle's pointer rests at the
        /// screen centre and the game draws the tooltip of whoever stands under it: in the studio fixture the
        /// glade where the cows are put is the station of an actress, and her name floated beside the cow.
        /// Framing the cow off-centre was not enough, because she walks under the pointer while the game runs.
        /// </summary>
        [When("Contented Livestock sends the colonist {string} to x {int} and z {int}")]
        public void SendAway(PickleContext ctx, string name, int x, int z)
        {
            var pawn = Driver.PawnNamed(ctx, name);
            var map = Driver.Map(ctx);
            IntVec3 cell;
            ctx.Require(CellFinder.TryFindRandomCellNear(new IntVec3(x, 0, z), map, 8,
                c => c.Standable(map) && c.GetFirstPawn(map) == null, out cell),
                $"no free cell near {x},{z} to send {name} to");
            pawn.jobs?.StopAll();
            pawn.Position = cell;
            pawn.Notify_Teleported(true, true);
        }

        // ---------------------------------------------------------------- egg laying (scenarios 11 and 12)

        private static readonly Dictionary<string, float> eggStart = new Dictionary<string, float>();

        private static CompEggLayer Egg(PickleContext ctx, string name)
        {
            var comp = Driver.PawnNamed(ctx, name).TryGetComp<CompEggLayer>();
            ctx.Require(comp != null, $"{name} has no CompEggLayer");
            return comp;
        }

        private static FieldInfo EggField(PickleContext ctx)
        {
            var field = typeof(CompEggLayer).GetField("eggProgress", Driver.InstanceAny);
            ctx.Require(field != null, "CompEggLayer has no eggProgress field any more");
            return field;
        }

        private static float Progress(PickleContext ctx, CompEggLayer comp) => (float)EggField(ctx).GetValue(comp);

        [Given("Contented Livestock the map holds no male {string}")]
        public void NoMale(PickleContext ctx, string kindName)
        {
            var males = Driver.Map(ctx).mapPawns.AllPawns
                .Where(p => p.kindDef != null && p.kindDef.defName == kindName && p.gender == Gender.Male).ToList();
            ctx.Require(males.Count == 0, $"the map already holds {males.Count} male {kindName}: the hen would not stay unfertilised");
        }

        /// <summary>
        /// The vanilla reference. Without the need, Contentment.RateFactor returns exactly 1, so this hen
        /// runs the game's own code and nothing else: it is what the mod's hen is compared against.
        /// </summary>
        [When("Contented Livestock takes the contentment need away from {string}")]
        public void TakeNeedAway(PickleContext ctx, string name)
        {
            var pawn = Driver.PawnNamed(ctx, name);
            var need = Contentment.NeedOf(pawn);
            ctx.Require(need != null, $"{name} has no contentment need to take away");
            pawn.needs.AllNeeds.Remove(need);
            ctx.Assert(Contentment.NeedOf(pawn) == null, $"{name} still reports a contentment need after it was removed");
        }

        [When("Contented Livestock sets the egg progress of {string} to {int} percent")]
        public void SetEggProgress(PickleContext ctx, string name, int percent)
        {
            var comp = Egg(ctx, name);
            EggField(ctx).SetValue(comp, percent / 100f);
            eggStart[name] = percent / 100f;
        }

        [Then("Contented Livestock egg progress gained by {string} is {int} percent of that gained by {string}, give or take {int} points")]
        public void EggGainRelative(PickleContext ctx, string name, int expected, string referenceName, int tolerance)
        {
            ctx.Require(eggStart.ContainsKey(name) && eggStart.ContainsKey(referenceName), "no egg progress was recorded for both hens");
            float gain = Progress(ctx, Egg(ctx, name)) - eggStart[name];
            float reference = Progress(ctx, Egg(ctx, referenceName)) - eggStart[referenceName];
            if (Mathf.Abs(reference) < 0.000001f)
            {
                // Vanilla held this hen still. The mod must not have moved its hen either.
                ctx.Assert(Mathf.Abs(gain) < 0.000001f,
                    $"the vanilla hen {referenceName} held still but {name} moved by {gain:0.000000}");
                return;
            }
            float percent = gain / reference * 100f;
            ctx.Assert(Mathf.Abs(percent - expected) <= tolerance,
                $"{name} gained {gain:0.000000}, {percent:0}% of the {reference:0.000000} the vanilla hen {referenceName} gained; expected {expected}% give or take {tolerance}");
        }

        [Then("Contented Livestock the map holds no fertilised egg of {string}")]
        public void NoFertilisedEgg(PickleContext ctx, string name)
        {
            var props = Egg(ctx, name).props as CompProperties_EggLayer;
            ctx.Require(props != null, $"{name}'s egg comp has no properties");
            if (props.eggFertilizedDef == null) return;
            int count = Driver.Map(ctx).listerThings.ThingsOfDef(props.eggFertilizedDef).Count;
            ctx.Assert(count == 0, $"the map holds {count} {props.eggFertilizedDef.defName} although no male was present");
        }

        private static int EggsOnMap(PickleContext ctx, CompProperties_EggLayer props)
        {
            var lister = Driver.Map(ctx).listerThings;
            int count = 0;
            if (props.eggUnfertilizedDef != null) count += lister.ThingsOfDef(props.eggUnfertilizedDef).Sum(t => t.stackCount);
            if (props.eggFertilizedDef != null) count += lister.ThingsOfDef(props.eggFertilizedDef).Sum(t => t.stackCount);
            return count;
        }

        private static readonly Dictionary<string, int> eggsBefore = new Dictionary<string, int>();

        /// <summary>
        /// Lays an egg through the game's own method rather than waiting for the hen's job, which would
        /// make the scenario depend on the hen deciding to walk somewhere.
        /// </summary>
        [When("Contented Livestock makes {string} lay an egg now")]
        public void LayNow(PickleContext ctx, string name)
        {
            var comp = Egg(ctx, name);
            var props = comp.props as CompProperties_EggLayer;
            ctx.Require(props != null, $"{name}'s egg comp has no properties");
            var produce = typeof(CompEggLayer).GetMethod("ProduceEgg", Driver.InstanceAny);
            ctx.Require(produce != null, "CompEggLayer has no ProduceEgg method any more");
            EggField(ctx).SetValue(comp, 1f);
            eggsBefore[name] = EggsOnMap(ctx, props);
            produce.Invoke(comp, null);
            eggStart[name] = Progress(ctx, comp);
        }

        [Then("Contented Livestock {string} has laid an egg and starts again from zero")]
        public void LaidAndReset(PickleContext ctx, string name)
        {
            var comp = Egg(ctx, name);
            var props = comp.props as CompProperties_EggLayer;
            ctx.Require(props != null && eggsBefore.ContainsKey(name), $"no egg was laid on purpose for {name}");
            int after = EggsOnMap(ctx, props);
            ctx.Assert(after > eggsBefore[name], $"{name}'s egg progress was full but no egg appeared ({eggsBefore[name]} before, {after} after)");
            float progress = Progress(ctx, comp);
            ctx.Assert(progress < 0.01f, $"{name}'s egg progress is {progress:0.0000} after laying, not back at zero");
        }

        /// <summary>
        /// After one game hour a hen that started from zero has gained something, and no more than twice
        /// what the def gives with no mod. The bound comes from the def: a chicken lays every day, so an
        /// hour is about 4 percent, and at the top rate about 6.
        /// </summary>
        [Then("Contented Livestock the egg progress of {string} has risen but not by much")]
        public void EggRoseSlightly(PickleContext ctx, string name)
        {
            ctx.Require(eggStart.ContainsKey(name), $"no egg progress was recorded for {name}");
            var props = Egg(ctx, name).props as CompProperties_EggLayer;
            ctx.Require(props != null && props.eggLayIntervalDays > 0f, $"{name}'s egg comp has no interval");
            float bound = 2f * 2500f / (props.eggLayIntervalDays * 60000f);
            float gain = Progress(ctx, Egg(ctx, name)) - eggStart[name];
            ctx.Assert(gain > 0f && gain < bound,
                $"{name}'s egg progress moved by {gain:0.000000} in the hour after laying, expected more than zero and less than {bound:0.000000}");
        }

        // ---------------------------------------------------------------- harvesting (scenario 11)

        private static readonly Dictionary<string, List<int>> yields = new Dictionary<string, List<int>>();

        private static PropertyInfo Prop(PickleContext ctx, string name)
        {
            var property = typeof(CompHasGatherableBodyResource).GetProperty(name, Driver.InstanceAny);
            ctx.Require(property != null, $"CompHasGatherableBodyResource has no {name} property any more");
            return property;
        }

        private static int ThingsOnMap(PickleContext ctx, ThingDef def)
            => Driver.Map(ctx).listerThings.ThingsOfDef(def).Sum(t => t.stackCount);

        /// <summary>
        /// Gathers from a full animal through the game's own Gathered. The game can waste a yield by
        /// chance, depending on the gatherer's skill, so it is tried again until something comes out:
        /// what is measured is the size of a yield, never whether one happened.
        /// </summary>
        [When("Contented Livestock colonist {string} gathers from the full {string}")]
        public void GatherFull(PickleContext ctx, string doerName, string animalName)
        {
            var doer = Driver.PawnNamed(ctx, doerName);
            var comp = Driver.PawnNamed(ctx, animalName).TryGetComp<CompHasGatherableBodyResource>();
            ctx.Require(comp != null, $"{animalName} has nothing to gather");
            var resource = Prop(ctx, "ResourceDef").GetValue(comp, null) as ThingDef;
            ctx.Require(resource != null, $"{animalName}'s comp names no resource");

            int yield = 0;
            for (int attempt = 1; attempt <= 25 && yield == 0; attempt++)
            {
                comp.fullness = 1f;
                int before = ThingsOnMap(ctx, resource);
                comp.Gathered(doer);
                yield = ThingsOnMap(ctx, resource) - before;
                ctx.Assert(comp.fullness == 0f, $"{animalName}'s fullness is {comp.fullness:0.000} after gathering, not zero");
            }
            ctx.Require(yield > 0, $"25 gatherings from {animalName} by {doerName} all came out wasted");

            if (!yields.ContainsKey(animalName)) yields[animalName] = new List<int>();
            yields[animalName].Add(yield);
        }

        [Then("Contented Livestock the yield of {string} is what the game says a full one gives")]
        public void YieldIsGamesOwn(PickleContext ctx, string animalName)
        {
            var comp = Driver.PawnNamed(ctx, animalName).TryGetComp<CompHasGatherableBodyResource>();
            ctx.Require(comp != null && yields.ContainsKey(animalName), $"nothing was gathered from {animalName}");
            int expected = (int)Prop(ctx, "ResourceAmount").GetValue(comp, null);
            int actual = yields[animalName].Last();
            ctx.Assert(actual == expected, $"{animalName} yielded {actual}, the game says a full one gives {expected}");
        }

        [Then("Contented Livestock the last two yields of {string} are equal")]
        public void LastTwoEqual(PickleContext ctx, string animalName)
        {
            ctx.Require(yields.ContainsKey(animalName) && yields[animalName].Count >= 2, $"{animalName} was not gathered from twice");
            var list = yields[animalName];
            ctx.Assert(list[list.Count - 1] == list[list.Count - 2],
                $"{animalName} yielded {list[list.Count - 2]} and then {list[list.Count - 1]}: the amount changed with contentment");
        }
    }
}
