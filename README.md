# Data-Cleaning-Project
Course project for Coursera Getting and cleaning data
## Initial received instructions, and comments
You should create one R script called run_analysis.R that does the following

1. Merges the training and the test sets to create one data set
2. Extracts only the measurements on the mean and standard deviation for each measurement
    * According to the info available on ***UCI HAR Dataset/features_info.txt*** and ***UCI HAR Dataset/features.txt*** we infer these are the features that include **mean()** or **std()** on their names
3. Uses descriptive activity names to name the activities in the data set
    * The features names are already descriptive, they just have some **"-"** that we changed to **"_"** and the **()**  we eliminated
    * With this info, no further description of the variable names/meaning is needed at this point, for further detail refer to ***UCI HAR Dataset/features_info.txt*** and ***UCI HAR Dataset/README.txt*** keeping in mind we performed the above mentioned tranformation of names, and the final variables are averages of the originals by activity and subject.
4. Appropriately labels the data set with descriptive variable names
    * Here we use the labels in ***UCI HAR Dataset/activity_labels.txt***
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
    * The data in step **4** is named **tW** for tidy-Wide, no need of tidy narrow on this excercise
    * The averaged data is named **meanOfMeanAndStdW**
	
## Getting data
```javascript
library("downloader")
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download(url,destfile="UCI HAR Dataset.zip",mode="curl")
unzip("UCI HAR Dataset.zip",exdir = "./")
```
If in a Windows 7 machine you can do this:
```javascript
download(url,destfile="UCI HAR Dataset.zip")
unzip("UCI HAR Dataset.zip")
```

## Explanation of the cleaning data process 
All the code for going from raw to tidy data is in **run_analysis.R**, included on this repo. This script runs on **Mac OS X 10.7.5**, and **RStudio Version 0.99.447**. The folder ***UCI HAR Dataset*** is assumed to be on the working directory. 
## Required R packages
1. dplyr
2. stringr
3. downloader. Not by the script but for downloading the data

### Reading the data
Since what we have been asked is only related to variables with "-mean()" or "-std()" on the name, we don't see any point on loading/reading columns we don't need. That's just a waste of memory/resources. This becomes more important when the data sets are realy big. So, first thing we are going to do is just figure out which columns we want to read and which don't.
The feature.txt has the names of all the columns on the second column, so we only read the second column by using **colClasses = c("NULL","character")**, and in the same line go from table to vector of characters by using **[,1]**
```javascript
colNames<-read.table("./UCI HAR Dataset/features.txt",stringsAsFactors = FALSE,colClasses = c("NULL","character"))[,1]
```
- Building vector for only reading the columns we care about through the use of argument **colClass** of **read.table**

    - The indices for those columns that correspond to **mean()** or **std()**
    ```javascript
    library("stringr")
    mean_std_colInd<-grep("mean\\(\\)|std\\(\\)",colNames)
    ```
    - And now the core of this part
    ```javascript
    cc<-rep("NULL",length(colNames))
    cc[mean_std_colInd]<-"numeric"
    ```
- Cleaning up variable names
    - Those **"-"** are problematic on variable names, same for **"()"**, bad choice/taste. Replace **"-"** with **"_"**, and eliminate the **"()"** 
    ```javascript
    colNames<-str_replace_all(colNames,"-","_")
    colNames<-str_replace_all(colNames,"\\(\\)","")
    ```
- Put together the test data
    - By using **cbind** at this point we avoid further complication and later can simply use **rbind** to combine the train and test data
    ```javascript
    activity_test<-read.table("./UCI HAR Dataset/test/y_test.txt",col.names = c("activity"))
    subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt",col.names = c("subject"))
    measurements_test<-read.table("./UCI HAR Dataset/test/X_test.txt",col.names = colNames,colClasses = cc)
    test_t<-cbind(activity_test,subject_test,measurements_test)#column bind the 3 tables
    ```
- Put together train data
    - Completely analogous to the test data step
    ```javascript
    activity_train<-read.table("./UCI HAR Dataset/train/y_train.txt",col.names = c("activity"))
    subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt",col.names = c("subject"))
    measurements_train<-read.table("./UCI HAR Dataset/train/X_train.txt",col.names = colNames,colClasses = cc)
    train_t<-cbind(activity_train,subject_train,measurements_train)#column bind the 3 tables
    ```
    
### Combine train and test data
Just keeping it simple, there is no problem/shame on using old **rbind** 
```javascript
tW<-rbind(test_t,train_t)
```
### Naming activities
Let us make it simple, no need for merge, join or the like. Just simple old indexing
```javascript
al<-read.table("./UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE,colClasses =c("NULL","character"))[,1]
tW$activity<-al[tW$activity]
```
### Summarizing wide tidy data
```javascript
library("dplyr")
meanOfMeanAndStdW<-summarise_each(group_by(tW,activity,subject),funs(mean))
```
# The End
