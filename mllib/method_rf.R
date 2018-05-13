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
# Args[9]:  parameter4=rf_type(defualt="response")
# Args[10]: parameter5=rf_step_size(default=10)
# Args[11]: parameter6=rf_max_trees(default=20)
# Args[12]: parameter7=output_pred(default="RF_pred_result.csv")
# Args[13]: parameter8=output_label(default="RF_label_result.csv")
## Args[14]: parameter9=output_imp_rank(default="RF_varPlot.pdf")
# the run command sample: Rscript *.R [parameters]

# receive parameters from command line
input_file<-Args[6]
pct<-as.numeric(Args[7])
file_col<-as.numeric(Args[8])
rf_type<-as.character(Args[9])
rf_step_size<-as.numeric(Args[10])
rf_max_trees<-as.numeric(Args[11])
output_pred<-Args[12]
output_label<-Args[13]
#output_imp_rank<-Args[14]

cat("R path: ",Args[1],"\n")
#cat("Args[2]",Args[2],"\n")
#cat("Args[3]",Args[3],"\n")
cat("R script file: ",Args[4],"\n")
#cat("Args[5]=",Args[5],"\n")
cat("input_file: ",Args[6],"\n")
cat("pct: ",Args[7],"\n")
cat("file_col: ",Args[8],"\n")
cat("rf_type: ",Args[9],"\n")
cat("rf_step_size: ",Args[10],"\n")
cat("rf_max_trees: ",Args[11],"\n")
cat("output_pred: ",Args[12],"\n")
cat("output_label: ",Args[13],"\n")
#cat("output_imp_rank: ",Args[14],"\n")

cat("\n")
library(randomForest)

cat("\nLoading input files...\n")
df<-read.table(input_file, header=FALSE)
train_sub<-sample(nrow(df), pct*nrow(df))
train_data<-df[train_sub,] # train data
test_data<-df[-train_sub,] # test data

train<-train_data
test<-test_data
nt<-0
max_acc<-0
max_nt<-0
max_rf<-0
cat("\nRF training...\n")
while(TRUE){
	nt<-nt+rf_step_size
	if(nt>rf_max_trees) break
	rbc.rf<-randomForest(V1~., data=train,ntree=nt,importance=TRUE)
	pred_result<-predict(rbc.rf, test[2:file_col],type=rf_type)
	out<-table(pred_result,test[,1])
	accuracy<-sum(diag(out))/sum(out)
	if(max_acc<accuracy){
		max_acc<-accuracy
		max_nt<-nt
		max_rf<-rbc.rf
	}
			
}

cat("\nOutput the optimal parameters of RF model:\n")
cat("max_accuracy: ", accuracy, "max_ntree: ", max_nt, "\n")

cat("\nRF predicting...\n")
pred_result<-predict(max_rf, test[2:file_col],type=rf_type)

cat("\nRF writing...\n")
write.table(pred_result, file=output_pred)
write.table(test[,1], file=output_label)

cat("\nCompute the rank of importance for variables...\n")
imp<-importance(max_rf)
impvar<-imp[order(imp[,3],decreasing=TRUE),]; impvar

#cat("\nPlot the rank of importance for variables...\n")
#pdf(output_imp_rank)
#varImpPlot(rbc.rf)
#dev.off()

cat("\nRF finished the prediction!\n\n")
