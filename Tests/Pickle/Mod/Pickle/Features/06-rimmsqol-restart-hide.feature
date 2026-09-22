@rimmsqol @requires:MalteSchulze.RIMMSqol @requires:nelim.pickletools.rimmsqol
Feature: RIMMSQOL reads the revealed shortcut after restart and keeps it hidden

  Scenario: read reveal, hide and keep
    Given the save "test-colony" is loaded
    And I close all dialogs
    And RIMMSQOL is ready to be driven
    And the choices RIMMSQOL kept in the previous launch are in place
    Then RIMMSQOL shows the main button "Nelim_ContentedLivestockSettings" as visible
    And the main bar draws the button "Nelim_ContentedLivestockSettings"
    When RIMMSQOL hides the main button "Nelim_ContentedLivestockSettings"
    Then the main bar does not draw the button "Nelim_ContentedLivestockSettings"
    And RIMMSQOL's settings file records the main button "Nelim_ContentedLivestockSettings" as hidden
    And no errors were logged
    And RIMMSQOL's choices are kept for the next launch
