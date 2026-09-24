# Manual scenario 15: primary settings, defaults, boundaries and reset. Written to give a person captures of
# every state to look at, as well as assertions.
#
# What is real and what is set in code. The dialog is the mod's own Dialog_ModSettings, opened as the
# Options screen opens it; the Options route itself (Options, Mod options, pick the mod) is not driven
# here. Sliders and check boxes have no name Pickle can click, so each is set to the value the widget would
# give and the dialog is left to draw it. Closing the window is the real close, which writes the settings.
# The reset button and its two confirmation buttons are real buttons and are clicked, by their English
# label: this runs in English. Surviving a quit and a relaunch is covered by features 09 and 10.
#
# Each slider has one low end and one high end, so the five are set together and captured twice. Screens
# under 1080 lines would need scrolling to reach every control; this runs at 1920 x 1080, where they all fit.
@review
Feature: Scenario 15 - primary settings, defaults, boundaries and reset

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs
    And Contented Livestock restores its default settings

  Scenario: the dialog opens on the shipped defaults, five sliders and six enabled toggles
    When I open the Contented Livestock settings dialog
    Then Contented Livestock sees its own settings dialog open
    And Contented Livestock setting "floorLevel" reads about 25 percent
    And Contented Livestock setting "plateauLevel" reads about 60 percent
    And Contented Livestock setting "minRateFactor" reads about 40 percent
    And Contented Livestock setting "maxRateFactor" reads about 140 percent
    And Contented Livestock setting "adjustSpeed" reads about 100 percent
    And Contented Livestock setting "feedMatters" reads "True"
    And Contented Livestock setting "penMatters" reads "True"
    And Contented Livestock setting "temperatureMatters" reads "True"
    And Contented Livestock setting "healthMatters" reads "True"
    And Contented Livestock setting "companyMatters" reads "True"
    And Contented Livestock setting "producersOnly" reads "True"
    When Contented Livestock lets the settings dialog draw
    Then I take a screenshot "scenario 15 - the shipped defaults, five sliders and six toggles on"
    And no errors were logged

  Scenario: every slider reaches both ends, the plateau stays five points above the floor, and out-of-range values are held
    When I open the Contented Livestock settings dialog
    And Contented Livestock sets setting "floorLevel" to "0" and writes settings
    And Contented Livestock sets setting "plateauLevel" to "0.3" and writes settings
    And Contented Livestock sets setting "minRateFactor" to "0" and writes settings
    And Contented Livestock sets setting "maxRateFactor" to "1" and writes settings
    And Contented Livestock sets setting "adjustSpeed" to "0.25" and writes settings
    And Contented Livestock lets the settings dialog draw
    Then Contented Livestock setting "floorLevel" reads about 0 percent
    And Contented Livestock setting "plateauLevel" reads about 30 percent
    And Contented Livestock setting "minRateFactor" reads about 0 percent
    And Contented Livestock setting "maxRateFactor" reads about 100 percent
    And Contented Livestock setting "adjustSpeed" reads about 25 percent
    And I take a screenshot "scenario 15 - every slider at its low end"
    When Contented Livestock sets setting "floorLevel" to "0.5" and writes settings
    And Contented Livestock sets setting "plateauLevel" to "0.9" and writes settings
    And Contented Livestock sets setting "minRateFactor" to "1" and writes settings
    And Contented Livestock sets setting "maxRateFactor" to "2" and writes settings
    And Contented Livestock sets setting "adjustSpeed" to "4" and writes settings
    And Contented Livestock lets the settings dialog draw
    Then Contented Livestock setting "floorLevel" reads about 50 percent
    And Contented Livestock setting "plateauLevel" reads about 90 percent
    And Contented Livestock setting "minRateFactor" reads about 100 percent
    And Contented Livestock setting "maxRateFactor" reads about 200 percent
    And Contented Livestock setting "adjustSpeed" reads about 400 percent
    And I take a screenshot "scenario 15 - every slider at its high end"
    When Contented Livestock sets setting "plateauLevel" to "0.3" and writes settings
    And Contented Livestock lets the settings dialog draw
    Then Contented Livestock setting "floorLevel" reads about 50 percent
    And Contented Livestock setting "plateauLevel" reads about 55 percent
    And I take a screenshot "scenario 15 - floor at 50, plateau asked at 30 and held at 55"
    When Contented Livestock sets setting "floorLevel" to "0.9" and writes settings
    Then Contented Livestock setting "floorLevel" reads about 50 percent
    When Contented Livestock sets setting "floorLevel" to "0" and writes settings
    And Contented Livestock sets setting "plateauLevel" to "0.1" and writes settings
    And Contented Livestock sets setting "minRateFactor" to "-1" and writes settings
    And Contented Livestock sets setting "maxRateFactor" to "5" and writes settings
    And Contented Livestock sets setting "adjustSpeed" to "10" and writes settings
    Then Contented Livestock setting "plateauLevel" reads about 30 percent
    And Contented Livestock setting "minRateFactor" reads about 0 percent
    And Contented Livestock setting "maxRateFactor" reads about 200 percent
    And Contented Livestock setting "adjustSpeed" reads about 400 percent
    When Contented Livestock sets setting "adjustSpeed" to "0.01" and writes settings
    Then Contented Livestock setting "adjustSpeed" reads about 25 percent
    And Contented Livestock its settings dialog is still open
    And no errors were logged

  Scenario: distinctive values survive closing the window and opening it again
    When Contented Livestock sets setting "floorLevel" to "0.31" and writes settings
    And Contented Livestock sets setting "plateauLevel" to "0.71" and writes settings
    And Contented Livestock sets setting "minRateFactor" to "0.22" and writes settings
    And Contented Livestock sets setting "maxRateFactor" to "1.63" and writes settings
    And Contented Livestock sets setting "adjustSpeed" to "2.5" and writes settings
    And Contented Livestock sets setting "feedMatters" to "false" and writes settings
    And Contented Livestock sets setting "penMatters" to "false" and writes settings
    And Contented Livestock sets setting "temperatureMatters" to "false" and writes settings
    And Contented Livestock sets setting "healthMatters" to "false" and writes settings
    And Contented Livestock sets setting "companyMatters" to "false" and writes settings
    And Contented Livestock sets setting "producersOnly" to "false" and writes settings
    And I open the Contented Livestock settings dialog
    And Contented Livestock lets the settings dialog draw
    Then I take a screenshot "scenario 15 - eleven distinctive values in the open dialog"
    When I close all dialogs
    And I open the Contented Livestock settings dialog
    And Contented Livestock lets the settings dialog draw
    Then Contented Livestock setting "floorLevel" reads about 31 percent
    And Contented Livestock setting "plateauLevel" reads about 71 percent
    And Contented Livestock setting "minRateFactor" reads about 22 percent
    And Contented Livestock setting "maxRateFactor" reads about 163 percent
    And Contented Livestock setting "adjustSpeed" reads about 250 percent
    And Contented Livestock setting "feedMatters" reads "False"
    And Contented Livestock setting "penMatters" reads "False"
    And Contented Livestock setting "temperatureMatters" reads "False"
    And Contented Livestock setting "healthMatters" reads "False"
    And Contented Livestock setting "companyMatters" reads "False"
    And Contented Livestock setting "producersOnly" reads "False"
    And I take a screenshot "scenario 15 - the same eleven values after closing and reopening"
    And no errors were logged

  Scenario: the reset confirmation, cancelled once and confirmed the second time
    When Contented Livestock sets setting "floorLevel" to "0.31" and writes settings
    And Contented Livestock sets setting "plateauLevel" to "0.71" and writes settings
    And Contented Livestock sets setting "minRateFactor" to "0.22" and writes settings
    And Contented Livestock sets setting "maxRateFactor" to "1.63" and writes settings
    And Contented Livestock sets setting "adjustSpeed" to "2.5" and writes settings
    And Contented Livestock sets setting "feedMatters" to "false" and writes settings
    And Contented Livestock sets setting "producersOnly" to "false" and writes settings
    And I open the Contented Livestock settings dialog
    And Contented Livestock lets the settings dialog draw
    And I click button "Reset to defaults"
    Then Contented Livestock the reset confirmation is open
    When Contented Livestock lets the settings dialog draw
    Then I take a screenshot "scenario 15 - the reset confirmation"
    When I click button "Go back"
    Then Contented Livestock the reset confirmation is not open
    And Contented Livestock its settings dialog is still open
    And Contented Livestock setting "floorLevel" reads about 31 percent
    And Contented Livestock setting "adjustSpeed" reads about 250 percent
    And Contented Livestock setting "feedMatters" reads "False"
    And Contented Livestock setting "producersOnly" reads "False"
    When I click button "Reset to defaults"
    And I click button "Confirm"
    Then Contented Livestock the reset confirmation is not open
    And Contented Livestock setting "floorLevel" reads about 25 percent
    And Contented Livestock setting "plateauLevel" reads about 60 percent
    And Contented Livestock setting "minRateFactor" reads about 40 percent
    And Contented Livestock setting "maxRateFactor" reads about 140 percent
    And Contented Livestock setting "adjustSpeed" reads about 100 percent
    And Contented Livestock setting "feedMatters" reads "True"
    And Contented Livestock setting "penMatters" reads "True"
    And Contented Livestock setting "temperatureMatters" reads "True"
    And Contented Livestock setting "healthMatters" reads "True"
    And Contented Livestock setting "companyMatters" reads "True"
    And Contented Livestock setting "producersOnly" reads "True"
    When Contented Livestock lets the settings dialog draw
    Then I take a screenshot "scenario 15 - after confirming, the eleven defaults are back"
    And no errors were logged
