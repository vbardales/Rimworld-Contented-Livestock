# Shooting plan, written 2026-11-15 (shotlist, director pass by an Opus sub-agent, kept: Nelim in frame, more pots, wider opener).
# Story: one afternoon at Nelim's clearing in her Sanctuary: she keeps cows, and how a cow is kept shows in how fast it fills.
# Time: the save's own hour, permanent summer, each scene reloads the save; scene 2 lets two game hours pass (5,000 ticks).
#   1. cow-with-contentment-and-tip (opener, medium-wide): Nelim's Sanctuary bare-clearing at x 195 and z 152, clear, midday on the save clock, about 30 ticks after setup. Daisy at 72 percent, seen from the front (faces South, held), right of centre and low, Nelim caught mid-stride walking in from x 190 and z 153 to x 196 and z 153, in her saved outfit (yellow tunic, dark brown hair as in the 2026-11-15 captures, apparel unchanged) with her canon smirk mouth, TorchLamp (192, 154) lit, PlantPot (198, 154), PlantPot (192, 150), PlantPot (190, 152) in an arc behind. Live tip top left, mouse parked bottom right. Just before: Nelim came to check the cow; just after: she reads the bar. Gesture: Nelim forced to walk, the game advanced 40 ticks then paused, so she is mid-step. Reads in the image: this cow is at 72 percent and fills at 112 percent of the usual rate. Subtitle: Contentment: how settled a cow is, and how fast it fills.
#   2. two-cows-after-two-hours (medium, a pair read together): same clearing, near x 185 and z 152, two game hours later. Buttercup at 100 percent and Thistle at 30 percent, both cows face South, Nelim sent to x 190 and z 153 then forced to walk toward the cows, caught mid-step, TorchLamp (192, 154) lit, PlantPot (198, 154), PlantPot (190, 150), PlantPot (194, 156), PlantPot (196, 150). Capture one selects Buttercup (milk 11 percent), capture two selects Thistle (milk 4.7 percent), the camera 3 cells right of the cow, midday on the save clock so the map edge stays out. Just after: the keeper compares the two. Reads in the image: same two hours, one cow filled more than twice as much. Subtitle: Same two hours, one well kept cow, one neglected.
#   3. interface window, set aside: the settings page over the clearing with Daisy's contentment bar beside it (no subtitle).
# Weak points assumed: Nelim keeps her saved outfit (no wardrobe step in the studio map), the hot-weather alert shows in scene 2.
#
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
# Framing fix after run efda (green, captures read 2026-11-14): in picture 1 the cow sat behind the tip, so the
# negative offsets now put her right of and below the centre; in picture 3 the cow stood at the map edge beside
# the void, so the two cows are spawned at x 185 and shown right of the centre; Nelim, who had roped Buttercup
# in picture 2, is sent away as in scene 1.
#
# The save holds one colonist, Nelim (SanctuaryBacklot, "Qui une galerie peut utiliser"): she is the pawn sent away from the clearing
# (the earlier lines call her Miel, who is not in the save). The cows keep the vanilla coat: no loaded mod gives Cow alternate coats.
#
# Animal names must not exist in the save: the steps take the first pawn of that name. The Sanctuary has none called
# Daisy, Buttercup or Thistle.
@review @requires:nelim.sanctuarybacklot @requires:nelim.pickletools.screenshotstudio @requires:nelim.pickletools.screenshotmode @requires:nelim.pickletools.clickdiagnostics @requires:nelim.pickletools.stagedecor
Feature: Workshop pictures

  Background:
    Given the save "Nelims-tribe-decor-mods-z3" is loaded
    And game speed is paused
    And Nelim's Pickle Tools: the eclipse of the map is ended
    And Nelim's Pickle Tools: all animals are removed
    And I close all dialogs
    And Contented Livestock restores its default settings

  Scenario: a cow with its contentment bar and the live tip
    Given Contented Livestock sends the colonist "Nelim" to x 190 and z 153
    And Contented Livestock spawns the player animal "Daisy" as "Cow" near x 195 and z 152
    And Nelim's Pickle Tools: I place the decor "TorchLamp" at (192, 154)
    And Nelim's Pickle Tools: the decor "TorchLamp" at (192, 154) is lit
    And Nelim's Pickle Tools: I place the decor "PlantPot" at (198, 154)
    And Nelim's Pickle Tools: I place the decor "PlantPot" at (192, 150)
    And Nelim's Pickle Tools: I place the decor "PlantPot" at (190, 152)
    And Contented Livestock records that "Daisy" ate "RawCorn"
    When Contented Livestock sets "Daisy" to 72 percent contentment
    Then Contented Livestock production factor for "Daisy" is 112 percent
    When Nelim's Pickle Tools: the animal "Daisy" faces South
    And Nelim's Pickle Tools: "Nelim" is forced to walk to (196, 153)
    And Nelim's Pickle Tools: the game is advanced by 40 ticks
    And game speed is paused
    When Contented Livestock dismisses every letter
    And Nelim's Sanctuary: I frame the sanctuary "bare-clearing"
    And Contented Livestock selects animal "Daisy" for visual evidence, shown -3 cells left and -2 cells up
    And Contented Livestock opens the live contentment tip for "Daisy" at the top left
    And I wait 30 ticks
    And Nelim's Pickle Tools: I move the mouse to (1800, 1000)
    Then I take a screenshot "publication 1 - cow with contentment and its tip"
    When Nelim's Pickle Tools: the decor is removed

  Scenario: two cows after the same two hours, one kept well and one badly
    Given Contented Livestock sends the colonist "Nelim" to x 190 and z 153
    And Contented Livestock spawns the player animal "Buttercup" as "Cow" near x 185 and z 152
    And Contented Livestock spawns the player animal "Thistle" as "Cow" near x 185 and z 152
    And Nelim's Pickle Tools: the animal "Buttercup" faces South
    And Nelim's Pickle Tools: the animal "Thistle" faces South
    And Nelim's Pickle Tools: I place the decor "TorchLamp" at (192, 154)
    And Nelim's Pickle Tools: the decor "TorchLamp" at (192, 154) is lit
    And Nelim's Pickle Tools: I place the decor "PlantPot" at (198, 154)
    And Nelim's Pickle Tools: I place the decor "PlantPot" at (190, 150)
    And Nelim's Pickle Tools: I place the decor "PlantPot" at (194, 156)
    And Nelim's Pickle Tools: I place the decor "PlantPot" at (196, 150)
    When Contented Livestock sets "Buttercup" to 100 percent contentment
    And Contented Livestock sets "Thistle" to 30 percent contentment
    Then Contented Livestock production factor for "Buttercup" is 140 percent
    And Contented Livestock production factor for "Thistle" is 49 percent
    When Contented Livestock records the milk fullness of "Buttercup"
    And Contented Livestock records the milk fullness of "Thistle"
    And Contented Livestock waits one game hour
    And Contented Livestock waits one game hour
    Then Contented Livestock milk gained by "Buttercup" exceeds the milk gained by "Thistle"
    When Nelim's Pickle Tools: "Nelim" is forced to walk to (186, 153)
    And Nelim's Pickle Tools: the game is advanced by 40 ticks
    And game speed is paused
    When Contented Livestock dismisses every letter
    And Nelim's Sanctuary: I frame the sanctuary "bare-clearing"
    And Contented Livestock selects animal "Buttercup" for visual evidence, shown -3 cells left and 0 cells up
    And I wait 30 ticks
    And Nelim's Pickle Tools: I move the mouse to (1800, 1000)
    Then I take a screenshot "publication 2 - the well kept cow after two hours"
    When Contented Livestock selects animal "Thistle" for visual evidence, shown -3 cells left and 0 cells up
    And I wait 30 ticks
    And Nelim's Pickle Tools: I move the mouse to (1800, 1000)
    Then I take a screenshot "publication 3 - the badly kept cow after the same two hours"
    When Nelim's Pickle Tools: the decor is removed

  Scenario: the settings page over the clearing, with a cow's contentment bar beside it
    Given Contented Livestock sends the colonist "Nelim" to x 97 and z 152
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