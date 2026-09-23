@review @requires:nelim.pickletools.screenshotmode
Feature: Settings are written for a separate-process restart

  Scenario: write distinctive settings and keep them for the next launch
    Given the save "test-colony" is loaded
    And I close all dialogs
    When Contented Livestock sets setting "floorLevel" to "0.11" and writes settings
    And Contented Livestock sets setting "plateauLevel" to "0.72" and writes settings
    And Contented Livestock sets setting "minRateFactor" to "0.55" and writes settings
    And Contented Livestock sets setting "maxRateFactor" to "1.65" and writes settings
    And Contented Livestock sets setting "adjustSpeed" to "2.35" and writes settings
    And Contented Livestock sets setting "feedMatters" to "false" and writes settings
    And Contented Livestock sets setting "penMatters" to "false" and writes settings
    And Contented Livestock sets setting "temperatureMatters" to "false" and writes settings
    And Contented Livestock sets setting "healthMatters" to "false" and writes settings
    And Contented Livestock sets setting "companyMatters" to "false" and writes settings
    And Contented Livestock sets setting "producersOnly" to "false" and writes settings
    And I open the Contented Livestock settings dialog
    Then Contented Livestock sees its own settings dialog open
    When Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "scenario 13 - distinctive settings before process restart"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs
    And Contented Livestock keeps its settings for the next launch
    Then no errors were logged
