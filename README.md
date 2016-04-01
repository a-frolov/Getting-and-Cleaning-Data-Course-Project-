# Getting-and-Cleaning-Data-Course-Project-

This Repo contains Code Book file that describes the data sets related to this project and run_analysis.R  file.
To run the file the working directory in R Studio should be set to the directory containing "UCI HAR Dataset" folder:
Session -> Set Working Directory -> Choose Directory...
After setting the working directory run_analysis.R file should be open: File -> Open File.. 
and sourced: Source

The work is done!

The data sets (activity labels - activity_labels.txt, parameter descriptions - features.txt, measurements for both test and train sets - X_test.txt and X_train.txt, activity data for both test and train sets - y_test.txt and y_train.txt, and subect data sets - subject_test.txt and subject_train.txt)from UCI HAR Dataset directory is loaded, all required data transformation/computation performed, these include merging of measurement, activity and subject data into one data set, subsetting this data set by required measurements (mean and std), and changing variables' names to meaningfull as required. Then the resulting data set is grouped by subject and performed activity, and the measurements withing each subject-activity are averaged resulting in tidy data set.  This  resulting tidy data set is then saved in txt format.

More details on transformation/computation can be found in  run_analysis.R file.
