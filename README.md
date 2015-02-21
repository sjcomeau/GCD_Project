# GCD_Project
Getting and Cleaning Data Course Project in Coursera

This repository contains the two files required for the Course Project: 
runAnalysis.R
CodeBook.md

The runAnalysis.R contains the R script that reads the data files, processes the data, and outputs a tidy dataset to tidy_dataset.txt.  

# Data Files
There are two groups of data files: Training data and Test data.  In this case "Test" refers to that these are from the Test data group.

##Files common to both groups
features.txt          A 2 column list of indexes and 561 variable names used as column names for the numeric data.
activity_labels.txt   A 2 column list of 6 numeric codes and activity label text used to decribe the Activity.

##Training data files (7352 records per file)
subject_train.txt     A list integer codes for Subjects (persons) in the training data.
                      The value corresponds to a subject id, the position is related to the measured values.
y_train.txt           A list of integer codes for Activity codes in the training data.
                      The value corresponds to a Activty Label, the position is related to the measured values.
X_train.txt           A list of numeric values, 561 columns.
                      The column position corresponds to the features.txt index.

##Test data files (2947 records per file)  
subject_test.txt      A list integer codes for Subjects (persons) in the testing data.
                      The value corresponds to a subject id, the position is related to the measured values.
y_test.txt            A list of integer codes for Activity codes in the testing data.
                      The value corresponds to a Activty Label, the position is related to the measured values.
X_test.txt            A list of numeric values, 561 columns.
                      The column position corresponds to the features.txt index.
                      
# Process Sequence

The code requires sqldf and dplyr packages.  

1. Read the activity_labels.txt file.
2. Read the features.txt file.  Only mean and std columns are used (not including the angle columns, features 555 to 561).  Replace the "()" with empty string to remove the curved brackets and remove dashes to improve the column names.
3. Process the training data.
    a.  Read the X-train.txt file.
    b.  Get a subset of columns from xtrain dataset, based on the index numbers extracted from features.txt.
    c.  Set new column names based on the column names extracted from features.txt.
    d.  Add an Identity column to X-train dataset for use in joins.
    e.  Read the subject_train.txt file.
    f.  Add an Identity column to subject_train dataset for use in joins.
    g.  Read the y_train.txt file.
    h.  Add an Identity column to y_train dataset for use in joins.
    i.  Combine the Activity labels, Subject, and numeric data variables and create the complete train dataset.
        (This is where the id columns are used for the joins using SQL snytax and the sqldf function.)
4. Process the testing data using the same type of sequence decribed for the training data.
5. Combine the train and test datasets to one dataset.
6. Create a tidy dataset grouped by Activiy, Subject, and aggregated using the averages of each variable. Remove the id column.
7. Write the tidy dataset called "tidy_dataset.txt" to a file.
