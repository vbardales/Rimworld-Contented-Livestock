@rimmsqol @requires:MalteSchulze.RIMMSqol @requires:nelim.pickletools.rimmsqol
Feature: RIMMSQOL keeps the revealed shortcut for the next launch

  Scenario: reveal and keep
    Given the save "test-colony" is loaded
    And I close all dialogs
    And RIMMSQOL is ready to be driven
    And the main bar does not draw the button "Nelim_ContentedLivestockSettings"
    When RIMMSQOL reveals the main button "Nelim_ContentedLivestockSettings"
    Then the main bar draws the button "Nelim_ContentedLivestockSettings"
    And RIMMSQOL's settings file records the main button "Nelim_ContentedLivestockSettings" as visible
    And no errors were logged
    And RIMMSQOL's choices are kept for the next launch
