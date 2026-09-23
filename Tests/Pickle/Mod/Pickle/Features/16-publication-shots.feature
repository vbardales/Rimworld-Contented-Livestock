# Pictures meant for the Workshop page and for nothing else. What they assert is only that the picture
# says what its caption will say: the rates are checked before the wait, and the two cows are checked
# to have gained different amounts of milk afterwards.
#
# These are STAGED. Contentment is set directly rather than earned over days of good and bad keeping,
# and the feed memory is planted, because no one would wait a game week for a store picture. The
# production rates and the milk they produce are the real ones: only the state they start from is set.
# The page must not describe them as a week of play.
#
# The interface stays on for the two animal scenes, because the Needs pane IS the subject. Screenshot
# mode is used only for the settings page, where nothing but the window matters.
@review @requires:nelim.pickletools.screenshotstudio @requires:nelim.pickletools.screenshotmode
Feature: Workshop pictures

  Background:
    Given the save "nelim-zen-meadow-studio" is loaded
    And game speed is paused
    And I close all dialogs
    And Contented Livestock restores its default settings

  Scenario: a cow with its contentment bar and the live tip
    Given Contented Livestock spawns the player animal "Daisy" as "Cow" near x 154 and z 98
    And Contented Livestock records that "Daisy" ate "RawCorn"
    When Contented Livestock sets "Daisy" to 72 percent contentment
    Then Contented Livestock production factor for "Daisy" is 112 percent
    When Contented Livestock selects animal "Daisy" for visual evidence
    And Contented Livestock opens the live contentment tip for "Daisy"
    And I wait 30 ticks
    Then I take a screenshot "publication 1 - cow with contentment and its tip"

  Scenario: two cows after the same two hours, one kept well and one badly
    Given Contented Livestock spawns the player animal "Clover" as "Cow" near x 154 and z 98
    And Contented Livestock spawns the player animal "Thistle" as "Cow" near x 154 and z 98
    When Contented Livestock sets "Clover" to 100 percent contentment
    And Contented Livestock sets "Thistle" to 30 percent contentment
    Then Contented Livestock production factor for "Clover" is 140 percent
    And Contented Livestock production factor for "Thistle" is 49 percent
    When Contented Livestock records the milk fullness of "Clover"
    And Contented Livestock records the milk fullness of "Thistle"
    And Contented Livestock waits one game hour
    And Contented Livestock waits one game hour
    Then Contented Livestock milk gained by "Clover" exceeds the milk gained by "Thistle"
    When Contented Livestock selects animal "Clover" for visual evidence
    And I wait 30 ticks
    Then I take a screenshot "publication 2 - the well kept cow after two hours"
    When Contented Livestock selects animal "Thistle" for visual evidence
    And I wait 30 ticks
    Then I take a screenshot "publication 3 - the badly kept cow after the same two hours"

  Scenario: the settings page over the meadow
    When I open the Contented Livestock settings dialog
    Then Contented Livestock sees its own settings dialog open
    When Nelim's Pickle Tools: I frame the studio "flowers"
    And Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "publication 4 - settings page"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs
