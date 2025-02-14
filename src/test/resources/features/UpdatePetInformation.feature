@API @Pet
Feature: Update Pet Information
  As a pet store manager
  I want to update existing pet information
  So that the pet inventory is accurately maintained

  Background:
    Given the pet store API is available

  @Smoke @Regression
  Scenario Outline: Successfully update an existing pet's information
    Given a pet with ID <petId> exists in the system
    When User sends a PUT request to "/pet" with the following details:
      | id   | name   | status   |
      | <petId> | <name> | <status> |
    Then the response status code should be 200
    And the response should contain the updated pet information
    And the pet with ID <petId> should have name "<name>" and status "<status>"

    Examples:
      | petId | name    | status    |
      | 1     | Fluffy  | available |
      | 2     | Buddy   | pending   |
      | 3     | Charlie | sold      |

  @Regression
  Scenario: Update a pet with invalid ID
    When User sends a PUT request to "/pet" with the following details:
      | id   | name   | status    |
      | 9999 | Invalid | available |
    Then the response status code should be 404
    And the response should contain an error message indicating the pet was not found

  @Regression
  Scenario: Update a pet with missing required fields
    When User sends a PUT request to "/pet" with the following details:
      | id |
      | 1  |
    Then the response status code should be 400
    And the response should contain an error message about missing required fields

  @Regression
  Scenario: Update a pet with invalid status
    When User sends a PUT request to "/pet" with the following details:
      | id | name   | status  |
      | 1  | Fluffy | invalid |
    Then the response status code should be 400
    And the response should contain an error message about invalid pet status

  @Regression
  Scenario: Update a pet with very long name
    When User sends a PUT request to "/pet" with the following details:
      | id | name                                                                                                                     | status    |
      | 1  | ThisIsAVeryLongPetNameThatExceedsTheMaximumAllowedLengthForPetNamesInTheSystemAndShouldResultInAnErrorOrTruncation | available |
    Then the response status code should be 400
    And the response should contain an error message about name length exceeding the limit

  @Regression
  Scenario: Attempt to update a pet with invalid authentication
    Given User has invalid authentication credentials
    When User sends a PUT request to "/pet" with valid pet details
    Then the response status code should be 401
    And the response should contain an error message about invalid authentication

  @Regression
  Scenario: Update a pet's information multiple times
    Given a pet with ID 1 exists in the system
    When User sends a PUT request to "/pet" to update the pet's status to "pending"
    And User sends another PUT request to "/pet" to update the pet's name to "NewName"
    Then the response status code of the last request should be 200
    And the pet with ID 1 should have name "NewName" and status "pending"

  @Regression
  Scenario: Update a pet with special characters in the name
    When User sends a PUT request to "/pet" with the following details:
      | id | name        | status    |
      | 1  | Fluffy@#$%^ | available |
    Then the response status code should be 200
    And the response should contain the updated pet information with the special characters in the name

  @Regression
  Scenario: Concurrent updates to the same pet
    Given a pet with ID 1 exists in the system
    When User1 sends a PUT request to "/pet" to update the pet's status to "pending"
    And simultaneously User2 sends a PUT request to "/pet" to update the pet's name to "NewName"
    Then both requests should receive a success response
    And the final state of the pet should reflect one of the updates