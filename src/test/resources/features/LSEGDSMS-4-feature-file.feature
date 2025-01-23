Feature: SFTP File Download and SNS Notification

  As a data processing application, I want to download files from `sftp://nasdaq.com/docs` using the SFTP download method and notify downstream systems via SNS with the required metadata so that users can process the latest financial data.

  @Regression @FileDownload
  Scenario Outline: Download specific file formats from NASDAQ SFTP server
    Given the application has established a secure SFTP connection to "sftp://nasdaq.com/docs"
    When the application attempts to download a "<FileType>" file
    Then the file should be successfully downloaded
    And the integrity of the downloaded file should be validated

    Examples:
      | FileType |
      | xls      |
      | csv      |
      | txt      |

  @Regression @Notification
  Scenario: Send SNS notification after successful file download
    Given a file has been successfully downloaded and validated
    When the application sends an SNS notification to the downstream system
    Then the notification should include the file's name, size, format, and timestamp

  @Regression @Logging
  Scenario: Log all download activities and notifications
    Given a file download and notification process is initiated
    When the process is completed
    Then all download activities and notifications sent should be logged

  @Regression @ErrorHandling
  Scenario Outline: Retry download on failure and send error notification after retries
    Given the application has established a secure SFTP connection to "sftp://nasdaq.com/docs"
    When the application fails to download a "<FileType>" file
    Then the system should retry the download up to three times
    And if the download fails after retries
    Then an error notification should be sent to the system administrators

    Examples:
      | FileType |
      | xls      |
      | csv      |
      | txt      |