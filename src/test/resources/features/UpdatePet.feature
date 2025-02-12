@PetStore @UpdatePet @Regression
Feature: Update an existing pet in the store

  Background:
    Given the PetStore API is available

  @Smoke @HappyPath
  Scenario Outline: Successfully update an existing pet with valid data
    Given a pet with ID <petId> exists in the system
    When User updates the pet with the following details:
      | name   | category   | status   |
      | <name> | <category> | <status> |
    Then the API should return a success response
    And the pet details should be updated in the system

    Examples:
      | petId | name    | category | status    |
      | 1     | Fluffy  | Cat      | available |
      | 2     | Buddy   | Dog      | pending   |
      | 3     | Tweety  | Bird     | sold      |

  @Negative @InvalidData
  Scenario Outline: Attempt to update a pet with invalid data
    Given a pet with ID <petId> exists in the system
    When User attempts to update the pet with invalid <field>: "<value>"
    Then the API should return an error response
    And the pet details should remain unchanged

    Examples:
      | petId | field    | value     |
      | 1     | id       | abc       |
      | 2     | status   | inactive  |
      | 3     | category | 123       |

  @Negative @NonexistentPet
  Scenario: Attempt to update a non-existent pet
    Given a pet with ID 9999 does not exist in the system
    When User attempts to update the non-existent pet
    Then the API should return a not found error response

  @Boundary @LongName
  Scenario: Update a pet with a very long name
    Given a pet with ID 1 exists in the system
    When User updates the pet with a name of 255 characters
    Then the API should return a success response
    And the pet name should be updated with the 255-character name

  @Boundary @EmptyFields
  Scenario: Update a pet with empty optional fields
    Given a pet with ID 2 exists in the system
    When User updates the pet with the following details:
      | name | category | status |
      |      |          |        |
    Then the API should return a success response
    And the pet's optional fields should be empty in the system

  @StateTransition
  Scenario Outline: Update pet status through different states
    Given a pet with ID 3 exists in the system with status "<initialStatus>"
    When User updates the pet status to "<newStatus>"
    Then the API should return a success response
    And the pet status should be updated to "<newStatus>" in the system

    Examples:
      | initialStatus | newStatus |
      | available     | pending   |
      | pending       | sold      |
      | sold          | available |

  @Security @Authorization
  Scenario: Attempt to update a pet without proper authorization
    Given a pet with ID 4 exists in the system
    And User does not have valid authorization credentials
    When User attempts to update the pet details
    Then the API should return an unauthorized error response

  @Performance
  Scenario: Update multiple pets in quick succession
    Given 10 pets exist in the system
    When User sends update requests for all 10 pets within 5 seconds
    Then all update requests should be processed successfully
    And the API response time for each request should be less than 500 milliseconds
