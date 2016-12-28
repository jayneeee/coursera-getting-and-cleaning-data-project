
#install package if require
if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")

# Read data from files
activityLabel <- read.table('./activity_labels.txt')[,2] #imports activity_labels.txt
features  <- read.table('./features.txt')
feature_names <-  features[,2]

x_test <-  read.table('./test/x_test.txt')
y_test <- read.table('./test/y_test.txt')
subjectTest <- read.table('./test/subject_test.txt')


x_train <- read.table('./train/x_train.txt')
y_train <- read.table('./train/y_train.txt')
subjectTrain <- read.table('./train/subject_train.txt')

#Assign appropriate column name for dataset
colnames(x_test) <- feature_names;
colnames(x_train) <- feature_names;
colnames(subjectTest) = "subject_id"
colnames(subjectTest) = "subject_id"

# 1.
# Merge data X and data Y
testData <- cbind(as.data.table(subjectTest),y_test,x_test)
trainData <- cbind(as.data.table(subjectTrain),y_train,x_train)

# Merge test and train data
alldata = rbind(test_data, train_data)


# 2.
# Extract only the measurements on the mean and standard deviation for each measurement
extract_features <- grepl("mean|std", feature_names)
x_test = x_test[,extract_features]
x_train = x_train[,extract_features]


# 3.
# Use descriptive activity name to name the activities in the data set
y_test[,2] = activity_labels[y_test[,1]]
colnames(y_test) = c("activityID", "activityLabel")

#load activity data 
y_train[,2] = activity_labels[y_train[,1]]
colnames(y_train) = c("activityID", "activityLabel")

# 4. 
# create vector labels
columnLabels = c("subject", "activityID", "activityLabel")

# Melt the data with correct subject name
dataLabels = setdiff(colnames(alldata), id_labels)
meltData      = melt(alldata, id = columnLabels, measure.vars = dataLabels)


# 5.
# Create a second tidy data set
tidyData   = dcast(meltData,subject + activityID +  activityLabel ~ variable, mean)

write.table(tidyData, file = "./tidyData.txt")
