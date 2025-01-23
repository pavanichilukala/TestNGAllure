@SFTP @FileDownload @Regression
Feature: SFTP File Download and Notification
  As a data processing application, I want to download files from `sftp://nasadaq.com/docs` using the SFTP download method and notify downstream systems with the required metadata so that users can process the latest financial data.

  @Connectivity
  Scenario: Establish a secure SFTP connection
    Given the application is set up for SFTP connection
    When the application attempts to connect to `sftp://nasadaq.com/docs`
    Then a secure SFTP connection should be established

  @FileFiltering
  Scenario: Download specific file types
    Given the application is connected to `sftp://nasadaq.com/docs`
    When the application filters files with extensions .xls, .csv, and .txt
    Then only these files should be downloaded

  @IntegrityCheck
  Scenario: Verify file integrity
    Given files are downloaded
    When the application checks the integrity of the files
    Then the integrity of the files should be verified

  @Notification
  Scenario: Send notification with file metadata
    Given files are downloaded and verified
    When the application sends a notification via SNS
    Then the notification should contain the correct file metadata

  @ErrorHandling
  Scenario: Handle errors and log
    Given there is a download attempt
    When an error occurs during the download
    Then the error should be logged and handled gracefully

  @RetryMechanism
  Scenario: Retry download on failure
    Given a download fails
    When the application retries the download up to three times
    Then the retries should be executed as specified

  @AlertSystem
  Scenario: Alert on persistent download failure
    Given all retries have failed
    When the application assesses the download failure
    Then an alert should be sent to the system administrators