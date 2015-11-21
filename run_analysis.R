library(plyr)

# Dataset is downloaded in the "UCI HAR Dataset" folder

################################################################################
# This script will do the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each
#    measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject.
################################################################################
#
# Workspace cleaning
rm(list=ls())

################################################################################
# 1. Merges the training and the test sets to create one data set

# Load features
features <- read.table('UCI HAR Dataset/features.txt')

# Load train data ..............................................................
subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt')
x_train <- read.table('UCI HAR Dataset/train/x_train.txt')
y_train <- read.table('UCI HAR Dataset/train/y_train.txt')
names(x_train) <- features[, 2]

# Load test data ...............................................................
subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt')
x_test <- read.table('UCI HAR Dataset/test/x_test.txt')
y_test <- read.table('UCI HAR Dataset/test/y_test.txt')
names(x_test) <- features[, 2]

# Merge train & test dataset
subject_data <- rbind(subject_train, subject_test)
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)

################################################################################
# 2. Extracts only the measurements on the mean and standard deviation
extract_features <- grep("-(mean|std)\\(\\)", features[, 2])
x_data <- x_data[, extract_features]

################################################################################
# 3. Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table('UCI HAR Dataset/activity_labels.txt')

# add activity label column to y_data
y_data[, 2] <- activity_labels[,2][y_data[, 1]]
names(y_data) <- c('activity_id', 'activity_label')

################################################################################
# 4.Appropriately labels the data set with descriptive variable names
names(subject_data) <- 'subject'

################################################################################
# 5. Create tidy dataset with the average of each variable for each activity
#    and each subject
merge_data <- cbind(subject_data, x_data, y_data)
tidy_data <- ddply(merge_data, .(subject, activity_label), function(x) colMeans(x[, 1:ncol(x_data)]))
write.table(tidy_data, file = 'tidy_data.txt', row.name = FALSE, quote = FALSE)



