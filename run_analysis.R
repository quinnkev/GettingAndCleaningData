#Load required libraries for analysis
library(dplyr)

#Define locations of files extracted from downloaded zip file
#Assumption is that file has been extracted into the R Working Dir
x_test_set_loc <- "./UCI HAR Dataset/test/X_test.txt"
x_train_set_loc <- "./UCI HAR Dataset/train/X_train.txt"
subject_test_set_loc <- "./UCI HAR Dataset/test/subject_test.txt"
y_test_set_loc <- "./UCI HAR Dataset/test/y_test.txt"
y_train_set_loc <- "./UCI HAR Dataset/train/y_train.txt"
subject_train_set_loc <- "./UCI HAR Dataset/train/subject_train.txt"
features_loc <- "./UCI HAR Dataset/features.txt"
activity_labels_loc <- "./UCI HAR Dataset/activity_labels.txt"

#Read in the test data from locations defined above
x_test <- read.table(x_test_set_loc)
x_train <- read.table(x_train_set_loc)
y_test <- read.table(y_test_set_loc)
y_train <- read.table(y_train_set_loc)
subject_test <- read.table(subject_test_set_loc)
subject_train <- read.table(subject_train_set_loc)
features <- read.table(features_loc)
activity_labels <- read.table(activity_labels_loc)

#Combine each of these pairs of data sets by type
x_df <- rbind(x_test,x_train)
y_df <- rbind(y_test,y_train)
subject_df <- rbind(subject_test, subject_train)

#Remove special characters from the column labels in the features dataframe
labelsvector <- gsub("[[:punct:]]", "", features$V2)
#Apply labels to the x data frame
colnames(x_df) <- labelsvector

#Identify and select only columns for mean and std from x data frame
meanorstdcols <- grep("mean|std",colnames(x_df))
x_df <- x_df[,meanorstdcols]

#Include the activity labels and the subject
y_df <- merge(y_df, activity_labels, x.by = "V1", y.by = "V1")
colnames(y_df)[2] <- "activity"
colnames(subject_df)[1] <- "subject"
x_df <- cbind(x_df,y_df$activity, subject_df$subject)
colnames(x_df)[80:81] <- c("activity","subject")

#Aggregate data by activity and subject
tidydata <- aggregate(. ~ subject+activity, data=x_df, FUN=mean)

#Write this to a text file
write.csv(tidydata,"./tidydata.csv")




