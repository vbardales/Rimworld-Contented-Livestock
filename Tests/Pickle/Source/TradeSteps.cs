using RimWorld;
using RimWorks.Pickle;
using System.Linq;
using Verse;

namespace ContentedLivestock.PickleSteps
{
    /// <summary>
    /// Manual scenario M3: a trader sells a muffalo and the colony buys it through the game's own trade deal.
    /// The dialog is the real Dialog_Trade (its constructor sets the TradeSession up) and the purchase is
    /// the real TradeDeal.TryExecute, so Tradeable.ResolveTrade moves the animal and SetFaction runs.
    /// What is set in code is the choosing of the line to buy, since the dialog's rows have no name Pickle can click.
    /// </summary>
    [PickleSteps]
    public class TradeSteps
    {
        private const float PricePadding = 20000f;

        [Given("Contented Livestock has a trader {string} who sells a muffalo {string}")]
        public void TraderWithMuffalo(PickleContext ctx, string traderName, string muffaloName)
        {
            var map = Driver.Map(ctx);
            var faction = Find.FactionManager.AllFactionsListForReading.FirstOrDefault(f =>
                !f.IsPlayer && !f.def.hidden && f.def.humanlikeFaction && !f.HostileTo(Faction.OfPlayer));
            ctx.Require(faction != null, "no neutral visible humanlike faction is available to own the trader");

            var kind = DefDatabase<PawnKindDef>.AllDefs.FirstOrDefault(k => k.trader && k.RaceProps.Humanlike);
            ctx.Require(kind != null, "no humanlike PawnKindDef carries a trader kind");

            var trader = PawnGenerator.GeneratePawn(new PawnGenerationRequest(kind, faction, forceGenerateNewPawn: true));
            trader.Name = new NameSingle(traderName);
            AnimalSteps.Spawn(ctx, muffaloName, "Muffalo", faction);
            var muffalo = Driver.PawnNamed(ctx, muffaloName);

            var cell = CellFinder.RandomClosewalkCellNear(map.Center, map, 12);
            GenSpawn.Spawn(trader, cell, map);
            trader.mindState.wantsToTradeWithColony = true;
            if (muffalo.Spawned) muffalo.DeSpawn();
            ctx.Require(trader.inventory.innerContainer.TryAdd(muffalo),
                "the muffalo could not be put in the trader's inventory");

            var silver = ThingMaker.MakeThing(ThingDefOf.Silver);
            silver.stackCount = (int)PricePadding;
            GenPlace.TryPlaceThing(silver, map.Center, map, ThingPlaceMode.Near);
        }

        [When("Contented Livestock opens the trade dialog with {string}")]
        public void OpenTrade(PickleContext ctx, string traderName)
        {
            var trader = Driver.PawnNamed(ctx, traderName);
            var negotiator = Driver.Map(ctx).mapPawns.FreeColonistsSpawned.FirstOrDefault();
            ctx.Require(negotiator != null, "no free colonist can negotiate");
            Find.WindowStack.Add(new Dialog_Trade(negotiator, trader));
        }

        [Then("Contented Livestock sees the trade dialog list the muffalo {string}")]
        public void ListsMuffalo(PickleContext ctx, string muffaloName)
        {
            ctx.Assert(Find.WindowStack.WindowOfType<Dialog_Trade>() != null, "the trade dialog is not open");
            ctx.Assert(Line(muffaloName) != null, $"the trade deal has no line for the muffalo {muffaloName}");
        }

        [When("Contented Livestock buys the muffalo {string} in the trade dialog")]
        public void Buy(PickleContext ctx, string muffaloName)
        {
            var line = Line(muffaloName);
            ctx.Require(line != null, $"the trade deal has no line for the muffalo {muffaloName}");
            line.ForceToDestination(1);
            bool traded;
            var ok = TradeSession.deal.TryExecute(out traded);
            ctx.Assert(ok && traded, $"the deal was not executed (executed={ok}, traded={traded})");
        }

        [Then("Contented Livestock animal {string} now belongs to the player")]
        public void BelongsToPlayer(PickleContext ctx, string name)
        {
            var pawn = Driver.PawnNamed(ctx, name);
            ctx.Assert(pawn.Faction == Faction.OfPlayer, $"{name} belongs to {pawn.Faction?.Name ?? "nobody"}");
        }

        private static Tradeable Line(string muffaloName)
        {
            if (TradeSession.deal == null) return null;
            return TradeSession.deal.AllTradeables.FirstOrDefault(t =>
                t.AnyThing is Pawn p && p.Name != null && p.Name.ToStringShort == muffaloName);
        }
    }
}
