##Merge the training and the test sets to create one data set.

#Read files

X_test <- read.table("test//X_test.txt", sep = "\t")
X_train <- read.table("train//X_train.txt", sep = "\t")
y_test <- read.table("test//y_test.txt", sep = "\t")
y_train <- read.table("train//y_train.txt", sep = "\t")
subject_test <- read.table("test//subject_test.txt", sep = "\t")
subject_train <- read.table("train//subject_train.txt", sep = "\t")

#Merge test and training sets with with rbind()
X_data <- rbind(X_test, X_train)
y_data <- rbind(y_test,y_train)
subject_data <- rbind(subject_test, subject_train)

#Merge the merged test and data sets into one final dataset with cbind()
initial_data <- cbind(X_data, y_data, subject_data)

#Create a new data set from the initial data to use as the final set
final_data <- initial_data

#Clean the variables no longer necessary
remove(X_test)
remove(X_train)
remove(y_test)
remove(y_train)
remove(subject_test)
remove(subject_train)
remove(X_data)
remove(y_data)
remove(subject_data)

##Extract mean and standard deviation for each measurement using strsplit().

#Create a vector for each wanted value

means <- c()
std_deviations <- c()

#Loop over column 1 to split measures, convert to numeric and get the means and std.deviations while ignoring NA values

for (entry in final_data[, 1]){
  means <- c(means, mean(na.omit(sapply(strsplit(entry, " "), as.numeric))))
  std_deviations <- c(std_deviations, sd(na.omit(sapply(strsplit(entry, " "), as.numeric))))
}

#remove unnecessary variable
remove(entry)


##Label the data set with descriptive variable names.
names(final_data) <- c("Measurement","Activity","Subject")

##Use descriptive activity names to replace the activities in the data set

#Load activity name data
activity_labels <- read.table("activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])

#Replace activity numbers with activity names
final_data$Activity <- factor(final_data$Activity, levels = activity_labels[,1], labels = activity_labels[,2])

#remove unnecessary variable
remove(activity_labels)

##Create a second, independent tidy data set with the average of each variable for each activity and each subject

#Replace first column with the means vector
final_data$Measurement <- factor(final_data$Measurement, levels = final_data$Measurement, labels = means)

#Write an ouput file for the final data
write.table(final_data, "output.txt", row.names = FALSE)
