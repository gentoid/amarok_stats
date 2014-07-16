Feature: App works properly

  Scenario: App works and exit correctly
    When I run `amarok_stats`
    Then the exit status should be 0
