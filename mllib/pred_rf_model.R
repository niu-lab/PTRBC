Args<-commandArgs()
#
# Args[1]-Args[5] cannot be used by users
# Args[6]=parameter1
# Args[7]=parameters2
#

# receive parameters from command line
input_file<-Args[6]
output_pred<-as.character(Args[7])

# screen output
cat("R path: ",Args[1],"\n")
#cat("Args[2]",Args[2],"\n")
#cat("Args[3]",Args[3],"\n")
cat("R script file: ",Args[4],"\n")
#cat("Args[5]=",Args[5],"\n")
cat("input_file: ",Args[6],"\n")
if(is.na(output_pred)) 
{
	output_pred<-as.character("data/rf_predict_output.xlsx")
	cat("Default output file is: ",output_pred,"\n")
}else{
	cat("Your output file is: ",output_pred,"\n")	
}
cat("\n")
library(randomForest)
load("RF.model")

cat("\nLoading input files...\n")
user_input<-read.table(input_file, header=FALSE)

cat("\nRF predicting...\n")
user_input$pred_result<-predict(rf_model, user_input[2:40],type="response")
head(user_input$pred_result)

cat("\nRF output writing...\n")
write.table(user_input,file=output_pred, quote=FALSE, sep="\t", row.names=FALSE, col.names=FALSE, )

cat("\nCompute the accuracy of this prediction...\n")
out<-table(user_input$pred_result,user_input[,1])
accuracy<-sum(diag(out))/sum(out)
cat("Accuracy: ", accuracy*100, "%\n")

cat("\nRF finished the prediction!\n\n")

