Args<-commandArgs()
# 
# Args[1]-Args[5] cannot be used by users
# Args[6]=parameter1
# Args[7]=parameters2
#
# BP input necessary parameters are
# Args[6]:  parameter1=input_train_file
# Args[7]:
# Args[8]:  parameter2=pct(default=0.7)
# Args[9]:  parameter3=bp_size(default=12)
# Args[10]:  parameter4=bp_matrix_size(defualt=2000)
# Args[11]: parameter5=bp_decay(default=5e-6)
# Args[12]: parameter6=bp_range(default=0.1)
# Args[13]: parameter7=file_cols(default=40, the cloumn number of the input file)
# Args[14]: parameter8=bp_type(default="class")
# Args[15]: parameter9=output_file(default="BP_pred_result.csv")
#
# the run command sample: Rscript BP.R RBC_2class.xlsx 

# receive parameters from command line
input_train_file<-Args[6]
input_test_file<-Args[7]
pct<-Args[8]
bp_size<-Args[9]
bp_matrix_size<-Args[10]
bp_decay<-Args[11]
bp_range<-Args[12]
file_cols<-Args[13]
bp_type<-Args[14]
output_file<-Args[15]

library(DMwR)
library(nnet)

#rbc<-read.table('../data/Train_rbc.csv',header=FALSE)
#test<-read.table('../data/Test_rbc.csv',header=FALSE)
rbc<-read.table(input_train_file,header=FALSE)
rbc<-read.table(input_test_file,header=FALSE)

#nn<-nnet(V1~., rbc, size=12, matrix=2000, decay=5e-6, rang=0.1)
#pred_result <- predict(nn, test[,2:40],type="class")
#write.table(pred_result, file="BP_pred_result_size12.csv")

nn<-nnet(V1~., train, size=bp_size, matrix=bp_matrix_size, decay=bp_decay, rang=bp_decay)
pred_result <- predict(nn, test[,2:file_col],type=bp_type)

write.table(pred_result, file=output_file)



