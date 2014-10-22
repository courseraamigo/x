# run_analysis.R
# This script reads in data for the Human Activity Recognition Using Smartphones Data Set, 
# which consists of smartphone sensor data collected while 30 subjects performed various
# physical activities such as walking, standing, etc. The original data is split into train
# and test data sets. The script outputs a tidy data set (see Functionality)
#
# Preconditions:
# (1) User's working directory is "UCI HAR Dataset"
# (2) User has installed packages "dplyr" and "tidyr"
#
# Functionality:
# (a) Merges the training and the test sets to create one data set.
# (b) Extracts only the measurements on the mean and standard deviation for each measurement. 
# (c) Uses descriptive activity names to name the activities in the data set
# (d) labels the data set with descriptive variable names. 
# (e) Creates tidy data set with the average of each variable for each activity and each subject.
# (f) Writes tidy data set file "tidydata.txt" (space delimited) in working directory
#
