Feature: Contented Livestock loads with its runtime contracts

  Scenario: the mod loads after Harmony without startup errors
    Then mod "nelim.contentedlivestock" is loaded
    And mod "nelim.contentedlivestock" loads after "brrainz.harmony"
    And no errors were logged

  Scenario: its need and hidden settings shortcut are present
    Then def "Nelim_Contentment" of type "NeedDef" exists
    And def "Nelim_ContentedLivestockSettings" of type "MainButtonDef" exists

  Scenario: a clean profile loads the documented defaults
    Then Contented Livestock setting "floorLevel" reads "0.25"
    And Contented Livestock setting "plateauLevel" reads "0.6"
    And Contented Livestock setting "minRateFactor" reads "0.4"
    And Contented Livestock setting "maxRateFactor" reads "1.4"
    And Contented Livestock setting "adjustSpeed" reads "1"
    And Contented Livestock setting "producersOnly" reads "True"
