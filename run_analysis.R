# Getting and Cleaning Data
# Coursera Data Science - Course Project
# Due: Sun 22 Feb 4:30 pm 
# csnord@rvr.net

# Set working directory, where this R file is located.
setwd("C:\\dev\\rstudio\\data\\GACD")

# Download and unzip data if data not present.
if(!file.exists("Dataset.zip")){
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
  download.file(url,destfile="Dataset.zip")
  # Unzip data in local directory
  unzip(zipfile="./GACD/Dataset.zip",exdir="./GACD")
}

# 1. Merges the training and the test sets to create one data set.
# Get individual files/data & provide names
x.train <- read.table("./UCI HAR Dataset/train/X_train.txt")
x.test  <- read.table("./UCI HAR Dataset/test/X_test.txt")
features <-  rbind(x.train, x.test)
featureNames <- read.table("./UCI HAR Dataset/features.txt")
names(features) <- featureNames$V2

y.train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y.test  <- read.table("./UCI HAR Dataset/test/y_test.txt")
activity <- rbind(y.train, y.test)
names(activity)<- c("Activity")

x.subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
y.subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject <- rbind(x.subject, y.subject)
names(subject)<-c("Subject") 

# Merge it all together into a data frame.
merge <- cbind(subject, activity)
TheData <- cbind(features, merge)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

extractNames <- featureNames$V2[grep("mean\\(\\)|std\\(\\)", featureNames$V2)]
subsetNames  <- c(as.character(extractNames), "Subject", "Activity" )
TheData <- subset(TheData, select=subsetNames)


# 3. Uses descriptive activity names to name the activities in the data set

TheData$activityNames =factor(TheData$Activity, levels=c(1,2,3,4,5,6), labels=activityNames$V2) 
#head(Data$activityNames,50)


# 4. Appropriately labels the data set with descriptive variable names. 

names(TheData)<-gsub("Acc", "Accelerometer", names(TheData))
names(TheData)<-gsub("BodyBody", "Body", names(TheData))
names(TheData)<-gsub("Gyro", "Gyroscope", names(TheData))
names(TheData)<-gsub("Mag", "Magnitude", names(TheData))
names(TheData)<-gsub("tBody", "TimeBody", names(TheData))
names(TheData)<-gsub("fBody", "FrequencyBody", names(TheData))
names(TheData)<-gsub("tGravity", "TimeGravity", names(TheData))

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
TidyData <- aggregate(. ~ Subject+Activity, data=TheData, FUN=mean)
write.table(TidyData, "TidyData.txt")


