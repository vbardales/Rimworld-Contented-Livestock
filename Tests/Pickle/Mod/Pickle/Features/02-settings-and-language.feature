@review @requires:nelim.pickletools.screenshotmode
Feature: Contented Livestock settings in the language this pass runs

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs

  Scenario: every keyed text is loaded for this language
    Then every Contented Livestock keyed text exists in the language this pass runs

  Scenario: the primary settings page belongs to this mod and can be reviewed
    When I open the Contented Livestock settings dialog
    Then Contented Livestock sees its own settings dialog open
    When Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "contented livestock settings in this language"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs

  Scenario: the native shortcut is hidden, revealable, enabled and opens the same page
    Then the Contented Livestock shortcut is hidden on a clean configuration
    When Contented Livestock reveals its shortcut as a customization mod would
    Then the Contented Livestock shortcut is drawn and enabled
    When Contented Livestock activates its shortcut
    Then Contented Livestock sees its own settings dialog open
    When I close all dialogs
    And Contented Livestock hides its shortcut again
