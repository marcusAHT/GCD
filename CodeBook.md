## Explanation of variables
The original variables are those described in ***UCI HAR Dataset/features_info.txt*** and ***UCI HAR Dataset/README.txt***. 
The complete set of variables names is in ***UCI HAR Dataset/features.txt***. Out of those variables we were asked to only use
 the ones related to mean and standard deviation, a total of 66 variables. 
After filtering out those we merged the train and test data sets, and found the average (mean) for each of the 66 variables, 
by *subject* and *activity*. We changed the name a bit, in the following way:

1. *"-"* were replaced by *"_"*
2. *()* were eliminated

So, for example the final variable that represents the average by *subject* and *activity* of the original variable **tBodyAcc-mean()-X** is named **tBodyAcc_mean_X**.
 Similarly, the mean by *subject* and *activity* of **tBodyAcc-std()-X** is **tBodyAcc_std_X**.
 Notice, that the last variable is an average of standard deviation. All the final variables are averages, even if they have "std" on their names.
 The "std" comes to indicate that the variable is the mean of standard deviations.

The complete mapping of original to final variable names is in the file [Column Name Mapping.txt](GCD/Column Name Mapping.txt). This file can be reproduced using the following code:

```javascript
colNames<-read.table("./UCI HAR Dataset/features.txt",stringsAsFactors = FALSE,colClasses = c("NULL","character"))[,1]
mean_std_colInd<-grep("mean\\(\\)|std\\(\\)",colNames)
oldColNames<-colNames[mean_std_colInd]
colNames<-str_replace_all(oldColNames,"-","_")
colNames<-str_replace_all(colNames,"\\(\\)","")
t<-data.frame(oldColNames,colNames)
write.table(t,file="Column Name Mapping.txt")
```
