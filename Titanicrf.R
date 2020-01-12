## Setting the working directory and loading the data
setwd('C:/Users/Admin/Documents/Dell E6320/R  Datasets')

## Loading required Libraries
library(caret)
library(e1071)
library(randomForest)

titanic.data <- read.csv('titanic1.csv', stringsAsFactors = F, header = T)
str(titanic.data)

## Categorical Casting
titanic.data$Survived <- as.factor(titanic.data$Survived)
titanic.data$Pclass <- as.factor(titanic.data$Pclass)
titanic.data$Sex <- as.factor(titanic.data$Sex)
titanic.data$Embarked <- as.factor(titanic.data$Embarked)

## We add a feature for total family size on board for each observation
titanic.data$Familysize <-1 + titanic.data$Parch + titanic.data$SibSp

## We engineer the data to retain the features we want
## we exclude name, ticket and cabin

titanic.data <- titanic.data[, c('Survived', 'Pclass', 'Sex', 'Age', 'SibSp', 'Parch', 'Fare', 'Embarked',  'Familysize')]


## Missing values
### Embarked
titanic.data[titanic.data$Embarked == "", ] # Two values are missing, we impute using the mode
table(titanic.data$Embarked) # S has the highest frequency 
titanic.data[titanic.data$Embarked == "", "Embarked"] <- "S"

### Age
table(is.na(titanic.data$Age)) # 177 missing

# we impute the missing ages with caret preprocess
dummy.vars <- dummyVars(~., data = titanic.data[-1]) # we exclude survived column from the imputation
train.dummy <- predict(dummy.vars, titanic.data[-1])

pre.process <- preProcess(train.dummy, method = 'bagImpute')
imputed.data <- predict(pre.process, train.dummy) # The missing ages have been imputed using bagimpute method

## We can now through back the imputed age into our titanic.data
titanic.data$Age <- imputed.data[,6]
table(is.na(titanic.data$Age)) # No missing values in age

## Spliting our data into train and test
set.seed(9876)
indexes <- createDataPartition(titanic.data$Survived,
                                     times = 1,
                                     p = 0.7,
                                     list = F) # createDataPartion ensures proportion in survived is maintained in the train and test sets

titanic.train <- titanic.data[indexes,]
titanic.test <- titanic.data[-indexes,]

## Building the model
model <- randomForest(Survived ~., 
                      data = titanic.train,
                      ntree = 23,
                      samplesize = 0.64 * nrow(titanic.test),
                      maxnodes = 54)
survived.pred <- predict(model, titanic.test)

## With our predicted survived, we can view the model performance

confusionMatrix(survived.pred, titanic.test$Survived) ## The model is 80% accurate, 90% sensitive and 70% specific. 

## Thanks
