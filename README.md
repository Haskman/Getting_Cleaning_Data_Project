# Getting and Cleaning Data

## run_analysis.R

The analysis script:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

## Running the script

To run the script, source `run_analysis.R`. After running, you will see the following output as the script works:

```
> ##Merge the training and the test sets to create one data set.
> 
> #Read files
> 
> X_test <- read.table("test//X_test.txt", sep = "\t")
> X_train <- read.table("train//X_train.txt", sep = "\t")
> y_test <- read.table("test//y_test.txt", sep = "\t")
> y_train <- read.table("train//y_train.txt", sep = "\t")
> subject_test <- read.table("test//subject_test.txt", sep = "\t")
> subject_train <- read.table("train//subject_train.txt", sep = "\t")
> 
> #Merge test and training sets with with rbind()
> X_data <- rbind(X_test, X_train)
> y_data <- rbind(y_test,y_train)
> subject_data <- rbind(subject_test, subject_train)
> 
> #Merge the merged test and data sets into one final dataset with cbind()
> initial_data <- cbind(X_data, y_data, subject_data)
> 
> #Create a new data set from the initial data to use as the final set
> final_data <- initial_data
> 
> #Clean the variables no longer necessary
> remove(X_test)
> remove(X_train)
> remove(y_test)
> remove(y_train)
> remove(subject_test)
> remove(subject_train)
> remove(X_data)
> remove(y_data)
> remove(subject_data)
> 
> ##Extract mean and standard deviation for each measurement using strsplit().
> 
> #Create a vector for each wanted value
> 
> means <- c()
> std_deviations <- c()
> 
> #Loop over column 1 to split measures, convert to numeric and get the means and std.deviations while ignoring NA values
> 
> for (entry in final_data[, 1]){
+   means <- c(means, mean(na.omit(sapply(strsplit(entry, " "), as.numeric))))
+   std_deviations <- c(std_deviations, sd(na.omit(sapply(strsplit(entry, " "), as.numeric))))
+ }
> 
> #remove unnecessary variable
> remove(entry)
> 
> 
> ##Label the data set with descriptive variable names.
> names(final_data) <- c("Measurement","Activity","Subject")
> 
> ##Use descriptive activity names to replace the activities in the data set
> 
> #Load activity name data
> activity_labels <- read.table("activity_labels.txt")
> activity_labels[,2] <- as.character(activity_labels[,2])
> 
> #Replace activity numbers with activity names
> final_data$Activity <- factor(final_data$Activity, levels = activity_labels[,1], labels = activity_labels[,2])
> 
> #remove unnecessary variable
> remove(activity_labels)
> 
> ##Create a second, independent tidy data set with the average of each variable for each activity and each subject
> 
> #Replace first column with the means vector
> final_data$Measurement <- factor(final_data$Measurement, levels = final_data$Measurement, labels = means)
> 
> #Write an ouput file for the final data
> write.table(final_data, "output.txt", row.names = FALSE)
```

## Process

1. For both the test and train datasets, produce an interim dataset:
    1. Extract the mean and standard deviation features (listed in CodeBook.md, section 'Extracted Features'). This is the `values` table.
    2. Get the list of activities.
    3. Put the activity *labels* (not numbers) into the `values` table.
    4. Get the list of subjects.
    5. Put the subject IDs into the `values` table.
2. Join the test and train interim datasets.
3. Put each variable on its own row.
4. Rejoin the entire table, keying on subject/acitivity pairs, applying the mean function to each vector of values in each subject/activity pair. This is the clean dataset.
5. Write the clean dataset to disk.

## Cleaned Data

The resulting clean dataset is in this repository at: `data/output.txt`. It contains one row for each subject/activity pair and columns for subject, activity, and each feature that was a mean or standard deviation from the original dataset.

## Notes

X_* - feature values (one row of 561 features for a single activity)
Y_* - activity identifiers (for each row in X_*)
subject_* - subject identifiers for rows in X_*
