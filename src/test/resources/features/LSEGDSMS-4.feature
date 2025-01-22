@FileDownload @SNSNotification @Regression
Feature: SFTP File Download and SNS Notification

  In order to ensure the latest financial data is available for processing
  As a data processing application
  I want to download files from the NASDAQ SFTP server and notify downstream systems via SNS with the required metadata

  @HappyPath
  Scenario Outline: Successful file download and notification for different file types
    Given the application is connected to the NASDAQ SFTP server
    And the server has "<FileType>" files available for download
    When the application downloads the "<FileType>" files
    Then the "<FileType>" files should be validated for integrity
    And a notification with "<FileType>" file metadata should be sent via SNS
    And the download activities and notifications for "<FileType>" files should be logged

    Examples:
      | FileType |
      | .xls     |
      | .csv     |
      | .txt     |

  @ErrorHandling
  Scenario: Handle download failures with retry mechanism
    Given the application is connected to the NASDAQ SFTP server
    When the file download fails
    Then the system should retry the download up to three times
    And if all retries fail, an error notification should be sent to the system administrators

  @BoundaryValueAnalysis
  Scenario Outline: File download with boundary file sizes
    Given the application is connected to the NASDAQ SFTP server
    And the server has a "<FileSize>" bytes file available for download
    When the application attempts to download the file
    Then the download should be "<Result>"

    Examples:
      | FileSize | Result    |
      | 0        | successful|
      | 1        | successful|
      | 10485760 | successful| # 10 MB
      | 10485761 | failed    | # 10 MB + 1 byte

  @DecisionTable
  Scenario Outline: File download decision based on file extension and server response
    Given the application is connected to the NASDAQ SFTP server
    And the server responds with "<ServerResponse>" for a "<FileType>" file
    When the application attempts to download the file
    Then the download should be "<DownloadResult>"
    And the notification should be "<NotificationResult>"

    Examples:
      | FileType | ServerResponse | DownloadResult | NotificationResult |
      | .xls     | 200 OK         | successful     | sent               |
      | .csv     | 404 Not Found  | failed         | not sent           |
      | .txt     | 500 Error      | failed         | not sent           |
      | .doc     | 200 OK         | failed         | not sent           | # Unsupported file type

  @StateTransition
  Scenario: File download state transition from pending to completed
    Given the application is connected to the NASDAQ SFTP server
    And the file download status is "pending"
    When the file is successfully downloaded
    Then the file download status should transition to "completed"
    And a successful download notification should be sent via SNS