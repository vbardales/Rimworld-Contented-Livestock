# Manual scenario 16: each setting has its effect when play resumes. Seven scenarios: the five inputs one by
# one, the rate curve at distinctive values, and the speed of change.
#
# Each input is switched off through the setting and its writing, which is what closing the window does to
# the animals, and the contribution and the tip line are read before, during and after. A contribution
# needs an animal that has one: a cow that has eaten (feed), a husky outdoors (pasture: a grazer is judged
# on its pen and has none here, a husky on its room, and it needs producers-only off to have the need at
# all), a cow at a comfortable temperature (temperature), a cow with a bleeding cut (health), and a
# muffalo alone (company). The tip is the game's own text for the need, in a message box moved to the
# top left, so the person sees the line come and go.
#
# Not repeated here, because other features cover them: producers-only takes effect without reloading
# (feature 17), and nothing already accumulated is lost (scenario 10, feature 15). The speed is measured
# over the need's own intervals, not over a wait, so it is exact and does not depend on the clock.
@review
Feature: Scenario 16 - each setting has its effect

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs
    And Contented Livestock restores its default settings

  Scenario: the feed input, off and on again
    Given Contented Livestock spawns the player animal "ScenarioSixteenFeed" as "Cow"
    When Contented Livestock records that "ScenarioSixteenFeed" ate "RawCorn"
    Then Contented Livestock the feed contribution to "ScenarioSixteenFeed" is not zero
    And Contented Livestock the tip of "ScenarioSixteenFeed" has a feed line
    When Contented Livestock selects animal "ScenarioSixteenFeed" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioSixteenFeed" at the top left
    Then I take a screenshot "scenario 16 - feed input on, the Feed line is in the tip"
    When I close all dialogs
    And Contented Livestock sets setting "feedMatters" to "false" and writes settings
    Then Contented Livestock the feed contribution to "ScenarioSixteenFeed" is zero
    And Contented Livestock the tip of "ScenarioSixteenFeed" has no feed line
    When Contented Livestock opens the live contentment tip for "ScenarioSixteenFeed" at the top left
    Then I take a screenshot "scenario 16 - feed input off, the Feed line is gone"
    When I close all dialogs
    And Contented Livestock sets setting "feedMatters" to "true" and writes settings
    Then Contented Livestock the feed contribution to "ScenarioSixteenFeed" is not zero
    And Contented Livestock the tip of "ScenarioSixteenFeed" has a feed line
    And no errors were logged

  Scenario: the pasture or room input, off and on again
    Given Contented Livestock spawns the player animal "ScenarioSixteenSpace" as "Husky"
    When Contented Livestock sets producers-only to false and applies settings
    And Contented Livestock refreshes the surroundings of "ScenarioSixteenSpace"
    Then Contented Livestock the space contribution to "ScenarioSixteenSpace" is not zero
    And Contented Livestock the tip of "ScenarioSixteenSpace" has a space line
    When Contented Livestock selects animal "ScenarioSixteenSpace" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioSixteenSpace" at the top left
    Then I take a screenshot "scenario 16 - pasture input on, the line is in the tip"
    When I close all dialogs
    And Contented Livestock sets setting "penMatters" to "false" and writes settings
    Then Contented Livestock the space contribution to "ScenarioSixteenSpace" is zero
    And Contented Livestock the tip of "ScenarioSixteenSpace" has no space line
    When Contented Livestock opens the live contentment tip for "ScenarioSixteenSpace" at the top left
    Then I take a screenshot "scenario 16 - pasture input off, the line is gone"
    When I close all dialogs
    And Contented Livestock sets setting "penMatters" to "true" and writes settings
    Then Contented Livestock the space contribution to "ScenarioSixteenSpace" is not zero
    And Contented Livestock the tip of "ScenarioSixteenSpace" has a space line
    And no errors were logged

  Scenario: the temperature input, off and on again
    Given Contented Livestock spawns the player animal "ScenarioSixteenWarm" as "Cow"
    Then Contented Livestock the temperature contribution to "ScenarioSixteenWarm" is not zero
    And Contented Livestock the tip of "ScenarioSixteenWarm" has a temperature line
    When Contented Livestock selects animal "ScenarioSixteenWarm" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioSixteenWarm" at the top left
    Then I take a screenshot "scenario 16 - temperature input on, the line is in the tip"
    When I close all dialogs
    And Contented Livestock sets setting "temperatureMatters" to "false" and writes settings
    Then Contented Livestock the temperature contribution to "ScenarioSixteenWarm" is zero
    And Contented Livestock the tip of "ScenarioSixteenWarm" has no temperature line
    When Contented Livestock opens the live contentment tip for "ScenarioSixteenWarm" at the top left
    Then I take a screenshot "scenario 16 - temperature input off, the line is gone"
    When I close all dialogs
    And Contented Livestock sets setting "temperatureMatters" to "true" and writes settings
    Then Contented Livestock the temperature contribution to "ScenarioSixteenWarm" is not zero
    And Contented Livestock the tip of "ScenarioSixteenWarm" has a temperature line
    And no errors were logged

  Scenario: the health input, off and on again
    Given Contented Livestock spawns the player animal "ScenarioSixteenHurt" as "Cow"
    When Contented Livestock wounds "ScenarioSixteenHurt" with a bleeding cut
    Then Contented Livestock the health contribution to "ScenarioSixteenHurt" is not zero
    And Contented Livestock the tip of "ScenarioSixteenHurt" has a health line
    When Contented Livestock selects animal "ScenarioSixteenHurt" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioSixteenHurt" at the top left
    Then I take a screenshot "scenario 16 - health input on, the line is in the tip"
    When I close all dialogs
    And Contented Livestock sets setting "healthMatters" to "false" and writes settings
    Then Contented Livestock the health contribution to "ScenarioSixteenHurt" is zero
    And Contented Livestock the tip of "ScenarioSixteenHurt" has no health line
    When Contented Livestock opens the live contentment tip for "ScenarioSixteenHurt" at the top left
    Then I take a screenshot "scenario 16 - health input off, the line is gone"
    When I close all dialogs
    And Contented Livestock sets setting "healthMatters" to "true" and writes settings
    Then Contented Livestock the health contribution to "ScenarioSixteenHurt" is not zero
    And Contented Livestock the tip of "ScenarioSixteenHurt" has a health line
    And no errors were logged

  Scenario: the company input, off and on again
    Given Contented Livestock spawns the player animal "ScenarioSixteenHerd" as "Muffalo"
    When Contented Livestock refreshes the surroundings of "ScenarioSixteenHerd"
    Then Contented Livestock the company contribution to "ScenarioSixteenHerd" is not zero
    And Contented Livestock the tip of "ScenarioSixteenHerd" has a company line
    When Contented Livestock selects animal "ScenarioSixteenHerd" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioSixteenHerd" at the top left
    Then I take a screenshot "scenario 16 - company input on, the line is in the tip"
    When I close all dialogs
    And Contented Livestock sets setting "companyMatters" to "false" and writes settings
    Then Contented Livestock the company contribution to "ScenarioSixteenHerd" is zero
    And Contented Livestock the tip of "ScenarioSixteenHerd" has no company line
    When Contented Livestock opens the live contentment tip for "ScenarioSixteenHerd" at the top left
    Then I take a screenshot "scenario 16 - company input off, the line is gone"
    When I close all dialogs
    And Contented Livestock sets setting "companyMatters" to "true" and writes settings
    Then Contented Livestock the company contribution to "ScenarioSixteenHerd" is not zero
    And Contented Livestock the tip of "ScenarioSixteenHerd" has a company line
    And no errors were logged

  Scenario: the rate follows a floor, a plateau and two rate factors that are not the defaults
    Given Contented Livestock spawns the player animal "ScenarioSixteenCurve" as "Cow"
    When Contented Livestock sets setting "floorLevel" to "0.30" and writes settings
    And Contented Livestock sets setting "plateauLevel" to "0.70" and writes settings
    And Contented Livestock sets setting "minRateFactor" to "0.20" and writes settings
    And Contented Livestock sets setting "maxRateFactor" to "1.60" and writes settings
    And Contented Livestock sets "ScenarioSixteenCurve" to 29 percent contentment
    Then Contented Livestock production factor for "ScenarioSixteenCurve" is 0 percent
    When Contented Livestock selects animal "ScenarioSixteenCurve" for visual evidence
    And Contented Livestock opens the live contentment tip for "ScenarioSixteenCurve" at the top left
    Then I take a screenshot "scenario 16 - floor at 30, a cow at 29 percent has stopped filling"
    When I close all dialogs
    And Contented Livestock sets "ScenarioSixteenCurve" to 31 percent contentment
    Then Contented Livestock production factor for "ScenarioSixteenCurve" is 22 percent
    When Contented Livestock sets "ScenarioSixteenCurve" to 50 percent contentment
    Then Contented Livestock production factor for "ScenarioSixteenCurve" is 60 percent
    When Contented Livestock sets "ScenarioSixteenCurve" to 70 percent contentment
    Then Contented Livestock production factor for "ScenarioSixteenCurve" is 100 percent
    When Contented Livestock sets "ScenarioSixteenCurve" to 100 percent contentment
    Then Contented Livestock production factor for "ScenarioSixteenCurve" is 160 percent
    When Contented Livestock opens the live contentment tip for "ScenarioSixteenCurve" at the top left
    Then I take a screenshot "scenario 16 - maximum at 160, a cow at full contentment"
    And no errors were logged

  Scenario: the speed of change scales how far contentment travels and never overshoots its target
    Given Contented Livestock spawns the player animal "ScenarioSixteenSpeed" as "Cow"
    When Contented Livestock sets setting "adjustSpeed" to "0.25" and writes settings
    And Contented Livestock sets "ScenarioSixteenSpeed" to 100 percent contentment
    And Contented Livestock records the contentment level of "ScenarioSixteenSpeed"
    And Contented Livestock runs 20 need intervals for "ScenarioSixteenSpeed"
    Then Contented Livestock contentment of "ScenarioSixteenSpeed" has fallen by 125 hundredths of a point, give or take 5
    When Contented Livestock sets setting "adjustSpeed" to "1" and writes settings
    And Contented Livestock sets "ScenarioSixteenSpeed" to 100 percent contentment
    And Contented Livestock records the contentment level of "ScenarioSixteenSpeed"
    And Contented Livestock runs 20 need intervals for "ScenarioSixteenSpeed"
    Then Contented Livestock contentment of "ScenarioSixteenSpeed" has fallen by 500 hundredths of a point, give or take 5
    When Contented Livestock sets setting "adjustSpeed" to "4" and writes settings
    And Contented Livestock sets "ScenarioSixteenSpeed" to 100 percent contentment
    And Contented Livestock records the contentment level of "ScenarioSixteenSpeed"
    And Contented Livestock runs 20 need intervals for "ScenarioSixteenSpeed"
    Then Contented Livestock contentment of "ScenarioSixteenSpeed" has fallen by 2000 hundredths of a point, give or take 10
    When Contented Livestock puts "ScenarioSixteenSpeed" half a point above its target
    And Contented Livestock lets "ScenarioSixteenSpeed" take one need interval
    Then Contented Livestock contentment of "ScenarioSixteenSpeed" has come to rest on its target without going below it
    And no errors were logged
