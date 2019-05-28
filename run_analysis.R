library(reshape2)
library(dplyr)

filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# Load activity labels + features
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation
features_measures <- grep(".*mean.*|.*std.*", features[,2])
features_measures_names <- features[featuresWanted,2]
features_measures_names = gsub('-mean', 'Mean', featuresWanted.names)
features_measures_names = gsub('-std', 'Std', featuresWanted.names)
features_measures_names <- gsub('[-()]', '', featuresWanted.names)


# Load the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
train_activities <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_subjects, train_activities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
test_activities <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_subjects, test_activities, test)

# merge datasets and add labels
all_data <- rbind(train, test)
colnames(all_data) <- c("subject", "activity", features_measures_names)

# turn activities & subjects into factors
all_data$activity <- factor(all_data$activity, levels = activity_labels[,1], labels = activity_labels[,2])
all_data$subject <- as.factor(all_data$subject)

all_data_melt <- melt(all_data, id = c("subject", "activity"))
all_data_mean <- dcast(all_data.melt, subject + activity ~ variable, mean)

write.table(all_data_mean, "tidy.txt", row.names = FALSE, quote = FALSE)
