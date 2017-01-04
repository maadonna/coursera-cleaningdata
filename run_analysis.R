# Load libraries
library(dplyr)
library(tidyr)
library(stringr)
library(reshape2)

#0. Download and read in data
if (!file.exists("sourcefile.zip")) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "sourcefile.zip", method = "curl")
    unzip("sourcefile.zip")
    }
## features.txt has 2 cols, and some of the names are duplicates - bring in just second column and append number to duplicates
feature_names <- make.unique(unlist(read.table("UCI Har Dataset/features.txt", colClasses = c("NULL", "character"))))
activity_names <- read.table("UCI Har Dataset/activity_labels.txt")
test_who <- read.table("UCI Har Dataset/test/subject_test.txt")
test_what <- read.table("UCI Har Dataset/test/y_test.txt")
test_data <- read.table("UCI Har Dataset/test/X_test.txt", stringsAsFactors = FALSE)
train_who <- read.table("UCI Har Dataset/train/subject_train.txt")
train_what <- read.table("UCI Har Dataset/train/y_train.txt")
train_data <- read.table("UCI Har Dataset/train/X_train.txt", stringsAsFactors = FALSE)

#1.Merge the training and the test sets to create one data set
## combine test data
test_df <- cbind(test_who, test_what, test_data)
colnames(test_df)<- c("who", "what", feature_names)
# combine training data
train_df <- cbind(train_who, train_what, train_data)
colnames(train_df)<- c("who", "what", feature_names)
## combine and make it into a tibble in one step
starting_df <- tbl_df(rbind(test_df, train_df))

#2. Extract only the measurements on the mean and standard deviation for each measurement.
## There are three different kinds ov variables with mean in the name - the standard mean of the variable itself (these are
## always paired with a std; some variables that have a mean of the frequency components, and some special means for the 
## signal window sample. Without having a 'client' to query, I am going to assume that the question is asking for the 
## regular means - the ones for variables that have a standard set of calculations, including a std. These are all labelled
## mean(). Standard deviations are all labelled std(). 
## Need to get the first two columns as well
df_mean_sd <- select(starting_df, 1:2, matches("mean\\(\\)|std\\(\\)"))

#3. Uses descriptive activity names to name the activities in the data set
## use the activity_names data to replace the activity code
## first merge, which adds a column at the end
df_mean_sd <- merge(df_mean_sd, activity_names, by.x = "what", by.y = "V1")
## then get rid of the old column
df_mean_sd <- select(df_mean_sd, -what)
## reorder them so the activity is back as the second column
df_mean_sd <- select(df_mean_sd, who, V2, 2:67)
## and rename that column
df_mean_sd <-rename(df_mean_sd, what = V2)

#4. Appropriately labels the data set with descriptive variable names.
## I added the names as I created the master data frame, but they still need some tidying
nasty_names <- names(df_mean_sd)
nice_names <- gsub("[-()]", "", nasty_names)
names(df_mean_sd) <- nice_names

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## first make the who and what columns into factors
df_mean_sd$what <- as.factor(df_mean_sd$what)
df_mean_sd$who <- as.factor(df_mean_sd$who)
## then melt them into a super-long skinny data frame
df_melted <- melt(df_mean_sd, id = c("who", "what"))
## then cast it so it gives a single mean for each combination of who and what for each variable 
df_mean <- dcast(df_melted, who + what ~ variable, mean)

## testing to see if the same result comes out with ddply
df_mean_plyr <- ddply(df_melted, .(who, what, variable), summarize, average = mean(value))

write.table(df_mean, "tidy.txt", row.names = FALSE, quote = FALSE)
