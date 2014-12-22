---
title: "Machine Learning Project"
author: "Isaac da Silva"
date: "Sunday, December 21, 2014"
output:
  html_document:
    theme: spacelab
---
# Summary

The objetive of the present project was to use data from accelerometers placed on the belt, forearm, arm, and dumbell of six participants in order to evaluate how well the partipants performed exercises.

### Loading and preprocessing the data
Two csv files were provided, which contained the training and test data sets. The data came from this source: http://groupware.les.inf.puc-rio.br/har. The data files were downloaded into the project's local directory and then loaded into R.


```r
dataTrainingSource <- read.csv("pml-training.csv", na.strings= c("NA",""," "))
dataTestingSource <- read.csv("pml-testing.csv", na.strings= c("NA",""," "))
```

The original data source contained a lot of empty and redundant columns. Those got removed in the sanitization process of cleaning the data and preparing it for analysis. 


```r
# Sanitize the data set by eliminating columns that are empty
emptyColumns <- apply(dataTrainingSource, 2, function(x) {sum(is.na(x))})
dataTraining <- dataTrainingSource[,which(emptyColumns == 0)]
# Remove redundant columns
dataTraining <- dataTraining[8:length(dataTraining)]
```

### Creating the Training and Testing data sets
The original data source was then partioned between training and testing data sets. 70% of the original data source was allocated to training the data and 30% to testing/validate it.


```r
# Create training and testing sets via partition
dataPartition <- createDataPartition(y = dataTraining$classe, p = 0.7, list = FALSE)
trainingSet <- dataTraining[dataPartition, ]
testingSet <- dataTraining[-dataPartition, ]
```

### Creating the Model

A random forest model was choosen to be used against the data set because the model is very accurate and efficient against large data sets. 

Random Forests algorithm is a classifier based on primarily two methods - bagging and random subspace method. 


```r
# Apply Random Forest against our data to generate the model. Classe (quality) is the outcome and everything else in the data set will be the predictors.
model <- randomForest(classe ~ ., data = trainingSet)
model
```

```
## 
## Call:
##  randomForest(formula = classe ~ ., data = trainingSet) 
##                Type of random forest: classification
##                      Number of trees: 500
## No. of variables tried at each split: 10
## 
##         OOB estimate of  error rate: 0.63%
## Confusion matrix:
##      A    B    C    D    E class.error
## A 3902    4    0    0    0 0.001024066
## B   17 2636    5    0    0 0.008276900
## C    0   21 2374    1    0 0.009181970
## D    0    0   33 2218    1 0.015097691
## E    0    0    1    3 2521 0.001584158
```

The out-of-bag (oob) error estimate that was obtained from the model was considered satisfactory.

### Model Evaluation

In order to further test its accuracy, the model was applied against the remaining 30% of the original data set. 
After that, a confusion matrix was used in order to evaluate the precision of the model.


```r
# Validate the model against the testing set (cross-validation)
validateModel <- predict(model, testingSet)

# Get results of  cross validation
confusionMatrix(testingSet$classe, validateModel)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1673    1    0    0    0
##          B   12 1127    0    0    0
##          C    0    9 1017    0    0
##          D    0    0   16  946    2
##          E    0    0    2    1 1079
## 
## Overall Statistics
##                                           
##                Accuracy : 0.9927          
##                  95% CI : (0.9902, 0.9947)
##     No Information Rate : 0.2863          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.9908          
##  Mcnemar's Test P-Value : NA              
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9929   0.9912   0.9826   0.9989   0.9981
## Specificity            0.9998   0.9975   0.9981   0.9964   0.9994
## Pos Pred Value         0.9994   0.9895   0.9912   0.9813   0.9972
## Neg Pred Value         0.9972   0.9979   0.9963   0.9998   0.9996
## Prevalence             0.2863   0.1932   0.1759   0.1609   0.1837
## Detection Rate         0.2843   0.1915   0.1728   0.1607   0.1833
## Detection Prevalence   0.2845   0.1935   0.1743   0.1638   0.1839
## Balanced Accuracy      0.9963   0.9943   0.9904   0.9976   0.9988
```

The model yielded over 99% of prediction accuracy, which proved that it could be confidently used to predict other data sets.

### Predictions

The model was then applied against the 20 test cases present in the testing data set that was imported previously, in order to evaluate how well each of these 20 participants was performing its exercises. 


```r
#Validate Model using the Testing Data Set
emptyColumnsForDataTesting <- apply(dataTestingSource, 2, function(x) {sum(is.na(x))})

dataTesting <- dataTestingSource[,which(emptyColumnsForDataTesting == 0)]
# Remove redundant columns
dataTesting <- dataTesting[8:length(dataTesting)]

# Apply the model to the Testing Set
evaluateModel <- predict(model, dataTesting)
evaluateModel
```

```
##  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
##  B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 
## Levels: A B C D E
```

### Conclusion

The random forrest model that we applied to the data proved to be a very reliable method to properly predict how well a person could be performing its exercises.
