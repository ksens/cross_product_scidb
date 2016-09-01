gemm = function(X, Y, Z)
{
  if(missing(Z))
  {
    Z = scidb(sprintf("build(<val:double> [x=%s:%s,%s,0, y=%s:%s,%s,0], 0)", 
                      scidb::scidb_coordinate_start(X)[1],
                      scidb::scidb_coordinate_end(X)[1],
                      scidb::scidb_coordinate_chunksize(X)[1],
                      scidb::scidb_coordinate_start(Y)[2],
                      scidb::scidb_coordinate_end(Y)[2],
                      scidb::scidb_coordinate_chunksize(Y)[2]
    ))
  }
  result = scidb(sprintf("gemm(%s, %s, %s)", X@name, Y@name, Z@name))
  return(result)
}

# Convert a data-frame with three columns into a matrix
# Column 1 has the matrix column name info
# Column 2 has the matrix row name info
# Column 3 has the matrix data
# ordered: is the dataframe already ordered 
df_to_2dmat <- function(df, ordered = TRUE)
{
  if (!ordered)
  {
    # Make sure the data frame is ordered exactly 
    df = df[with(df, order(df[,1], df[,2])), ]
  }
  
  ncols = length(unique(df[, 1]))
  nrows = length(unique(df[, 2]))
  mat = matrix(df[, 3], nrow=nrows, ncol=ncols)
  #dim(mat)  
  
  #### Formulate the rownames and verify
  rowlist = df[, 2]
  rnames = unique(rowlist)
  
  if (ordered) {
    # Verify
    check = all.equal(rep(rnames, ncols), rowlist)
    # print(check)
    stopifnot(check)
  }
  
  #### Formulate the rownames and verify
  collist = df[, 1]
  cnames = unique(collist)
  xx = unlist(lapply(cnames, function(x) {rep(x, nrows)}))
  
  if (ordered) {
    # Verify
    check = all.equal(xx, collist)
    # print(check)
    stopifnot(check)
  }
  
  # now paste the rownames and colnames to the matrix
  rownames(mat) = rnames
  colnames(mat) = cnames
  
  mat
}
