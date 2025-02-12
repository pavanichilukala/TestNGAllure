@PetStore @UpdatePet
Feature: Update an existing pet in the store

  Background:
    Given the PetStore API is available

  @Regression @Functionality
  Scenario Outline: Update an existing pet with valid data
    Given a pet with ID <petId> exists in the system
    When User updates the pet with the following details:
      | name   | status   | category   | tags   | photoUrls   |
      | <name> | <status> | <category> | <tags> | <photoUrls> |
    Then the API should return a success response with status code 200
    And the updated pet details should match the provided information

    Examples:
      | petId | name    | status    | category | tags           | photoUrls                    |
      | 1     | Fluffy  | available | Cat      | cute,fluffy    | http://example.com/fluffy.jpg |
      | 2     | Rex     | pending   | Dog      | large,friendly | http://example.com/rex.jpg    |
      | 3     | Tweety  | sold      | Bird     | small,yellow   | http://example.com/tweety.jpg |

  @Regression @InvalidData
  Scenario Outline: Attempt to update a pet with invalid data
    Given a pet with ID <petId> exists in the system
    When User attempts to update the pet with invalid <dataType>
    Then the API should return an error response with status code 400
    And the error message should indicate the invalid <dataType>

    Examples:
      | petId | dataType     |
      | 1     | name         |
      | 2     | status       |
      | 3     | category     |
      | 4     | tags         |
      | 5     | photoUrls    |

  @Regression @NonExistentPet
  Scenario: Attempt to update a non-existent pet
    Given a pet with ID 9999 does not exist in the system
    When User attempts to update the non-existent pet
    Then the API should return an error response with status code 404
    And the error message should indicate that the pet was not found

  @Regression @StateTransition
  Scenario Outline: Update pet status
    Given a pet with ID <petId> exists in the system with status <initialStatus>
    When User updates the pet's status to <newStatus>
    Then the API should return a success response with status code 200
    And the pet's status should be updated to <newStatus>

    Examples:
      | petId | initialStatus | newStatus  |
      | 1     | available     | pending    |
      | 2     | pending       | sold       |
      | 3     | sold          | available  |

  @Regression @BoundaryValueAnalysis
  Scenario Outline: Update pet with boundary values
    Given a pet with ID <petId> exists in the system
    When User updates the pet with the following boundary values:
      | field     | value   |
      | name      | <name>  |
      | category  | <category> |
      | photoUrls | <photoUrls> |
    Then the API should return a <responseType> response with status code <statusCode>

    Examples:
      | petId | name                                                  | category                                              | photoUrls                                            | responseType | statusCode |
      | 1     | A                                                     | A                                                     | ["http://a.com"]                                     | success      | 200        |
      | 2     | [100 character name]                                  | [100 character category]                              | ["http://example.com/very-long-url-100-characters"]  | success      | 200        |
      | 3     | [101 character name]                                  | [101 character category]                              | ["http://example.com/very-long-url-101-characters"]  | error        | 400        |
      | 4     | ""                                                    | ""                                                    | []                                                   | error        | 400        |
      | 5     | null                                                  | null                                                  | null                                                 | error        | 400        |

  @Regression @DecisionTable
  Scenario Outline: Update pet based on different combinations of data
    Given a pet with ID <petId> exists in the system
    When User updates the pet with the following combination:
      | name   | status   | category   | tags   | photoUrls   |
     