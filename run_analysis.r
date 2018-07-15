####   run_analysis.r

# This code first downloads and unzips the UCI HAR dataset.
# 
# It then concatenates the training and test sets with their
# appropriate labels.
# 
# Finally it removes unnecessary variables, and it simplifies
# remaining variable names.

library(dplyr)
library(reshape2)

Part 1: Download files and unzip

URL = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename = "UCI HAR Dataset.zip"

if(!file.exists(filename)) {
    download.file(URL,filename, mode = "wb")
}

setwd("coursera/jh data specialization/UCI HAR Dataset")

if(!file.exists(path)){
    unzip(filename)
}

# Part 2: Read data into R

activities = read.table(file.path("activity_labels.txt"))
colnames(activities) = c("act_number","act_label")

features = read.table(file.path("features.txt"),as.is = TRUE)

trainsub = read.table(file.path("train","subject_train.txt"))
trainval = read.table(file.path("train","x_train.txt"))
trainact = read.table(file.path("train","y_train.txt"))

testsub = read.table(file.path("test","subject_test.txt"))
testval = read.table(file.path("test","x_test.txt"))
testact = read.table(file.path("test","y_test.txt"))


# Part 3: Combining data sets into one
train = cbind(trainsub,trainval,trainact)
test = cbind(testsub,testval,testact)
act = rbind(train,test)

rm(trainsub,testsub,trainval,testval,trainact,testact,train,test)


# Part 4: Rename columns
colnames(act) = c("subject",features[,2],"activity")

newcols = grepl("mean|std|activity|subject",names(act),ignore.case = TRUE)
act = act[,newcols]

act[,"activity"] = factor(act[,"activity"],levels = activities[,1],
                          labels = activities[,2])


names(act) = gsub("[\\(\\)-]","",names(act))
names(act) = gsub("^f","frequency",names(act))
names(act) = gsub("mean","_mean",names(act))
names(act) = gsub("^t","time",names(act))
names(act) = gsub("Gyro","Gyroscope",names(act))
names(act) = gsub("Mag","Magnitude",names(act))
names(act) = gsub("std","_stdDev",names(act))
names(act) = gsub("Acc","Accelerometer",names(act))
names(act) = gsub("BodyBody","Body",names(act))


# Set data as means
newact = melt(act, id = c("subject","activity"))
actmean = dcast(newact, subject + activity ~ variable, mean)
write.table(actmean,"tidydata.txt")
