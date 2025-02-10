Feature: SFTP File Download and SNS Notification

  @Functionality @Regression
  Scenario Outline: Download files from NASDAQ SFTP server and send SNS notification
    Given the application is connected to "sftp://nasdaq.com/docs"
    When the application downloads a file with extension "<file_extension>"
    Then the file integrity should be validated
    And an SNS notification should be sent to the downstream system
    And the notification should include file name, size, format, and timestamp
    And the download activity and notification should be logged

    Examples:
      | file_extension |
      | .xls           |
      | .csv           |
      | .txt           |

  @Functionality @Regression
  Scenario: Attempt to download unsupported file format
    Given the application is connected to "sftp://nasdaq.com/docs"
    When the application attempts to download a file with extension ".pdf"
    Then the file should not be downloaded
    And an error message should be logged

  @Functionality @Regression
  Scenario: Retry download on failure
    Given the application is connected to "sftp://nasdaq.com/docs"
    And a file download fails
    When the application retries the download
    Then the download should be attempted up to 3 times
    And if successful, an SNS notification should be sent
    And if unsuccessful after 3 attempts, an error notification should be sent to system administrators

  @Functionality @Regression
  Scenario: Validate SNS notification content
    Given a file has been successfully downloaded
    When the SNS notification is generated
    Then the notification should contain the following information:
      | Metadata   | Description                    |
      | File Name  | The name of the downloaded file |
      | File Size  | The size of the file in bytes   |
      | Format     | The file extension              |
      | Timestamp  | The date and time of download   |

  @Functionality @Regression
  Scenario: Log download activities and notifications
    Given the application has performed a file download
    And an SNS notification has been sent
    When the logging process is triggered
    Then the system should record the following information:
      | Log Entry                |
      | Download start time      |
      | Download completion time |
      | File details             |
      | Notification sent time   |
      | Notification content     |

  @Functionality @Regression
  Scenario: Handle SFTP connection failure
    Given the SFTP server "sftp://nasdaq.com/docs" is unavailable
    When the application attempts to establish a connection
    Then the application should log the connection failure
    And retry the connection up to 3 times
    And if unsuccessful, send an error notification to system administrators

  @Functionality @Regression
  Scenario: Process multiple files in a single session
    Given the application is connected to "sftp://nasdaq.com/docs"
    When multiple files with supported extensions are available
    Then the application should download all supported files
    And send separate SNS notifications for each downloaded file
    And log the activities for each file separately