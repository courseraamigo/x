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


#load supporting libraries
library(dplyr)
library(tidyr)


#Define Constants
dir.init = getwd()

#Define important file names
file.activity_labels = "activity_labels.txt"
file.features = "features.txt"
file.output = "tidydata.txt"

# Create data frame for either the train or test data set
createDataFrame <- function(dataset) {
  if (dataset == "train") {
    directory = paste(dir.init,"/train",sep="")
    file.sub = paste(directory,"/subject_train.txt",sep="")
    file.x = paste(directory,"/X_train.txt",sep="")
    file.y = paste(directory,"/y_train.txt",sep="")
  } else if (dataset == "test") {
    directory = paste(dir.init,"/test",sep="")
    file.sub = paste(directory,"/subject_test.txt",sep="")
    file.x = paste(directory,"/X_test.txt",sep="")
    file.y = paste(directory,"/y_test.txt",sep="")
  } else {
    print("Unexpected dataset parameter")
    return(NULL)
  }
  
  #read in the data
  subjects <- tbl_df(read.table(file.sub))
  names(subjects) <- "subject_id"
  x_tbl <- tbl_df(read.table(file.x))
  y_tbl <- tbl_df(read.table(file.y))
  names(x_tbl) <- features$V2
  
  #Replace int code with activity label
  activities = c()
  y_vector <- unlist(y_tbl)
  for (i in 1:length(y_vector)) {
    labelInt <- y_vector[i]
    labelStr <- activity_labels$V2[labelInt]
    activities[i] <- labelStr
  }
  
  #select only columns with mean or std
  mean_x <- select(x_tbl,contains("mean()", ignore.case = FALSE))
  std_x <- select(x_tbl,contains("std()", ignore.case = FALSE))
  x_mean_std <- cbind(mean_x,std_x)
  
  
  
  tbl_out <- cbind(subjects,x_mean_std,activities)
  tbl_out <- mutate(tbl_out,data_source=dataset)
  return(tbl_out)
  
  
}



#read in the labels
activity_labels <- read.table(file.activity_labels, stringsAsFactors=FALSE)
features <- tbl_df(read.table(file.features))

tbl_train <- createDataFrame("train")
tbl_test <- createDataFrame("test")

#merge the two data sets
tbl_master <- rbind_list(tbl_train,tbl_test)

tbl_summary <- select(tbl_master,-data_source)
tbl_summary <- group_by(tbl_summary,subject_id,activities) %.% summarise_each(funs(mean))
col_names <- names(tbl_summary)
new_col_names = c()

names(tbl_summary)[1] <- "subject_id"
names(tbl_summary)[2] <- "activity"

write.table(tbl_summary,file.output, row.name=FALSE) 


