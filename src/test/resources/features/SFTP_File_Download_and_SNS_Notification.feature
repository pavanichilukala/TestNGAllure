@Regression @Functionality
Feature: SFTP File Download and SNS Notification

  Background:
    Given the application is connected to the NASDAQ SFTP server

  @Positive
  Scenario: Successful file download and notification
    And only files with the extensions .xls, .csv, and .txt are targeted for download
    When the application downloads the file successfully
    Then it should validate the integrity of the downloaded files
    And send an SNS notification with the file name, size, format, and timestamp
    And log the download activity

  @Negative
  Scenario: File download retries on failure
    When the file download fails
    Then the application retries the download up to three times
    And if all retries fail, send an error notification to system administrators

  @BoundaryValueAnalysis
  Scenario Outline: File download with boundary size conditions
    Given the file <file_name> with size <file_size> is available for download
    When the application attempts to download the file
    Then the file download should be <result>

    Examples:
      | file_name | file_size | result       |
      | test1.csv | 0 KB      | unsuccessful |
      | test2.csv | 1 KB      | successful   |
      | test3.csv | 100 MB    | successful   |
      | test4.csv | 101 MB    | unsuccessful |

  @StateTransition
  Scenario: File download state transition from start to finish
    Given the file "financial_report.csv" is ready for download
    When the application starts the download
    Then the state should transition from "start" to "downloading"
    And eventually transition to "completed" after successful download
    And the final state should be "notified" after sending the SNS notification

  @DecisionTable
  Scenario Outline: File download decision based on file extension and size
    Given the file <file_name> with size <file_size>
    When the application checks the file for download eligibility
    Then the download decision should be <decision>

    Examples:
      | file_name      | file_size | decision    |
      | report.xls     | 10 MB     | download    |
      | report.csv     | 50 MB     | download    |
      | report.txt     | 5 MB      | download    |
      | report.pdf     | 10 MB     | do not download |
      | report.exe     | 20 MB     | do not download |