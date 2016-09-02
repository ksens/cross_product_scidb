rm(list=ls())
library(scidb)
scidbconnect()
source('~/p4scratch/cross_product_scidb/functions.R')

size = c(2500, 250000, 640000, 1000000)
Rrestime = c()
Scidbrestime_mm = c()

for (i in 1:length(size)) 
{
  cat(sprintf("dim = %d\n", sqrt(size[i])))
  
  v <- as.scidb(matrix(rnorm(size[i]),sqrt(size[i])))
  #In R
  vR<-v[]
  vmat<-df_to_2dmat(vR)
  
  cat("Running the matrix multiplication in R:  \n")
  tic<-proc.time();
  Rres<-head(vmat%*%vmat);
  tR <- proc.time()-tic
  print(tR)
  Rrestime[[i]]<-tR
  
  #Using Scidb
  # run the product in SciDB, and time the result;
  prod = gemm(v, v)
  
  tic<-proc.time();
  iquery(sprintf("consume(%s)", prod@name), return=FALSE);
  tS<-proc.time()-tic
  # cat("Running the matrix multiplication in SciDB:  \n")
  # print(tS)
  Scidbrestime_mm[[i]]<-tS
}