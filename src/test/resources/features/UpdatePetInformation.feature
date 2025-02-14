@API @Pet @Update
Feature: Update Pet Information

  As a pet store manager
  I want to update existing pet information
  So that the pet database remains accurate and up-to-date

  Background:
    Given the pet store API is available

  @Regression @HappyPath
  Scenario Outline: Successfully update an existing pet's information
    Given a pet with ID <petId> exists in the system
    When User sends a PUT request to "/pet" with the following details:
      | id   | name   | status   | category   | tags   | photoUrls   |
      | <petId> | <name> | <status> | <category> | <tags> | <photoUrls> |
    Then the response status code should be 200
    And the response body should contain the updated pet information
    And the pet's information should be updated in the database

    Examples:
      | petId | name    | status    | category | tags          | photoUrls                   |
      | 1     | Fluffy  | available | Cat      | cute,friendly | http://example.com/fluffy.jpg |
      | 2     | Rex     | pending   | Dog      | large,guard   | http://example.com/rex.jpg    |

  @Regression @NegativeTesting
  Scenario: Attempt to update a non-existent pet
    Given a pet with ID 9999 does not exist in the system
    When User sends a PUT request to "/pet" with the following details:
      | id   | name   | status    | category | tags  | photoUrls                |
      | 9999 | Ghost  | available | Dog      | white | http://example.com/ghost.jpg |
    Then the response status code should be 404
    And the response body should contain an error message indicating the pet was not found

  @Regression @ValidationTesting
  Scenario: Attempt to update a pet with invalid data
    Given a pet with ID 3 exists in the system
    When User sends a PUT request to "/pet" with the following invalid details:
      | id | name | status  | category | tags | photoUrls |
      | 3  |      | invalid |          |      |           |
    Then the response status code should be 400
    And the response body should contain validation error messages

  @Regression @AuthorizationTesting
  Scenario: Attempt to update a pet without proper authorization
    Given a pet with ID 4 exists in the system
    And User does not have valid authorization credentials
    When User sends a PUT request to "/pet" with valid pet details
    Then the response status code should be 401
    And the response body should contain an authorization error message

  @Regression @ContentTypeTesting
  Scenario: Update a pet with different content types
    Given a pet with ID 5 exists in the system
    When User sends a PUT request to "/pet" with valid pet details in "<contentType>" format
    Then the response status code should be 200
    And the response body should contain the updated pet information

    Examples:
      | contentType         |
      | application/json    |
      | application/xml     |
      | application/x-www-form-urlencoded |

  @Regression @PerformanceTesting
  Scenario: Verify response time for updating pet information
    Given a pet with ID 6 exists in the system
    When User sends a PUT request to "/pet" with valid pet details
    Then the response status code should be 200
    And the response time should be less than 500 milliseconds

  @Regression @BoundaryTesting
  Scenario Outline: Update pet with boundary values
    Given a pet with ID <petId> exists in the system
    When User sends a PUT request to "/pet" with the following boundary details:
      | id     | name   | status   | category   | tags   | photoUrls   |
      | <petId> | <name> | <status> | <category> | <tags> | <photoUrls> |
    Then the response status code should be <expectedStatus>
    And the response body should <expectedResult>

    Examples:
      | petId        | name                                   | status    | category | tags                   | photoUrls                                | expectedStatus | expectedResult                            |
      | 0            | A                                      | available | Cat      | t                      | http://a.com                             | 400            | contain a validation error for petId      |
      | 9999999999  