library(dplyr)

## Read activity labels into R
tempactivitylabels = read.table("./UCI HAR Dataset/activity_labels.txt", sep = "")
activitylabels <- as.character(tempactivitylabels$V2)

## Read attributes names into R
tempattributenames <- read.table("./UCI HAR Dataset/features.txt", sep = "")
attributenames <- as.character(tempattributenames$V2)

## Remove temporary tables
rm(tempactivitylabels, tempattributenames)


## Read test partition  of the data into R.

## Measurments
testdata <- read.table("./UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)

## Activity info
ytestdata <- read.table("./UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)

## Subject info
subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "")


## Read train partition of the data into R.

## Measurements
traindata <- read.table("./UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)

## Activity info
ytraindata <- read.table("./UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)

## Subject info
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "")


## Merge test and train data
measurementsdata <- rbind(testdata, traindata)
activitydata <- rbind(ytestdata, ytraindata)
subjectdata <- rbind(subjecttest, subjecttrain)


## Assign variables names
names(measurementsdata) <- attributenames
names(activitydata) <- "activity"
names(subjectdata) <- "subject"


## Convert names into factors.
activitydata$activity <- as.factor(activitydata$activity)
levels(activitydata$activity) <- activitylabels
subjectdata$subject <- as.factor(subjectdata$subject)


## Find all variables with measurements of mean and standard deviation for each measurement
means <- grep("-mean()", names(measurementsdata), fixed = TRUE)
stds <- grep("-std()", names(measurementsdata), fixed = TRUE)

## Extract only mean and std measurements
cols <- c(means, stds)
selecteddata <- measurementsdata[, cols]


## Combine selected measurements, activity and subject data into required data set
dataset <- cbind(selecteddata, subjectdata, activitydata)

## Change variables name into descriptive names
names(dataset) <- sub("^t", "time", names(dataset))
names(dataset) <- sub("^f", "frequency", names(dataset))
names(dataset) <- sub("BodyAcc", "bodyacceleration", names(dataset))
names(dataset) <- sub("BodyGyro", "bodygyroscope", names(dataset))
names(dataset) <- sub("GravityAcc", "gravityacceleration", names(dataset))                     
names(dataset) <- sub("Jerk", "jerk", names(dataset))
names(dataset) <- sub("Body", "", names(dataset))
names(dataset) <- sub("Mag", "magnitude", names(dataset))
names(dataset) <- sub("\\(\\)", "", names(dataset))
names(dataset) <- sub("-X", "byx", names(dataset))
names(dataset) <- sub("-Y", "byy", names(dataset))
names(dataset) <- sub("-Z", "byz", names(dataset))

for (i in 1:66) {
  if (grepl("-mean", names(dataset)[i]) == TRUE) {
    names(dataset)[i] <- sub("-mean", "", names(dataset)[i])
    names(dataset)[i] <- paste("meanof", names(dataset)[i], sep = "") 
  }
  if(grepl("-std", names(dataset)[i]) == TRUE) {
    names(dataset)[i] <- sub("-std", "", names(dataset)[i])
    names(dataset)[i] <- paste("stdof", names(dataset)[i], sep = "") 
  }
}


## Save data from step 4 into a file
## dump("dataset", "dataset.Rdmpd")
## write.table(dataset, "dataset.txt", row.names = FALSE)

## Group data set by subject and activity
groupeddata <- group_by(dataset, subject, activity)

## Calculate average for each activity in each group for each subject
tidydata <- summarise_each(groupeddata, funs(mean))

## Save data into a file
dump("tidydata", "tidydata.Rdmpd")
write.table(tidydata, "tidydata.txt", row.names = FALSE)

