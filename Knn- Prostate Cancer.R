pcc<-read.csv("Prostate_Cancer.csv", header = T)
head(pcc)
pcc<-pcc[-1]
str(pcc$diagnosis_result)
normalize<-function(x){
  return((x-min(x))/(max(x)-min(x)))
}
pcc_n<-as.data.frame(lapply(pcc[2:9], normalize))

# Creating the training and test datasets
pcc_train<-pcc_n[1:70,]
pcc_test<-pcc_n[71:100,]

# Training and test Labels
pcc_train_labels<-pcc[1:70,1]
pcc_test_labels<-pcc[71:100,1]

# The training model
library(class)
pcc_train_pred<-knn(pcc_train,pcc_test, cl=pcc_train_labels,k=10)

# Checking the Model performance
library(gmodels)
CrossTable(pcc_test_labels, pcc_train_pred, prop.chisq = F )
