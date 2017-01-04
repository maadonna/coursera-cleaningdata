# Assignment for Getting and Cleaning Data
This repository is for the Coursera course Getting and Cleaning data.

The assignment took an existing set of text files, combined them into a single file, tidied them according to tidy data principles and created some summary statistics.

Details of the source data are here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The study was called "Human Activity Recognition Using Smartphones Data Set". The experiments was with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, they captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments were video-recorded to label the data manually. The obtained dataset was randomly partitioned into two sets, where 70% of the volunteers were selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which had gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

The original data is here, and contains a readme and other explanatory files: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

In the course assignment, we combined the following files into one:
* subject_test.txt (list of people for testing data)
* y_test.txt (activity file for testing data)
* X_test.txt (testing data outcomes)
* subject_train.txt (list of people for training data)
* y_train.txt (activity file for training data)
* X_train.txt (training data outcomes)

Also needed were:
* features.txt (list of variable names)
* activity_labels.txt" (list of activity names)

The assignment process combined the test and training data files, and added the subject and activity indicators. We then retained just variables to do with mean and standard deviation, replaced activity IDs with descriptions and added readable variable names.

With that tidy data frame, the final step was to calculate averages for each combination of subject and activity for each of the retained variables.
