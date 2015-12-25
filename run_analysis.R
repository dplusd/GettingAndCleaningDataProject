

#below function loads test and train set from original text files, 
#and associates each row to the appropriate Y value and subject
#dim(mergeTrainAndTestSet()) == 10299, 563 where
#columns 2 - 562 are actual measurements,
#and column 563 holds the appropriate y value
mergeTrainAndTestSet <- function() {
    #load test and train data sets
    x_test <- read.table("test/X_test.txt")
    y_test <- read.table("test/y_test.txt")
    subjects_test <- read.table("test/subject_test.txt")
    x_train <- read.table("train/X_train.txt")
    y_train <- read.table("train/y_train.txt")
    subjects_train <- read.table("train/subject_train.txt")
    

    
    names(subjects_test) <- c('SUBJECT')
    names(y_test) <- c('Y')

    
    names(subjects_train) <- c('SUBJECT')
    names(y_train) <- c('Y')
    
    
    #MERGE modified x_test x_train with Y values
    fullDataset<- cbind(rbind(subjects_test, subjects_train), rbind(x_test, x_train), rbind(y_test, y_train))
    
    #return data set
    fullDataset
}

#below function receives a full data set loaded by calling the mergeTrainAndTestSet function
#loads features list, finds all features contains mean() / std() using regular expression
#returns a subset of fullDataset containing only mean and std columns together with 
#ROW_TYPE and associated Y value
keepOnlyMeanAndStdMesurments <- function (fullDataset) {
    #load features list
    features <- read.table("features.txt")
    
    #extract all mean and std columns from features list
    onlyMeanAndStdColumnIDs <- grep(".*(mean|std)\\(\\).*", features$V2)
    
    #run the below row to validate we have not missed any std / mean reading
    #features[-onlyMeanAndStdColumnIDs, ]
    
    #extract all columns to omit - this was done as I have added several columns to the original
    #dataset and thought it would be better to omit by name
    columnNamesToOmit <- paste('V', features[-onlyMeanAndStdColumnIDs, 'V1'], sep='')
    
    #extract column IDs to keep (negate the above)
    columnIDsToKeep <- (1:(ncol(fullDataset)))[!(names(fullDataset) %in% columnNamesToOmit)]
    
    #extract relevant columns
    onlyMeanAndStdColumns <- fullDataset[, columnIDsToKeep]
    
    names(onlyMeanAndStdColumns) <- c('SUBJECT', as.character(features$V2[onlyMeanAndStdColumnIDs]), 'Y')

    onlyMeanAndStdColumns
}
#add textual activity name
addActivityName <- function(DataSet)  {
    #load activity labels
    
    activity_labels <- read.table("activity_labels.txt")
    #extract the position of activity code column in dataset by given name ('Y')
    Y_ColumnInDataset <- grep("Y", colnames(DataSet))
    #merge the two tables by 'Y'
    withActivityName <- merge(x=DataSet, y=activity_labels, Y_ColumnInDataset,by.y=1)
    #reposition columns
    withActivityName <- withActivityName[, c(2:563, 564)]
}

#rename all columns in data set
renameColumnsInDataset <-function(DatasetWithActivityName) {
    
    #load features list
    features <- read.table("features.txt")
    names(DatasetWithActivityName) <- c('SUBJECT', as.character(features[, 2]), 'ACTIVITY')
    DatasetWithActivityName
}

#get features mean for subject and activity
getFeatureMeanForSubjectAndActivity <- function(renamedColumnsDataset) {
    renamedColumnsDataset<-renamedColumns
    meanPerSubjectAndActivity <- aggregate(renamedColumnsDataset[, 2:562], list(renamedColumnsDataset$SUBJECT, renamedColumnsDataset$ACTIVITY), mean)
    names(meanPerSubjectAndActivity) <- c('SUBJECT', 'ACTIVITY', paste('mean_of_', names(renamedColumnsDataset)[2:562], sep=''))
    meanPerSubjectAndActivity
}


#full flow starts here
setwd("Project/UCI HAR Dataset/")
#load full dataset
fullDataset <- mergeTrainAndTestSet()
#keep only std and mean for measurements
onlyMeanAndStd <- keepOnlyMeanAndStdMesurments(fullDataset)
#add textual activity names
withActivityName <-addActivityName(fullDataset)
#renames all columns by feature list
renamedColumns <- renameColumnsInDataset(withActivityName)
#extract feature mean per subject and activiyu
meanPerSubjectAndActivity <- getFeatureMeanForSubjectAndActivity(renamedColumns)
#extract the above to txt file
write.table(meanPerSubjectAndActivity, file='AveragePerVar.txt',  row.name=FALSE)