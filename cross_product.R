library(scidb)
scidbconnect()

source('~/p4scratch/cross_product_scidb/functions.R')

# Upload a 2D matrix to SciDB
v1 <- as.scidb(matrix(rnorm(2500),50))

# run the product in SciDB, and download the result
mx = gemm(v1, v1)[]
# The result is a dataframe, so we need to formulate a matrix from it
mxmat = df_to_2dmat(mx)

##########
# Now let us run the multiplication in R
# Download the matrix as a dataframe
v = v1[]
# Convert from DF to matrix
vmat = df_to_2dmat(v)
m = vmat %*% vmat

# Now compare the results
all.equal(m, mxmat)