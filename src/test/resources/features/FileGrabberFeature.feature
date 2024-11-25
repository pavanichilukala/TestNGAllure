Feature: File Grabber Functionality

  As a File Grabber component,
  I want to be able to retrieve multiple files from a specified location,
  So that I can transfer them to the designated S3 bucket and handle naming conflicts appropriately.

  @Functionality @FileRetrieval
  Scenario Outline: Transfer files to S3 bucket with correct folder structure
    Given the File Grabber has a list of files from "<vendor_location>"
    When it transfers the files to the S3 bucket
    Then each file should be stored in s3://<bucket-name>/FileConverter/"<vendor_name>"/"<year>"/"<month>"/"<day>"/"<file_type>"/"<filename>".ext

    Examples:
      | vendor_location | vendor_name | year | month | day | file_type | filename |
      | /vendor/files   | vendor1     | 2023 | 04    | 01  | txt       | file1    |
      | /vendor/files   | vendor2     | 2023 | 04    | 02  | csv       | file2    |
      | /vendor/files   | vendor3     | 2023 | 04    | 03  | xml       | file3    |

  @Functionality @NamingConflict
  Scenario: Handle naming conflicts during file transfer
    Given the File Grabber identifies a naming conflict for a file
    When it transfers the file to the S3 bucket
    Then it should append a unique identifier to the file's name before storing

  @ErrorHandling @Logging
  Scenario: Log issues encountered during file transfer
    Given the File Grabber encounters an error during file transfer
    When the error occurs
    Then it should log the error with a timestamp and the file details

  @Functionality @Metadata
  Scenario: Send metadata information upon successful file transfer
    Given the File Grabber successfully transfers a file to the S3 bucket
    When the transfer is complete
    Then it should send metadata via SNS to the FileConverter system including file name, S3 file path, vendor information, file type, file size, and conversion timestamp

  @BoundaryValueAnalysis
  Scenario Outline: Ensure file transfer with boundary values for date and time
    Given the File Grabber has a list of files from "<vendor_location>"
    When it transfers the files to the S3 bucket on "<date>" at "<time>"
    Then each file should be stored with the correct date and time in the S3 path

    Examples:
      | vendor_location | date       | time     |
      | /vendor/files   | 2023-01-01 | 00:00:00 |
      | /vendor/files   | 2023-12-31 | 23:59:59 |