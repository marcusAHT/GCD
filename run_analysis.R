#First let us identify the column names and the indices of the columns we care about
#This step should be common for both train and test data, so we do it only once here
colNames<-read.table("./UCI HAR Dataset/features.txt",stringsAsFactors = FALSE,colClasses = c("NULL","character"))[,1]
library("stringr")
mean_std_colInd<-grep("mean\\(\\)|std\\(\\)",colNames)#the indices for those columns that correspond to mean() or std()
cc<-rep("NULL",length(colNames))#we don't need most of the columns
cc[mean_std_colInd]<-"numeric"#these are the only columns we want
colNames<-str_replace_all(colNames,"-","_")#those "-" are problematic on variable names
colNames<-str_replace_all(colNames,"\\(\\)","")#same for "()", bad choice/taste
#Let us put together the test data
activity_test<-read.table("./UCI HAR Dataset/test/y_test.txt",col.names = c("activity"))
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt",col.names = c("subject"))
#It is better to get rid of unwanted columns early, then when merging we are merging smaller 
#data. More memory efficient
measurements_test<-read.table("./UCI HAR Dataset/test/X_test.txt",col.names = colNames,colClasses = cc)
test_t<-cbind(activity_test,subject_test,measurements_test)#column bind the 3 tables
#And now the train data
activity_train<-read.table("./UCI HAR Dataset/train/y_train.txt",col.names = c("activity"))
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt",col.names = c("subject"))
measurements_train<-read.table("./UCI HAR Dataset/train/X_train.txt",col.names = colNames,colClasses = cc)
train_t<-cbind(activity_train,subject_train,measurements_train)#column bind the 3 tables
#merging, by using cbind first and rbind second I shouldn't have any issues here
tW<-rbind(test_t,train_t)
#Naming activities, let us make it simple, no need for merge, join or the like. Just simple old indexing
al<-read.table("./UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE,colClasses = c("NULL","character"))[,1]
tW$activity<-al[tW$activity]
#summarizing wide tidy data
library("dplyr")
meanOfMeanAndStdW<-summarise_each(group_by(tW,activity,subject),funs(mean))
