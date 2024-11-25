@FileGrabber @Functionality
Feature: Implement File Grabber functionality

  In order to transfer files to the designated S3 bucket
  As a File Grabber component
  I want to be able to retrieve multiple files from a specified location
  And handle naming conflicts appropriately

  @Regression
  Scenario Outline: Transfer files to S3 bucket with correct folder structure
    Given the File Grabber has a list of files from "<vendor_location>"
    When the File Grabber transfers the files to the S3 bucket
    Then each file should be stored in the S3 bucket with the folder structure "s3://<bucket-name>/FileConverter/<vendor_name>/<yyyy>/<mm>/<dd>/<file_type>/<filename>.ext"

    Examples:
      | vendor_location | vendor_name | yyyy | mm | dd | file_type | filename |
      | /vendor1/files  | vendor1     | 2023 | 04 | 01 | invoices  | inv001   |
      | /vendor2/files  | vendor2     | 2023 | 04 | 02 | reports   | rpt001   |

  @Regression
  Scenario: Handle naming conflicts during file transfer
    Given the File Grabber has a list of files from the vendor location
    And there is a naming conflict with an existing file in the S3 bucket
    When the File Grabber transfers the files to the S3 bucket
    Then it should transfer the files with unique identifiers to avoid conflicts

  @ErrorHandling
  Scenario: Log issues encountered during file transfer
    Given the File Grabber is transferring files to the S3 bucket
    When an error occurs during the file transfer
    Then the File Grabber should log the issue

  @SuccessNotification
  Scenario: Send metadata information upon successful file transfer
    Given the File Grabber has successfully transferred files to the S3 bucket
    When the file transfer is complete
    Then the File Grabber should send metadata information via SNS to the FileConverter system
    And the metadata should include file name, S3 file path, vendor information, file type, file size, and conversion timestamp