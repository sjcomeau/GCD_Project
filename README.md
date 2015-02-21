# GCD_Project
Getting and Cleaning Data Course Project in Coursera

This repository contains the three files required for the Course Project: 
* README.md  (this file)
* runAnalysis.R
* CodeBook.md

__README.md__ descibes the data files used in this analysis and the data processing steps used to produce the tidy dataset output file *tidy_dataset.txt*.

__runAnalysis.R__ contains the R script that reads the data files, processes the data, and outputs a tidy dataset to *tidy_dataset.txt*.  

__CodeBook.md__ contains the list of variables and variable attributes used in the tidy dataset.

# Data Files
There are two groups of data files: Training data and Test data.  In this case "Test" refers to that these are from the Test data group.

##Files common to both groups

Filename              | Description
--------------------- | ----------------------------------------------------------------------------------------------------
features.txt          | 2 column list of indexes and 561 variable names used as column names for the numeric data.
activity_labels.txt   | 2 column list of 6 numeric codes and activity label text used to decribe the Activity.

##Training data files (7352 records per file)

Filename              | Description
--------------------- | ----------------------------------------------------------------------------------------------------
subject_train.txt     | list integer codes for Subjects (persons) in the training data.  The value corresponds to a subject id, the position is related to the measured values.
y_train.txt           | list of integer codes for Activity codes in the training data. The value corresponds to a Activty Label, the position is related to the measured values.
X_train.txt           | list of numeric values, 561 columns. The column position corresponds to the features.txt index.

##Test data files (2947 records per file)  

Filename              | Description
--------------------- | ----------------------------------------------------------------------------------------------------
subject_test.txt      | list integer codes for Subjects (persons) in the testing data. The value corresponds to a subject id, the position is related to the measured values.
y_test.txt            | list of integer codes for Activity codes in the testing data. The value corresponds to a Activty Label, the position is related to the measured values.
X_test.txt            | list of numeric values, 561 columns. The column position corresponds to the features.txt index.
                      
# Data Processing Sequence

The code requires sqldf and dplyr packages.  

1. Read the activity_labels.txt file.
2. Read the features.txt file.  Only mean and std columns are used (not including the angle columns, features 555 to 561).  Replace the "()" with empty string to remove the curved brackets and remove dashes to improve the column names.
3. Process the training data.
    + a.  Read the X-train.txt file.
    + b.  Get a subset of columns from xtrain dataset, based on the index numbers extracted from features.txt.
    + c.  Set new column names based on the column names extracted from features.txt.
    + d.  Add an Identity column to X-train dataset for use in joins.
    + e.  Read the subject_train.txt file.
    + f.  Add an Identity column to subject_train dataset for use in joins.
    + g.  Read the y_train.txt file.
    + h.  Add an Identity column to y_train dataset for use in joins.
    + i.  Combine the Activity labels, Subject, and numeric data variables and create the complete train dataset.
        (This is where the id columns are used for the joins using SQL snytax and the sqldf function.)
4. Process the testing data using the same type of sequence decribed for the training data.
5. Combine the train and test datasets to one dataset.
6. Create a tidy dataset grouped by Activiy, Subject, and aggregated using the averages of each variable. Remove the id column.
7. Write the tidy dataset to file *tidy_dataset.txt*.

## Dataset Source

Human Activity Recognition Using Smartphones Dataset <br>
Version 1.0 <br>
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto. <br>
Smartlab - Non Linear Complex Systems Laboratory <br>
DITEN - Universit‡ degli Studi di Genova. <br>
Via Opera Pia 11A, I-16145, Genoa, Italy. <br>
activityrecognition@smartlab.ws <br>
www.smartlab.ws <br>


Use of this dataset in publications is acknowledged by referencing the following publication [1] <br> 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
