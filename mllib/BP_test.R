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
# Args[12]: parameter7=file_cols(default=40, the cloumn number of the input file)
# Args[13]: parameter8=bp_type(default="class")
# Args[14]: parameter9=output_file(default="BP_pred_result.csv")
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
cat("file_cols: ",Args[12],"\n")
cat("bp_type: ",Args[13],"\n")
cat("output_file: ",Args[14],"\n")



