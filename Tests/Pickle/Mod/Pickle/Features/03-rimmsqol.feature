@review @rimmsqol @requires:MalteSchulze.RIMMSqol @requires:nelim.pickletools.rimmsqol @requires:nelim.pickletools.screenshotmode
Feature: RIMMSQOL reveals and hides the Contented Livestock shortcut

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs
    Then RIMMSQOL is ready to be driven

  Scenario: RIMMSQOL lists the hidden shortcut
    Then RIMMSQOL's own list of main buttons offers "Nelim_ContentedLivestockSettings"
    And RIMMSQOL shows the main button "Nelim_ContentedLivestockSettings" as hidden
    And the main bar does not draw the button "Nelim_ContentedLivestockSettings"
    And I take a screenshot "the main bar, bare, before RIMMSQOL reveals anything"

  Scenario: RIMMSQOL reveals a live shortcut that opens this mod's settings
    When RIMMSQOL reveals the main button "Nelim_ContentedLivestockSettings"
    Then the main bar draws the button "Nelim_ContentedLivestockSettings"
    And RIMMSQOL's settings file records the main button "Nelim_ContentedLivestockSettings" as visible
    When the main bar's button "Nelim_ContentedLivestockSettings" is activated
    Then Contented Livestock sees its own settings dialog open
    When Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "contented livestock settings opened through rimmsqol"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs

  Scenario: the shortcut opens the settings from the world view, with no map current
    Given RIMMSQOL reveals the main button "Nelim_ContentedLivestockSettings"
    When Contented Livestock leaves the map for the world view
    And the main bar's button "Nelim_ContentedLivestockSettings" is activated
    Then Contented Livestock sees its own settings dialog open
    And no errors were logged
    When Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "settings opened from the world view, no map current"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs
    And Contented Livestock returns to the map

  Scenario: RIMMSQOL hides and forgets the shortcut cleanly
    Given RIMMSQOL reveals the main button "Nelim_ContentedLivestockSettings"
    When RIMMSQOL hides the main button "Nelim_ContentedLivestockSettings"
    Then the main bar does not draw the button "Nelim_ContentedLivestockSettings"
    And RIMMSQOL's settings file records the main button "Nelim_ContentedLivestockSettings" as hidden
    When RIMMSQOL forgets its choice for the main button "Nelim_ContentedLivestockSettings"
    Then RIMMSQOL's settings file records no choice for the main button "Nelim_ContentedLivestockSettings"
    And no errors were logged
