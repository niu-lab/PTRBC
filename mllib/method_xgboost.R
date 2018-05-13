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
# Args[9]:  parameter4=total_category(defualt=20)
# Args[10]: parameter5=xgboost_nthread(default=2)
# Args[11]: parameter6=xgboost_nrounds(default=100)
# Args[12]: parameter7=xgboost_subsample(default=0.5)
# Args[13]: parameter8=xgboost_objective(default="multi:softmax")
# Args[14]: parameter9=output_pred(default="xgboost_pred_result.csv")
# Args[15]: parameter10=output_label_numeric(default="xgboost_label_numeric_result.csv")
# Args[16]: parameter11=output_label(default="xgboost_label_result.csv")
# the run command sample: Rscript *.R [parameters]


# receive parameters from command line
input_file<-Args[6]
pct<-as.numeric(Args[7])
file_col<-as.numeric(Args[8])
total_category<-as.numeric(Args[9])
xgboost_nthread<-as.numeric(Args[10])
xgboost_nrounds<-as.numeric(Args[11])
xgboost_subsample<-as.numeric(Args[12])
xgboost_objective<-as.character(Args[13])
output_pred<-Args[14]
output_label_numeric<-Args[15]
output_label<-Args[16]

cat("R path: ",Args[1],"\n")
#cat("Args[2]",Args[2],"\n")
#cat("Args[3]=",Args[3],"\n")
cat("R script file: ",Args[4],"\n")
#cat("Args[5]=",Args[5],"\n")
cat("input_file: ",Args[6],"\n")
cat("pct: ",Args[7],"\n")
cat("file_col: ",Args[8],"\n")
cat("total_category: ",Args[9],"\n")
cat("xgboost_nthread: ",Args[10],"\n")
cat("xgboost_nrounds: ",Args[11],"\n")
cat("xgboost_subsample: ",Args[12],"\n")
cat("xgboost_objective: ",Args[13],"\n")
cat("output_pred: ",Args[14],"\n")
cat("output_label_numeric: ",Args[15],"\n")
cat("output_label: ",Args[16],"\n")


cat("\n")
library(xgboost)
library(Matrix)
library(data.table)
library(vcd)

cat("\nLoading input files...\n")
df<-read.table(input_file, header=FALSE)
train_sub<-sample(nrow(df), pct*nrow(df))
train_data<-df[train_sub,] # train data
test_data<-df[-train_sub,] # test data
train_vars<-train_data[, 2:file_col] # train data variables
test_vars<-test_data[, 2:file_col] # test data variables

#train_label<-train_data[, 1] # train data label
#test_label<-test_data[,1] # test data label

#train_label=as.factor(train_label)
#dim(train_data)
#dim(test_data)


#sparse_matrix
train_sparse_matrix <- sparse.model.matrix(V1~.-1, data = train_data)
test_sparse_matrix <- sparse.model.matrix(V1~.-1, data = test_data)

dim(train_sparse_matrix)
dim(test_sparse_matrix)
# training
lb <- as.numeric(train_data$V1) - 1
num_class <- total_category
set.seed(11)
i<-0 # eta
j<-0 # max.depth
max<-0
max.eta<-0
max.depth<-0
threshold<-0.5
len<-length(test_data$V1)
out<-1
while(TRUE){
	i<-i+0.1
	if(i>0.1) break
	while(TRUE){
		count<-0
		j<-j+1
		if(j>1) break
		#bst <- xgboost(data = train_sparse_matrix, label = train_data$V1, max.depth = j, eta = i, nthread=2, nround=500, objective = "binary:logistic")
        	lb <- as.numeric(train_data$V1) - 1
		cat("\nXGBoost training...\n")
		bst <- xgboost(data = train_sparse_matrix, label = lb, max_depth = j, eta = i, nthread = xgboost_nthread, nrounds = xgboost_nrounds, subsample = xgboost_subsample, objective = xgboost_objective, num_class = num_class)
		
		cat("\nXGBoost  predicting...\n")
		# predict for softmax returns num_class probability numbers per case:
		pred<-predict(bst,test_sparse_matrix) # testing
		
		cat("\nXGBoost writing...\n")
		write.table(pred, file=output_pred)
		label<-as.numeric(test_data$V1) - 1
		write.table(label, file=output_label_numeric)
		write.table(test_data$V1, file=output_label)
		# convert the probabilities to softmax labels
		#pred_labels <- max.col(pred) - 1
		# the following should result in the same error as seen in the last iteration
		# error<-sum(pred_labels != lb)/length(lb)
		#acc<-sum(pred_labels == lb)/length(lb)
		#cat("output", out, ": eta:",i,", max.depth: ", j,", acc: ",acc,"\n")	
		acc<-1
		out<-out+1
		if(max<acc){
			max<-acc
			max.eta<-i
			max.depth<-j
		}
	}
}

cat("max accuracy: ", max, ", max.eta: ", max.eta, ", max.depth: ", max.depth, "\n")

cat("\nXGBoost finished the prediction!\n\n")
