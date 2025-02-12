@PetStore @UpdatePet @Regression
Feature: Update an existing pet in the store

  @Functionality @HappyPath
  Scenario Outline: Successfully update an existing pet's information
    Given the pet store API is available
    And a pet with ID <petId> exists in the system
    When the user sends a PUT request to "/pet" with the following details:
      | id   | name   | status   | category   | tags   | photoUrls   |
      | <petId> | <name> | <status> | <category> | <tags> | <photoUrls> |
    Then the response status code should be 200
    And the response should contain the updated pet information
    And the pet's information should be updated in the system

    Examples:
      | petId | name    | status    | category | tags       | photoUrls                   |
      | 1     | Fluffy  | available | Cat      | cute,furry | http://example.com/fluffy.jpg |
      | 2     | Rex     | pending   | Dog      | loyal,big  | http://example.com/rex.jpg    |

  @Functionality @NegativeTesting
  Scenario: Attempt to update a non-existent pet
    Given the pet store API is available
    And a pet with ID 9999 does not exist in the system
    When the user sends a PUT request to "/pet" with the following details:
      | id   | name   | status    | category | tags | photoUrls                |
      | 9999 | Ghost  | available | Dog      | none | http://example.com/ghost.jpg |
    Then the response status code should be 404
    And the response should contain an error message indicating the pet was not found

  @Functionality @ValidationTesting
  Scenario: Attempt to update a pet with invalid data
    Given the pet store API is available
    And a pet with ID 3 exists in the system
    When the user sends a PUT request to "/pet" with the following details:
      | id | name | status | category | tags | photoUrls |
      | 3  |      |        |          |      |           |
    Then the response status code should be 400
    And the response should contain validation error messages

  @Functionality @AuthorizationTesting
  Scenario: Attempt to update a pet without proper authorization
    Given the pet store API is available
    And the user does not have valid authentication credentials
    When the user sends a PUT request to "/pet" with valid pet data
    Then the response status code should be 401
    And the response should contain an error message about unauthorized access

  @Functionality @BoundaryTesting
  Scenario Outline: Update a pet with boundary values
    Given the pet store API is available
    And a pet with ID <petId> exists in the system
    When the user sends a PUT request to "/pet" with the following details:
      | id     | name   | status   | category   | tags   | photoUrls   |
      | <petId> | <name> | <status> | <category> | <tags> | <photoUrls> |
    Then the response status code should be <expectedStatus>
    And the response should <expectedResult>

    Examples:
      | petId        | name                                   | status    | category | tags | photoUrls                   | expectedStatus | expectedResult                            |
      | 1            | A                                      | available | Cat      | cute | http://example.com/a.jpg    | 200            | contain the updated pet information       |
      | 9223372036854775807 | Very long name (255 characters)        | pending   | Dog      | long | http://example.com/long.jpg | 200            | contain the updated pet information       |
      | 0            | !@#$%^&*()                             | sold      | Bird     | spec | http://example.com/spec.jpg | 400            | contain an error about invalid ID         |
      | 4            |                                        | available | Fish     | wet  | http://example.com/fish.jpg | 400            | contain an error about missing name       |
      | 5            | Kitty                                  | invalid   | Cat      | soft | http://example.com/kitty.jpg| 400            | contain an error about invalid status     |

  @Functionality @PerformanceTesting
  Scenario: Update a pet with a large payload
    Given the pet store API is available
    And a pet with ID