library(plyr)

filename <- "getdata_dataset.zip"

#set location where the dataset was downloaded
setwd('C:/Users/Mike/Desktop/Data Science Coursera/Data/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset');

# 1. Merge the training and the test sets to create one data set.


x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

x_train_test <- rbind(x_train, x_test)
y_train_test <- rbind(y_train, y_test)
subject_train_test <- rbind(subject_train, subject_test)



# 2. Extract mean and standard deviation for each measurement.

features_data <- read.table("features.txt")

mean_std_dev <- grep("-(mean|std)\\(\\)", features_data[,2])
x_train_test <- x_train_test[, mean_std_dev]
names(x_train_test) <- features_data[mean_std_dev, 2]



# 3. Uses descriptive activity names to name the activities in the data set

activity_labels_data <- read.table("activity_labels.txt")

y_train_test[, 1] <- activity_labels_data[y_train_test[, 1], 2]
names(y_train_test) <- "activity"



# 4. Appropriately label the data set with descriptive variable names.

names(subject_train_test) <- "subject"
combined_data <- cbind(x_train_test, y_train_test, subject_train_test)


# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

average_activity_data <- ddply(combined_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(average_activity_data, "averages_activity_data.txt", row.name=FALSE)
