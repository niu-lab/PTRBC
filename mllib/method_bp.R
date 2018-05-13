Args<-commandArgs()
# 
# Args[1]-Args[5] cannot be used by users
# Args[6]=parameter1
# Args[7]=parameters2
#
# BP input necessary parameters are
# Args[6]:  parameter1=input_file
# Args[7]:  parameter2=pct(default=0.9)
# Args[8]:  parameter3=bp_size(default=12)
# Args[9]:  parameter4=bp_matrix_size(defualt=100)
# Args[10]: parameter5=bp_decay(default=0.01)
# Args[11]: parameter6=bp_range(default=0.1)
# Args[12]: parameter7=file_col(default=40, the cloumn number of the input file)
# Args[13]: parameter8=bp_type(default="class")
# Args[14]: parameter9=output_pred(default="BP_pred_result.csv")
# Args[15]: parameter10=output_label(default="BP_label_result.csv")
# the run command sample: Rscript BP.R RBC_2class.xlsx 

# receive parameters from command line
input_file<-Args[6]
pct<-as.numeric(Args[7])
bp_size<-as.numeric(Args[8])
bp_matrix_size<-as.numeric(Args[9])
bp_decay<-as.numeric(Args[10])
bp_range<-as.numeric(Args[11])
file_col<-as.numeric(Args[12])
bp_type<-as.character(Args[13])
output_pred<-Args[14]
output_label<-Args[15]

cat("R path: ",Args[1],"\n")
#cat("Args[2]",Args[2],"\n")
#cat("Args[3]=",Args[3],"\n")
cat("R script file: ",Args[4],"\n")
#cat("Args[5]=",Args[5],"\n")
cat("input_file: ",Args[6],"\n")
cat("pct: ",Args[7],"\n")
cat("bp_size: ",Args[8],"\n")
cat("bp_matrix_size: ",Args[9],"\n")
cat("bp_decay: ",Args[10],"\n")
cat("bp_range: ",Args[11],"\n")
cat("file_col: ",Args[12],"\n")
cat("bp_type: ",Args[13],"\n")
cat("output_pred: ",Args[14],"\n")
cat("output_label: ",Args[15],"\n")

cat("\n")
library(DMwR)
library(nnet)
set.seed(2)

cat("\nLoading input files...\n")
df1<-read.table(input_file, header=FALSE)
df<-na.omit(df1)

#rbc<-read.table(input_train_file,header=FALSE)
#test<-read.table(input_test_file,header=FALSE)
train_sub<-sample(nrow(df), pct*nrow(df))
train_data<-df[train_sub,] # train data
test_data<-df[-train_sub,] # test data

train<-train_data
test<-test_data

cat("\nBP training...\n")
#nn<-nnet(V1~., rbc, size=bp_size, matrix=bp_matrix_size, decay=bp_decay, rang=bp_range)
nn<-nnet(V1~., data=train, linout=F, size=bp_size, matrix=bp_matrix_size, decay=bp_decay, rang=bp_range, trace=F)

cat("\nBP predicting...\n")
#pred_result <- predict(nn, test[,2:file_col],type="class")
pred_result=predict(nn, test, type=bp_type)


cat("\nBP fusion matrix:\n")
#head(pred_result)
table(pred_result,test$V1)
out<-table(pred_result,test$V1)
sum(diag(prop.table(out)))

cat("\nBP writing...\n")
write.table(pred_result, file=output_pred)
write.table(test$V1, file=output_label)
cat("\nBP finished the prediction!\n\n")


