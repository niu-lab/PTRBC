Args<-commandArgs()
# 
# Args[1]-Args[5] cannot be used by users
# Args[6]=parameter1
# Args[7]=parameters2
#
# BP input necessary parameters are
# Args[6]:  parameter1=input_train_file
# Args[7]:  parameter2=input_test_file
## Args[8]:  parameter2=pct(default=0.7)
# Args[8]:  parameter3=bp_size(default=12)
# Args[9]:  parameter4=bp_matrix_size(defualt=2000)
# Args[10]: parameter5=bp_decay(default=5e-6)
# Args[11]: parameter6=bp_range(default=0.1)
# Args[12]: parameter7=file_col(default=40, the cloumn number of the input file)
# Args[13]: parameter8=bp_type(default="class")
# Args[14]: parameter9=output_file(default="BP_pred_result.csv")
#
# the run command sample: Rscript BP.R RBC_2class.xlsx 

# receive parameters from command line
input_train_file<-Args[6]
input_test_file<-Args[7]
#pct<-Args[8]
bp_size<-as.numeric(Args[8])
bp_matrix_size<-as.numeric(Args[9])
bp_decay<-as.numeric(Args[10])
bp_range<-as.numeric(Args[11])
file_col<-as.numeric(Args[12])
bp_type<-as.character(Args[13])
output_file<-Args[14]

cat("R path: ",Args[1],"\n")
#cat("Args[2]",Args[2],"\n")
#cat("Args[3]=",Args[3],"\n")
cat("R script file: ",Args[4],"\n")
#cat("Args[5]=",Args[5],"\n")
cat("input_train_file: ",Args[6],"\n")
cat("input_test_file: ",Args[7],"\n")
cat("bp_size: ",Args[8],"\n")
cat("bp_matrix_size: ",Args[9],"\n")
cat("bp_decay: ",Args[10],"\n")
cat("bp_range: ",Args[11],"\n")
cat("file_col: ",Args[12],"\n")
cat("bp_type: ",Args[13],"\n")
cat("output_file: ",Args[14],"\n")

cat("\n")
library(DMwR)
library(nnet)

#rbc<-read.table('../data/Train_rbc.csv',header=FALSE)
#test<-read.table('../data/Test_rbc.csv',header=FALSE)
cat("\nLoading training and testing files...\n")
rbc<-read.table(input_train_file,header=FALSE)
test<-read.table(input_test_file,header=FALSE)
cat("\nTraining data sample:\n")
#head(rbc)
cat("\nTesting data sample:\n")
#head(test)
#nn<-nnet(V1~., rbc, size=12, matrix=2000, decay=5e-6, rang=0.1)
#pred_result <- predict(nn, test[,2:40],type="class")
#write.table(pred_result, file="BP_pred_result_size12.csv")
cat("\nBP training...\n")
nn<-nnet(V1~., rbc, size=bp_size, matrix=bp_matrix_size, decay=bp_decay, rang=bp_range)
#nn<-nnet(V1~., rbc, size=12, matrix=2000, decay=5e-6, rang=0.1)

cat("\nBP predicting...\n")
pred_result <- predict(nn, test[,2:file_col],type="class")
cat("\nBP writing...\n")
write.table(pred_result, file=output_file)
cat("\nBP finished the prediction!\n\n")


