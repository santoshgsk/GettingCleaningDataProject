## This is the Code Book for the "Getting and Cleaning Data"" course project on UCI's HAR Dataset

### Project Aim : To get acquainted with a real-world dataset and the naunces of its features. To be able to manipulate the data using the concepts learned through the course by carefully understanding the project requirements and in the process making responsible decisions/assumptions, which is crucial for becoming a data scientist.

Project Description : The project is about reading data from multiple files, combining data, subsetting and reshaping the content by following the principles of tidy data.

Dataset Description : The UCI HAR Dataset (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#) provided is about Human Activity Recognition using Smartphone data. There have been 30 volunteers with Samsung Galaxy S II tied to their waist performing six activities, namely WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity are captured at a constant rate of 50Hz. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

Several filters, sampling methods were applied on the outputs generated from the sensors resulting in a total of 561 features. More details are available in 'features_info.txt'.

For the purpose of this project, only the following files of the dataset are used
- 'features.txt' : Containing all the 561 feature names. (**Assumption**: The feature names are assumed to be ordered as per the columns provided in the train and test datasets)
- 'train\X_train.txt' : Train set containing only the feature values
- 'train\Y_train.txt' : Class labels for each observation in the train set (Each of the six human activities are given a unique numeric value between 1-6)
- 'test\X_test.txt' : Test set
- 'test\Y_test.txt' : Class labels for the test set
- 'activity_labels.txt' : File mentioning the numeric value mapping given to the human activities 
- 'train\subject_train.txt' : The 30 subjects are given id's from 1-30 and this file mentions which subject was involved for the observation corresponding to the same line in X_train.txt file.
- 'test\subject_test.txt' : Similar description to above

#### Data Manipulations
There is only one script, named "run_analysis.R" which performs all the following data manipulations.

1) Verifying Data availability - **Assumption** : The dataset folder name "UCI HAR Dataset" is assumed to be available in the same folder as the script "run_analysis.R" with the exact name. If not available, an error is thrown and the code execution will be stopped.

2) Reading Train / Test X and Y data - The file paths to these files are generated using file.path which is helpful while working across different OS. The data is read into R using read.table without passing any parameters.

3) Merging Train and Test data - **This is the first requirement of the project.** It says to merge the train and test data, i.e., combine the row observations. Hence, rbind function is used over the two data frames read in the earlier part of the program. Also, the Train and Test class labels are merged and kept in a separate variable.

4) Getting only mean and standard deviation measurements - **This is the second requirement of the project.** The requirement is to subset the data by considering only those features which are the mean or standard deviation measurements. Certain feature names are suffixed with "mean()", "std()" implying they are the mean, standard deviation measuring variables. To fetch such feature names from "features.txt", the "strsplit" command is used to identify if either of those suffixes are available in the name. "lapply" is used to iteratively apply the "strsplit" over all feature names and return a logical vector with TRUE values for feature names having either "mean()" or "std()".
The data is first given the column names and then using the logical vector, data is subsetted.

5) Adding the full descriptive "Activity Names" to the dataset - **This is the next requirement of the project.** Here, it means after the data is subsetted from above step, it needs to be tagged with the "Activity Names" to make it easy to understand rather than the esoteric numeric 1-6 class labels. The "Activity Names" mappings are read from the file "activity_labels.txt". Using the class labels read earlier, the corresponding "activity names" for each observation are identified by applying "lapply" function. The "activity names" and "class labels" are added to the data as extra columns.

6) Creating a new, independent tidy data set - **This is the final requirement of the project.** 
For each class and for each subject, a given feature would have a set of values. The average (mean) of those values needs to be calculated. This needs to be repeated for all other features as identified in Step 4. The melt function would take a combination of each class and subject value pair and append it with all possible values for a given feature as different observations. This is repeated for all features independently, resulting in huge observations. Further, dcast function is used to crunch all the possible values of a feature for a given class, subject pair and apply a function (read 'mean') over those values. This would result in the tidy data set as requested in the project guidelines.

7) Storing the tidy data set - Continuing the above step, the tidy data set is stored using write.table in a file name "tidy_data.txt" with tab delimiter. This function also returns the tidy data set.

### Variables in the TIDY DATA
class - The class label, a numeric value from 1-6 assigned uniquely to the human activities

activityNames - The name of the human activity in its full descriptive form. 
- 1 WALKING
- 2 WALKING_UPSTAIRS
- 3 WALKING_DOWNSTAIRS
- 4 SITTING
- 5 STANDING
- 6 LAYING

Subject - The 30 volunteers are assigned ids from 1-30 and this column suggested which volunteer(subject) is involved for that particular observation.

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. The acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ).

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ

tGravityAcc-XYZ

tBodyAccJerk-XYZ

tBodyGyro-XYZ

tBodyGyroJerk-XYZ

tBodyAccMag

tGravityAccMag

tBodyAccJerkMag

tBodyGyroMag

tBodyGyroJerkMag

fBodyAcc-XYZ

fBodyAccJerk-XYZ

fBodyGyro-XYZ

fBodyAccMag

fBodyAccJerkMag

fBodyGyroMag

fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value

std(): Standard deviation

#### The feature names of the tidy data have the same name as above. However, here it would imply that the feature name (ex: "tBodyAcc-mean()-X") is the average of all possible values (of tBodyAcc-mean()-X experiment as described above) for that subject, class pair.

The comprehensive feature description is available at "features_info.txt" in the dataset folder.

--------------------------------------------------------- END OF CODE BOOK ---------------------------------------------------------