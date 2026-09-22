@rimmsqol @requires:MalteSchulze.RIMMSqol @requires:nelim.pickletools.rimmsqol
Feature: RIMMSQOL reads the hidden shortcut after restart and cleans up

  Scenario: read hide and forget
    Given the save "test-colony" is loaded
    And I close all dialogs
    And RIMMSQOL is ready to be driven
    And the choices RIMMSQOL kept in the previous launch are in place
    Then RIMMSQOL shows the main button "Nelim_ContentedLivestockSettings" as hidden
    And the main bar does not draw the button "Nelim_ContentedLivestockSettings"
    When RIMMSQOL forgets its choice for the main button "Nelim_ContentedLivestockSettings"
    Then RIMMSQOL holds no choice for the main button "Nelim_ContentedLivestockSettings"
    And RIMMSQOL's settings file records no choice for the main button "Nelim_ContentedLivestockSettings"
    And no errors were logged
