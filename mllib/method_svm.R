Args<-commandArgs()
#
# Args[1]-Args[5] cannot be used by users
# Args[6]=parameter1
# Args[7]=parameters2
#
# BP input necessary parameters are
# Args[6]:  parameter1=input_file
# Args[7]:  parameter2=pct(default=0.9)
# Args[8]:  parameter3=svm_type(default=class)
# Args[9]:  parameter4=output_pred(default="SVM_pred_result.csv")
# Args[10]: parameter5=output_label(default="SVM_pred_result.csv")
# the run command sample: Rscript *.R [parameters]

# receive parameters from command line
input_file<-Args[6]
pct<-as.numeric(Args[7])
svm_type<-as.character(Args[8])
output_pred<-Args[9]
output_label<-Args[10]

cat("R path: ",Args[1],"\n")
#cat("Args[2]",Args[2],"\n")
#cat("Args[3]=",Args[3],"\n")
cat("R script file: ",Args[4],"\n")
#cat("Args[5]=",Args[5],"\n")
cat("input_file: ",Args[6],"\n")
cat("pct: ",Args[7],"\n")
cat("svm_type: ",Args[8],"\n")
cat("output_pred: ",Args[9],"\n")
cat("output_label: ",Args[10],"\n")

cat("\n")
library(e1071)
set.seed(1234)

cat("\nLoading input files...\n")
df<-read.table(input_file, header=FALSE)
train_sub<-sample(nrow(df), pct*nrow(df))
train_data<-df[train_sub,] # train data
test_data<-df[-train_sub,] # test data

train<-train_data
test<-test_data

cat("\nSVM training...\n")
#svm<-svm(train[,2:40],train[,1],type="C-classification",cost=10,kernel="radial",probability=TRUE,scale=FALSE)
svm<-svm(V1~.,data=train)

cat("\nSVM predicting...\n")
pred<-predict(svm,test, type=svm_type)

cat("\nSVM fusion matrix:\n")
table(pred,test$V1)

cat("\nCompute the accuracy for SVM model:\n")
table<-table(pred,test$V1)
sum(diag(prop.table(table)))

cat("\nSVM writing...\n")
write.table(pred, file=output_pred)
write.table(test$V1, file=output_label)
cat("\nSVM finished the prediction!\n\n")

