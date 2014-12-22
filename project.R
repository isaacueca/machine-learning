# Import dependencies

library(caret)
library(kernlab)
library(randomForest)
library(corrplot)

# Read training data set
dataTrainingSource <- read.csv("pml-training.csv", na.strings= c("NA",""," "))
dataTestingSource <- read.csv("pml-testing.csv", na.strings= c("NA",""," "))

# Sanitize the data set by eliminating columns that are empty
dataTrainingSource[is.na(dataTrainingSource)] <- 0
emptyColumns <- apply(dataTrainingSource, 2, function(x) {sum(is.na(x))})
dataTraining <- dataTrainingSource[,which(emptyColumns == 0)]
# Remove redundant columns
dataTraining <- dataTraining[8:length(dataTraining)]

# Create training and testing sets via partition
dataPartition <- createDataPartition(y = dataTraining$classe, p = 0.7, list = FALSE)
trainingSet <- dataTraining[dataPartition, ]
testingSet <- dataTraining[-dataPartition, ]

# Apply Random Forest against our data to generate the model. Classe (quality) is the outcome and everything else in the data set will be the predictors.
model <- randomForest(classe ~ ., data = trainingSet)

# Validate the model against the testing set (cross-validation)
validateModel <- predict(model, testingSet)

# Get results of  cross validation
confusionMatrix(testingSet$classe, validateModel)

#Validate Model using the Testing Data Set
dataTestingSource[is.na(dataTestingSource)] <- 0
emptyColumnsForDataTesting <- apply(dataTestingSource, 2, function(x) {sum(is.na(x))})

dataTesting <- dataTestingSource[,which(emptyColumnsForDataTesting == 0)]
# Remove redundant columns
dataTesting <- dataTesting[8:length(dataTesting)]

# Apply the model to the Testing Set to predict how well the participants are performing its exercises
evaluateModel <- predict(model, dataTesting)