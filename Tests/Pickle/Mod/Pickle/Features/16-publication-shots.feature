# Pictures meant for the Workshop page and for nothing else. What they assert is only that the picture
# says what its caption will say: the rates are checked before the wait, and the two cows are checked
# to have gained different amounts of milk afterwards.
#
# These are STAGED. Contentment is set directly rather than earned over days of good and bad keeping,
# and the feed memory is planted, because no one would wait a game week for a store picture. The
# production rates and the milk they produce are the real ones: only the state they start from is set.
# The page must not describe them as a week of play.
#
# The interface stays on in all three scenes, because the Needs pane IS the subject, and the settings page
# is taken with a cow selected beside the window so that its contentment bar stands next to the settings
# (owner, 2026-09-25: the first version, in screenshot mode, showed no bar). In the animal scenes
# the letters the fixture has piled up are dismissed, the camera is framed on the clearing before the
# animal is selected (that step also sets the zoom, which the saved camera leaves too far out), and
# the tip is moved to the top left so it does not sit on top of the cow. In the first scene the cow is
# also shown off-centre: after a camera jump Pickle's pointer rests at the screen centre and the game
# draws the tooltip of whatever is under it, which in the first run was another pawn's name ("Miel,
# Surveyor") floating beside the cow. Off-centre was not enough: the clearing is near where she works and she may walk
# under the pointer, so the second run still showed her name. She is now sent far from the clearing first.
# Scenes 2 and 3 had no pawn under the pointer and need no change.
#
# Animal names must not exist in the save: the steps take the first pawn of that name. The Sanctuary has none called
# Daisy, Buttercup or Thistle.
@review @requires:nelim.sanctuarybacklot @requires:nelim.pickletools.screenshotstudio @requires:nelim.pickletools.screenshotmode @requires:nelim.pickletools.clickdiagnostics @requires:nelim.pickletools.coatsteps @requires:nelim.pickletools.stagedecor
Feature: Workshop pictures

  Background:
    Given the save "Nelims-tribe-decor-mods-z3" is loaded
    And game speed is paused
    And Nelim's Pickle Tools: the eclipse of the map is ended
    And Nelim's Pickle Tools: all animals are removed
    And I close all dialogs
    And Contented Livestock restores its default settings

  Scenario: a cow with its contentment bar and the live tip
    Given Contented Livestock sends the colonist "Miel" to x 97 and z 152
    And Contented Livestock spawns the player animal "Daisy" as "Cow" near x 195 and z 152
    And Nelim's Pickle Tools: the animal "Daisy" is given coat 1
    And Nelim's Pickle Tools: I place the decor "TorchLamp" at (192, 154)
    And Nelim's Pickle Tools: the decor "TorchLamp" at (192, 154) is lit
    And Nelim's Pickle Tools: I place the decor "PlantPot" at (198, 154)
    And Nelim's Pickle Tools: I place the decor "PlantPot" at (192, 150)
    And Contented Livestock records that "Daisy" ate "RawCorn"
    When Contented Livestock sets "Daisy" to 72 percent contentment
    Then Contented Livestock production factor for "Daisy" is 112 percent
    When Contented Livestock dismisses every letter
    And Nelim's Sanctuary: I frame the sanctuary "bare-clearing"
    And Contented Livestock selects animal "Daisy" for visual evidence, shown 3 cells left and 4 cells up
    And Contented Livestock opens the live contentment tip for "Daisy" at the top left
    And I wait 30 ticks
    And Nelim's Pickle Tools: I move the mouse to (1800, 1000)
    Then I take a screenshot "publication 1 - cow with contentment and its tip"
    When Nelim's Pickle Tools: the decor is removed

  Scenario: two cows after the same two hours, one kept well and one badly
    Given Contented Livestock spawns the player animal "Buttercup" as "Cow" near x 195 and z 152
    And Contented Livestock spawns the player animal "Thistle" as "Cow" near x 195 and z 152
    And Nelim's Pickle Tools: the animal "Buttercup" is given coat -1
    And Nelim's Pickle Tools: the animal "Thistle" is given coat 2
    And Nelim's Pickle Tools: I place the decor "TorchLamp" at (192, 154)
    And Nelim's Pickle Tools: the decor "TorchLamp" at (192, 154) is lit
    And Nelim's Pickle Tools: I place the decor "PlantPot" at (198, 154)
    When Contented Livestock sets "Buttercup" to 100 percent contentment
    And Contented Livestock sets "Thistle" to 30 percent contentment
    Then Contented Livestock production factor for "Buttercup" is 140 percent
    And Contented Livestock production factor for "Thistle" is 49 percent
    When Contented Livestock records the milk fullness of "Buttercup"
    And Contented Livestock records the milk fullness of "Thistle"
    And Contented Livestock waits one game hour
    And Contented Livestock waits one game hour
    Then Contented Livestock milk gained by "Buttercup" exceeds the milk gained by "Thistle"
    When Contented Livestock dismisses every letter
    And Nelim's Sanctuary: I frame the sanctuary "bare-clearing"
    And Contented Livestock selects animal "Buttercup" for visual evidence
    And I wait 30 ticks
    And Nelim's Pickle Tools: I move the mouse to (1800, 1000)
    Then I take a screenshot "publication 2 - the well kept cow after two hours"
    When Contented Livestock selects animal "Thistle" for visual evidence
    And I wait 30 ticks
    And Nelim's Pickle Tools: I move the mouse to (1800, 1000)
    Then I take a screenshot "publication 3 - the badly kept cow after the same two hours"
    When Nelim's Pickle Tools: the decor is removed

  Scenario: the settings page over the clearing, with a cow's contentment bar beside it
    Given Contented Livestock sends the colonist "Miel" to x 97 and z 152
    And Contented Livestock spawns the player animal "Daisy" as "Cow" near x 195 and z 152
    And Contented Livestock records that "Daisy" ate "RawCorn"
    When Contented Livestock sets "Daisy" to 72 percent contentment
    And Contented Livestock dismisses every letter
    And Nelim's Sanctuary: I frame the sanctuary "bare-clearing"
    And Contented Livestock selects animal "Daisy" for visual evidence, shown 12 cells left and 2 cells up
    And I open the Contented Livestock settings dialog
    Then Contented Livestock sees its own settings dialog open
    When Contented Livestock lets the settings dialog draw
    And I wait 30 ticks
    Then I take a screenshot "publication 4 - settings page with the contentment bar"
    When I close all dialogs