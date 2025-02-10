@Functionality @SFTP @SNS
Feature: SFTP File Download and SNS Notification

  As a system user,
  I want to download files from the SFTP server and send an SNS notification
  So that the downstream system is informed about the new files.

  Background:
    Given the system is configured with valid SFTP server credentials
    And the system has a valid SNS topic ARN

  @Regression @HappyPath
  Scenario: Successfully download file from SFTP server and send SNS notification
    Given the SFTP server is available
    And a file named "test_file.csv" exists on the SFTP server
    When the system initiates the file download process
    Then the file "test_file.csv" should be downloaded successfully
    And an SNS notification should be sent with the following details:
      | Attribute | Value                     |
      | FileName  | test_file.csv             |
      | FileSize  | 1024                      |
      | Timestamp | 2023-05-15T10:00:00Z      |
      | Status    | Download_Success          |

  @ErrorHandling
  Scenario: Handle SFTP server unavailability
    Given the SFTP server is unavailable
    When the system attempts to connect to the SFTP server
    Then the system should log an error message "Unable to connect to SFTP server"
    And no SNS notification should be sent

  @ErrorHandling
  Scenario: Handle incorrect file format
    Given the SFTP server is available
    And a file named "invalid_file.txt" exists on the SFTP server
    When the system downloads the file "invalid_file.txt"
    Then the system should log an error message "Invalid file format"
    And an SNS notification should be sent with the following details:
      | Attribute | Value                     |
      | FileName  | invalid_file.txt          |
      | FileSize  | 512                       |
      | Timestamp | 2023-05-15T11:00:00Z      |
      | Status    | Invalid_Format            |

  @Regression @BoundaryValueAnalysis
  Scenario Outline: Handle files of various sizes
    Given the SFTP server is available
    And a file named "<fileName>" with size <fileSize> bytes exists on the SFTP server
    When the system initiates the file download process
    Then the file "<fileName>" should be downloaded successfully
    And an SNS notification should be sent with the correct file size

    Examples:
      | fileName    | fileSize |
      | empty.csv   | 0        |
      | small.csv   | 1        |
      | medium.csv  | 1048576  |
      | large.csv   | 1073741824 |

  @StateTransition
  Scenario: Retry download on temporary SFTP server failure
    Given the SFTP server is initially unavailable
    When the system attempts to connect to the SFTP server
    Then the system should retry the connection after 5 minutes
    And the SFTP server becomes available during the retry
    And the file "retry_file.csv" should be downloaded successfully
    And an SNS notification should be sent with the status "Download_Success_After_Retry"

  @Regression @DecisionTable
  Scenario Outline: Handle various SFTP server responses
    Given the SFTP server is available
    When the system attempts to download a file with response "<serverResponse>"
    Then the system should handle the response appropriately
    And the correct SNS notification should be sent

    Examples:
      | serverResponse     | 
      | 200_OK             |
      | 404_NOT_FOUND      |
      | 403_FORBIDDEN      |
      | 500_SERVER_ERROR   |

  @Security
  Scenario: Ensure secure SFTP connection
    Given the system is configured to use SFTP with SSH key authentication
    When the system connects to the SFTP server
    Then the connection should be established using a secure channel
    And the system should verify the server's host key

  @Performance
  Scenario: Download multiple files within time limit
    Given the SFTP server contains 100 files of 1MB each
    When the system initiates the file download process
    Then all 100 files should be downloaded within 5 minutes
    And 100 SNS notifications should be sent, one for each file
