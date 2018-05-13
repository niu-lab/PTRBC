Args<-commandArgs()
#
# Args[1]-Args[5] cannot be used by users
# Args[6]=parameter1
# Args[7]=parameters2
#
# XGBoost input necessary parameters are
# Args[6]:  parameter1=input_file
# Args[7]:  parameter2=pct(default=0.9)
# Args[8]:  parameter3=file_col(default=40, the cloumn number of the input file)
# Args[9]:  parameter4=knn_K(defualt=10)
# Args[10]: parameter5=output_pred(default="KNN_pred_result.csv")
# Args[11]: parameter6=output_label(default="KNN_label_result.csv")
# the run command sample: Rscript *.R [parameters]

# receive parameters from command line
input_file<-Args[6]
pct<-as.numeric(Args[7])
file_col<-as.numeric(Args[8])
knn_K<-as.numeric(Args[9])
output_pred<-Args[10]
output_label<-Args[11]

cat("R path: ",Args[1],"\n")
#cat("Args[2]",Args[2],"\n")
#cat("Args[3]",Args[3],"\n")
cat("R script file: ",Args[4],"\n")
#cat("Args[5]=",Args[5],"\n")
cat("input_file: ",Args[6],"\n")
cat("pct: ",Args[7],"\n")
cat("file_col: ",Args[8],"\n")
cat("knn_K: ",Args[9],"\n")
cat("output_pred: ",Args[10],"\n")
cat("output_label: ",Args[11],"\n")

cat("\n")
library(class)
library(gmodels)

cat("\nLoading input files...\n")
df<-read.table(input_file,header=FALSE)
train_sub<-sample(nrow(df), pct*nrow(df))
train_data<-df[train_sub,] # train data
test_data<-df[-train_sub,] # test data

train<-train_data
test<-test_data

cat("\nKNN training and predicting...\n")
#pre_result<-knn(train=rbc[,2:40],test=test[,2:40],cl=rbc[,1],k=300)
pre_result<-knn(train=train[,2:file_col],test=test[,2:file_col],cl=train[,1],k=knn_K)
cat("\nKNN fusion matrix:\n")
out<-table(pre_result,test[,1])
out
cat("\nCompute the accuracy for KNN model:\n")
accuracy<-sum(diag(out))/sum(out)
cat("max_accuracy: ", accuracy, "\n")

cat("\nKNN writing...\n")
write.table(pre_result, file=output_pred)
write.table(test$V1, file=output_label)

cat("\nKNN finished the prediction!\n\n")
