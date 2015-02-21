## 2/19/2015


## Requires sqldf and dplyr packages
library(sqldf)
library(dplyr)

## Set the number of rows to read from train and test datasets
## set to 10000 for actual use so all records are read.
rnum <- 10000

## ====================================
## process activitylabels.ds dataset 
## ====================================
##Read the activity_labels.txt into activitylabels
activitylabels.ds <- read.table("./data/activity_labels.txt", strip.white=TRUE)


## ====================================
## process fnames.ds dataset (features) 
## ====================================

## Read the features.txt file into the features dataset
features <- read.table("./data/features.txt", strip.white=TRUE, stringsAsFactors = FALSE)

## Get the dataset column names from the features dataset
## for only for mean and std (not including the angle columns, features 555 to 561)
## Replace the "()" with empty string to remove the curved brackets and remove dashes
fnames.ds <- sqldf('select V1, replace(replace(V2, "()", ""),"-", "") As V2 FROM features WHERE V2 like "%-mean%" OR V2 like "%-std%" ')


## FIRST, THE TRAIN DATA >>>>>>>>>>>

## ====================================
## process xtrain.ds dataset 
## ====================================
## Read the X-train.txt file into the xtrain dataset
xtrain <- read.table("./data/train/X_train.txt", strip.white=TRUE, nrows = rnum)

## Get a subset of columns from xtrain dataset
## using the fnames column 1 which has the column index number
## (Project Requirement #2, only mean an std columns extracted)
xtrain.ds <- xtrain[ , fnames.ds[ ,1]]

## Set new column names for xtrain.ds using fnames.ds
## (Project Requirement #4 for decriptive variable names)
names(xtrain.ds) <- fnames.ds[ ,2]

## Add Identity column to xtrain.ds
id <- c(1:nrow(xtrain.ds))
xtrain.ds <- cbind(id=id, xtrain.ds)

## ====================================
## process subjecttrain.ds dataset 
## ====================================

## Read the subject_train.txt file into subjecttrain
subjecttrain.ds <- read.table("./data/train/subject_train.txt", strip.white=TRUE, nrows = rnum)

## Add identity column
id <- c(1:nrow(subjecttrain.ds))
subjecttrain.ds <- cbind(id=id, subjecttrain.ds)

## ====================================
## process activitytrain.ds dataset 
## ====================================
## Read the y_train.txt file into activitytrain
activitytrain.ds <- read.table("./data/train/y_train.txt", strip.white=TRUE, nrows = rnum)

## Add identity column
id <- c(1:nrow(activitytrain.ds))
activitytrain.ds  <- cbind(id=id, activitytrain.ds)

## ====================================
## Combine the Activity labels, Subject, 
## and numeric data variables 
## and create the complete train dataset
## (This is where the id columns are used for the joins)
## (Project Requirement #3 for Activity Names)
## ====================================
train.ds <- sqldf('select st.V1 as Subject, al.V2 as Activity, xt.* from 
                  [activitytrain.ds] at 
                  INNER JOIN [activitylabels.ds] al ON at.V1 = al.V1
                  INNER JOIN [subjecttrain.ds] st ON at.id = st.id
                  INNER JOIN [xtrain.ds] xt ON at.id = xt.id 
                  ')

## NEXT, THE TEST DATA >>>>>>>>>>>

## ====================================
## process xtest.ds dataset 
## ====================================
## Read the X-test.txt file into the xtest dataset
xtest <- read.table("./data/test/X_test.txt", strip.white=TRUE, nrows = rnum)

## Get a subset of columns from xtest dataset
## using the fnames column 1 which has the column index number
## (Project Requirement #2, only mean an std columns extracted)
xtest.ds <- xtrain[ , fnames.ds[ ,1]]

## Set new column names for xtest.ds using fnames.ds
## (Project Requirement #4 for decriptive variable names)
names(xtest.ds) <- fnames.ds[ ,2]

## Add Identity column to xtest.ds
id <- c(1:nrow(xtest.ds))
xtest.ds <- cbind(id=id, xtest.ds)


## ====================================
## process subjecttest.ds dataset 
## ====================================

## Read the subject_test.txt file into subjecttest
subjecttest.ds <- read.table("./data/test/subject_test.txt", strip.white=TRUE, nrows = rnum)

## Add identity column
id <- c(1:nrow(subjecttest.ds))
subjecttest.ds <- cbind(id=id, subjecttest.ds)

## ====================================
## process activitytest.ds dataset 
## ====================================
## Read the y_test.txt file into activitytest
activitytest.ds <- read.table("./data/test/y_test.txt", strip.white=TRUE, nrows = rnum)

## Add identity column
id <- c(1:nrow(activitytest.ds))
activitytest.ds  <- cbind(id=id, activitytest.ds)


## ====================================
## Combine the Activity labels, Subject, 
## and numeric data variables 
## and create the complete test dataset
## (This is where the id columns are used for the joins)
## (Project Requirement #3 for Activity Names)
## ====================================
test.ds <- sqldf('select st.V1 as Subject, al.V2 as Activity, xt.* from 
                  [activitytest.ds] at 
                  INNER JOIN [activitylabels.ds] al ON at.V1 = al.V1
                  INNER JOIN [subjecttest.ds] st ON at.id = st.id
                  INNER JOIN [xtest.ds] xt ON at.id = xt.id 
                  ')

## ====================================
## Combine the train and test datasets to one dataset 
## (Project Requirement #1)
## ====================================
train_test.ds <- sqldf('select * from [train.ds] UNION ALL select * from [test.ds]')


## ====================================
## Create a tidy data set with the averages
## of each variable.  Remove the id column.
## (Project Requirement #5)
## ====================================
tds.s1 <- train_test.ds %>% group_by(Activity, Subject)
tds.s1 %>% summarise_each(funs(mean)) -> tds.s2
tidy.ds <- tds.s2[ ,!names(tds.s2) %in% c("id")]

## Write the tidy dataset to a file
write.table(tidy.ds, "tidy_dataset.txt", row.name = FALSE)

print("DONE")