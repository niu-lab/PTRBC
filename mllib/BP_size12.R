library(DMwR)
library(nnet)

rbc<-read.table('../data/Train_rbc.csv',header=FALSE)
test<-read.table('../data/Test_rbc.csv',header=FALSE)


nn<-nnet(V1~., rbc, size=12, matrix=2000, decay=5e-6, rang=0.1)
pred_result <- predict(nn, test[,2:40],type="class")
write.table(pred_result, file="BP_pred_result_size12.csv")


