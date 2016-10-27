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

######################################
# now on 2 matrices
v2 <- as.scidb(matrix(rnorm(2500),50))
mx2 = gemm(v1, v2)[]
mxmat2 = df_to_2dmat(mx2)

# Convert from DF to matrix
vmat1 = df_to_2dmat(v1[])
vmat2 = df_to_2dmat(v2[])
m2 = t(vmat1) %*% vmat2

# Now compare the results
all.equal(m2, mxmat2)
