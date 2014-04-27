run_analysis <- function()
{
  # Verifying if the dataset is present in the current working directory
  # hard coded the Directory name
  dataset <- "UCI HAR Dataset"
  if(!file.exists(dataset))
    stop("The \"UCI HAR Dataset\" folder doesn't exist in this working directory!")
  
  # Reading train and test files
  trainSetFile <- file.path(dataset, "train", "X_train.txt")
  trainSet <- read.table(trainSetFile)
  
  testSetFile <- file.path(dataset, "test", "X_test.txt")
  testSet <- read.table(testSetFile)
  
  # Reading train and test class labels
  trainLabelFile <- file.path(dataset, "train" , "Y_train.txt")
  trainLabel <- read.table(trainLabelFile)
  
  testLabelFile <- file.path(dataset, "test", "Y_test.txt")
  testLabel <- read.table(testLabelFile)
  
  ## ------------ 1) MERGING TRAINING AND TEST DATA SET ------------ ##
  wholeSet <- rbind(trainSet, testSet)
  wholeLabels <- unlist(rbind(trainLabel, testLabel))
  wholeLabels <- as.integer(wholeLabels)
  
  
  ## ------------ 2) GETTING ONLY THE MEAN AND SD MEASUREMENTs ------------ ##
  
  # Reading features
  featuresFilePath <- file.path(dataset, "features.txt")
  featuresList <- read.table(featuresFilePath)
  featuresList[,2] <- as.character(featuresList[,2])
  
  # fetching all feature names
  allFeatures <- featuresList[,2]
  
  # creating a logical vector indicating which feature names contain either "mean()" or "std()"
  regex <- "mean\\(\\)|std\\(\\)"
  # the below expression splits a feature name with the regex above and if the split function 
  # outputs the same input value then the feature doesn't contain regex, hence returning false
  # else, if the feature name contains regex, the split output would be different from input 
  # hence returning true
  selectedVals <- unlist(lapply(allFeatures, function(x){unlist(strsplit(x, regex))[1]!=x}))

  # selecting the features names having either mean or sd measurements
  candidateFeatures <- allFeatures[selectedVals]

  # as candidate features are ready, the dataset needs to be assigned the column names, 
  # before subsetting
  # binding all feature names to the whole dataset
  names(wholeSet) <- featuresList[,2]
  
  # subsetting the data with features measuring either mean or sd measurements
  wholeSet <- wholeSet[,candidateFeatures]
  
  
  ## ------------ 3 & 4) LABELING ACTIVITY NAMES TO THE DATASET ------------ ##
  
  # Reading labels
  labelsFilePath <- file.path(dataset, "activity_labels.txt")
  activity_labels <- read.table(labelsFilePath)
  
  # Fetching activity names for the corresponding class labels
  wholeActivityNames <- unlist(lapply(wholeLabels, function(x){activity_labels[x,2]}))
  
  # Appending the class labels and activity names to the dataset
  wholeSet$class <- wholeLabels
  wholeSet$activityNames <- wholeActivityNames
  
  ## ---- 5) CREATING A NEW TIDY DATA SET-AVERAGE OF FEATURES FOR EVERY CLASS, SUBJECT  ---- ##
  
  # read subject information
  subjectTrainFilePath <- file.path(dataset, "train", "subject_train.txt")
  subjectTrain <- read.table(subjectTrainFilePath)
  
  subjectTestFilePath <- file.path(dataset, "test", "subject_test.txt")
  subjectTest <- read.table(subjectTestFilePath)

  # combining the subject information of train and test
  wholeSubjectData <- rbind(subjectTrain, subjectTest)
  # unlisting the subject data -- useful while "melt" step
  wholeSet$Subject <- unlist(wholeSubjectData)
  
  # "melt" step - duplicating data for each feature separately for which mean needs to be measured
  library(reshape2)
  
  # melt function helps in associating data corresponding to variables mentioned in "id" vector
  # to all distinct values for each variable mentioned in "measure.vars" separately
  # here, id values are "class, activityNames, Subject" as the data needs to be generated for each
  # possible combination of these values and "measure.vars" variable are the candidate features
  # extracted in Step 2
  meltedData <- melt(wholeSet, id=c("class", "activityNames", "Subject"), measure.vars=candidateFeatures)
  
  # dcast helps in summarizing over the "measure.vars" operated above for all possible
  # combinations of values in "class + activityNames + subject". However, "class" and 
  # "activityNames" are the same only represented in different format.
  # Here, for analysis purpose, the summarization function we are interested is average, i.e., mean
  newTidyData <- dcast(meltedData, class + activityNames + Subject ~ variable, mean)
  
  # writing the tidy data to a file
  write.table(newTidyData, file="tidy_data.txt", sep="\t")
  newTidyData
}