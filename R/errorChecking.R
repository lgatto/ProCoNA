
check_proconaNet <- function
### Check the validity of the procona object.
(object  ##<< The procona network object.
 ){

  errors <- character()

  sample_len <- length(samples(object))
  if(sample_len < 1) {
    msg <- paste("Number of samples is: ", sample_len, "\n", sep="")
    errors <- c(errors, msg)
  }

  pep_len <- length(peptides(object))
  if(pep_len < 1) {
    msg <- paste("Number of peptides is: ", pep_len, "\n", sep="")
    errors <- c(errors, msg)
  }
  
  tom_dim <- ncol(TOM(object))
  if(pep_len != tom_dim) {
    msg <- paste("TOM size is ", tom_dim, "while number of peptides is ", pep_len, "\n", sep="")
    errors <- c(errors, msg)
  }

  adj_dim <- ncol(adj(object))
  if(adj_dim!= tom_dim) {
    msg <- paste("TOM size is ", tom_dim, "while Adjacency size is: ", adj_dim, "\n", sep="")
    errors <- c(errors, msg)
  }

  merged_len <- length(mergedColors(object))
  if(pep_len != merged_len) {
    msg <- paste("The number of mergedColors does not match the number of peptides.\n", sep="")
    errors <- c(errors, msg)
  }


  dynamic_len <- length(dynamicColors(object))
  if(pep_len != dynamic_len) {
    msg <- paste("The number of dynamicColors does not match the number of peptides.\n", sep="")
    errors <- c(errors, msg)
  }

  if(merged_len != dynamic_len) {
    msg <- paste("The number of dynamicColors does not match the number of mergedColors.\n", sep="")
    errors <- c(errors, msg)
  }
  
  if(networkPower(object) < 1) {
    msg <- paste("The network power is: ", networkPower(object), ".\n", sep="")
    errors <- c(errors, msg)
  }

  mergedModules <- length(unique(mergedColors(object)))
  me <- mergedMEs(object)
  if(ncol(me) != mergedModules || nrow(me) != sample_len) {
    msg <- "The network module eigenvectors is not consistent with the number of samples and modules.\n"
    errors <- c(errors, msg)
  }
    
  if(length(errors) == 0)
    {TRUE}
  else
    {errors}
  ### Returns TRUE if no errors detected, and a character vector of errors otherwise.
}


#setValidity("proconaNet", check_proconaNet)



prebuild_check <- function
### check arguments before building a network
(args,  ##<< List of arguments to teh build network function.
 pepdat ){

  if(is.null(rownames(pepdat))) {
    stop("Peptide data must have named samples as rows in a matrix.")
  }
  if(is.null(colnames(pepdat))) {
   stop("Peptide data must have named peptides as columns in a matrix.")
  } 

  for (x in names(args)) {
      message("Checking ", x, "\n")
      switch(x,
             networkType = if (args$networkType != "signed" || args$networkType != "unsigned") {
                 stop("networkType is a character string: \"signed\" or \"unsigned\"")
             },
             pow = if (args$pow < 1) {
                 stop("power must be greater than 0.")
             },
             scaleFreeThreshold = if (args$scaleFreeThreshold < 0  || args$scaleFreeThreshold > 1) {
                 stop("Scale Free Threshold must be between 0 and 1.")
             },
             deepSplit = if (args$deepSplit < 1 || args$deepSplit > 4) {
                 stop("deepSplit can be 1,2,3,or 4.  Higher numbers enact greater splitting.")
             },
             mergeThreshold = if (args$mergeThreshold < 0  || args$mergeThreshold > 1) {
                 stop("Merge Threshold must be between 0 and 1.")
             },
             pamRespectsDendro = if (!(class(args$pamRespectsDendro) == "name" &&
                 (args$pamRespectsDendro == "T" || args$pamRespectsDendro == "F"))) {
                 stop("pamRespectsDendro must be logical. ?pamRespectsDendro")
             }
             )
  }     
  TRUE
}


