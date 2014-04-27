GettingCleaningDataProject
==========================

Getting And Cleaning Data Course Project Readme File

All the project requirements are worked out only in one R script "run_analysis.R".

To run the program, first source the file

- source("run_analysis.R")

Followed by the function call, without any arguments

- tidyData <- run_analysis()

The function returns a "tidyData" data frame which contains data as mentioned in the project requirements step 5. Also, the function stores the "tidyData" in a file named "tidy_data.txt" with tab delimiter in the same folder as the script.


**Assumption** - The dataset folder "UCI HAR Dataset" is assumed to be present with the exact name in the same folder as the "run_analysis.R". If not present, the code will output an error and the program will exit.

The dataset files used, analysis performed and assumptions made are all provided in the CodeBook.md file.
