##' Test of one pleiotrophic QTL vs two close linked QTLs.
##'
##' Test if multitriats are controlled by one pleiotrophic QTL or two
##' close linked QTLs. p-value is calculated from parametric
##' bootstrap, which takes the estimated parameters under null
##' hypothesis and generate data from them to get the null empirical
##' distribution of test statistic.
##'
##' @inheritParams scanone.mvn
##' @param region.l Left bound
##' @param region.r Right bound
##' @param int.method "bayes" or "1.5lod" method to calculated the
##' interval of interest if \code{region.l} and \code{region.r} is not
##' specified.
##' @param search.method Searching method for two-QTL model, "fast" or
##' "complete".
##' @param RandomStart Use random starting point for the two-QTL model
##' or not. default is \code{TRUE}.
##' @param RandomCut Use random cutting or not when there are traits
##' mapped to the same location. Default is \code{FALSE}, triats
##' mapped to the same location will be bound together.
##' @param simu.method "parametric" or "permutation" method for
##' simulations. Default is "parametric".
##' @param n.simu Number of simulations for p-value.
##' @param tol Tolerance value for the \code{qr} decomposition in
##' \code{lm} fitting.
##' @return a list.
##' \item{LOD1}{LOD score of one dimensional joint mapping.}
##' \item{LOD2}{LOD score for estimate of best two QTL model, each trait
##'             is influenced by the left or the right QTL.}
##' \item{LODdiff}{Difference of best one QTL model and best two QTL model,
##'                LODdiff = max(LOD2) - max(LOD1)}
##' \item{pvalue}{P-value from parametric bootstrap simulations.}
##' \item{Group}{Indicating which traits are influenced by which QTL
##' under alternative.}
##'
##' @examples
##' data(fake.phenos)
##' data(listeria)
##' listeria <- calc.genoprob(listeria, step=1)
##' obj <- testpleio.1vs2(cross=listeria, Y=fake.phenos, chr=1, n.simu=100,
##'                       region.l=60, region.r=90)
##' summary(obj)
##' plot(obj)
##'
##' @export
testpleio.1vs2 <- function(cross, Y, chr="6", addcovar=NULL, intcovar=NULL,
                           region.l=NA, region.r=NA,
                           method = c("ML", "Pillai", "Wilks", "Hotelling-Lawley", "Roy"),
                           int.method=c("bayes", "1.5lod"),
                           search.method=c("fast", "complete"), RandomStart=TRUE, RandomCut=FALSE,
                           simu.method=c("parametric", "permutation"), n.simu=1000, tol=1e-7){

  method <- match.arg(method)
  int.method <- match.arg(int.method)
  search.method <- match.arg(search.method)
  simu.method <- match.arg(simu.method)
  if(n.simu < 0) stop("n.simu should be a positive integer.")

  if(length(chr) > 1) stop("Please specify only one chromosome. ")
  n <- nrow(Y); p <- ncol(Y)
  if(int.method!="bayes" && int.method!="1.5lod")
      stop("int.method need to be 'bayes' or '1.5lod'. ")

  p1 <- ncol(cross$pheno)
  cross$pheno <- data.frame(cross$pheno, Y)
  out <- scanone(cross, pheno.col=p1+(1:p), method="hk", chr=chr,
                 addcovar=cbind(addcovar,intcovar), intcovar=intcovar)

  if(missing(region.l)|is.na(region.l)){
    int <- matrix(NA,p,3)
    if(int.method=="1.5lod"){
      for(i in 1:p){
        int[i,] <- lodint(out[,c(1:2,2+i)],chr=chr)$pos
      }
    }else{  ##  if(int.method=="bayes")
      for(i in 1:p){
        int[i,] <- bayesint(out[,c(1:2,2+i)],chr=chr)$pos
      }
    }
    region.l <- min(int)
    region.r <- max(int)
  }

  map.marker <- unlist(pull.map(cross, chr))
  map.marker <- map.marker[map.marker > region.l & map.marker < region.r]
  map.chr <- out$pos[out$chr==chr]
  if(sum(map.chr > region.l & map.chr < region.r)>0){
    rg <- range(which(map.chr > region.l & map.chr < region.r))
    marker.l <- rg[1]
    marker.r <- rg[2]
  }else{
    stop("confidence interval is too small.")
  }
  map.chr <- map.chr[marker.l:marker.r]

  ## ---- scan.mvn ----
  genoprob <- pull.genoprob(cross, chr=chr)
  if(attr(cross,"class")[1] == "bc"){
    ngeno <- 2
    genoprob <- pull.genoprob(cross, chr=chr)[,(2*marker.l-1):(2*marker.r)]
  }else{
    ngeno <- 3
    genoprob <- pull.genoprob(cross, chr=chr)[,(3*marker.l-2):(3*marker.r)]
  }

  maxPOSind <- apply(out[,-(1:2)],2,which.max) ## QTL position index
  o <- order(maxPOSind)

  x <- testpleio.1vs2.engine(Y=Y[, o], maxPOS=maxPOSind[o], genoprob=genoprob, ngeno=ngeno,
                             addcovar=addcovar, intcovar=intcovar,
                             method=method,
                             search.method=search.method, RandomStart=RandomStart,
                             RandomCut=RandomCut, tol=tol, in.simu=FALSE)
  LOD1 <- x$LOD1
  LOD2 <- x$LOD2
  LODdiff.trace <- x$LODdiff.trace
  E.marker <- matrix(NA, n, p)
  E.marker[,o] <- x$E.marker
  Group <- rep(2,p)   ## a vectior of length p, with 1,2 indicating grouped into right or left.
  Group[o[1:which.max(LODdiff.trace)]] <- 1
  LODdiff <- max(LODdiff.trace)
  attr(LODdiff,"LOD1lod") <- max(LOD1)  ## lod for the common QTL
  attr(LODdiff,"LOD1pos") <- map.chr[which.max(LOD1)]  ## pos for the common QTL
  attr(LODdiff,"LOD2lod") <- max(LOD2,na.rm=TRUE) ## lod for QTL1 and QTL2
  attr(LODdiff,"LOD2pos") <- map.chr[arrayInd(which.max(LOD2), .dim=dim(LOD2))] ## pos for QTL1 and QTL2

  maxPOS <- out$pos[apply(out[,-(1:2)],2,which.max)]  ## QTL position
  maxLOD <- apply(out[,-(1:2)],2,max)

  if(n.simu == 0){
    result <- list(LODdiff=LODdiff, Group=Group, chr=chr, map=map.chr,
                   maxPOS=maxPOS, maxLOD=maxLOD, LOD1=LOD1, LOD2=LOD2,
                   map.marker=map.marker,
                   LODdiff.trace=LODdiff.trace)
  }else{

    if(simu.method=="parametric"){    ## simulation: parametric bootstrap.

      Y.fit <- Y - E.marker
      Sigma <- cov(E.marker)
      Sigma.half <- chol(Sigma)

      LODdiff.simu <- numeric(n.simu)
      for(i.simu in 1:n.simu){
        mat <- matrix(rnorm(p*n),p,n)      ## p*n
        mat <- crossprod(mat,Sigma.half)   ## n*p
        Y.simu <- Y.fit + mat
        cross.simu <- cross
        cross.simu$pheno[, p1+(1:p)] <- Y.simu
        out <- scanone(cross.simu, pheno.col=p1+(1:p), method="hk", chr=chr,
                       addcovar=cbind(addcovar,intcovar), intcovar=intcovar)
        maxPOSind <- apply(out[,-(1:2)],2,which.max) ## QTL position index
        o <- order(maxPOSind)
        LODdiff.simu[i.simu] <- testpleio.1vs2.engine(Y=Y.simu[, o], maxPOS=maxPOSind[o],
                                                      genoprob=genoprob, ngeno=ngeno,
                                                      addcovar=addcovar, intcovar=intcovar,
                                                      method=method,
                                                      search.method=search.method,
                                                      RandomStart=RandomStart,
                                                      RandomCut=RandomCut, tol=tol,in.simu=TRUE)
      }
      pvalue <- mean(LODdiff.simu > LODdiff - tol)
      result <- list(LODdiff=LODdiff, Group=Group, chr=chr, map=map.chr,
                     maxPOS=maxPOS, maxLOD=maxLOD, LOD1=LOD1, LOD2=LOD2,
                     LODdiff.trace=LODdiff.trace,
                     map.marker=map.marker, n.simu=n.simu,
                     pvalue=pvalue)
    }else{ ##  simu.method=="permutation"
      ## find strat
      ind <- which.max(LOD1)
      strat <- numeric(n)
      if(ngeno == 3){
        prob <- genoprob[,(1:2)+3*(ind-1)]
        strat[prob[,1] > 0.5] <- 1
        strat[prob[,2] > 0.5] <- 2
        strat[1-prob[,1]-prob[,2] > 0.5] <- 3
      }else{
        prob <- genoprob[,2*ind-1]
        strat[prob > 0.5] <- 1
      }

      perm <- function(strat){
        n <- length(strat)
        o <- 1:n
        for(i in unique(strat)) o[strat==i] <- sample(o[strat==i],)
        o
      }

      LODdiff.simu <- numeric(n.simu)
      for(i.simu in 1:n.simu){
        os <- perm(strat)
        cross.simu <- cross[, os]
        genoprob.simu <- genoprob[os, ]
        cross.simu$pheno[, p1+(1:p)] <- Y
        out <- scanone(cross.simu, pheno.col=p1+(1:p), method="hk", chr=chr,
                       addcovar=cbind(addcovar,intcovar), intcovar=intcovar)
        maxPOSind <- apply(out[,-(1:2)],2,which.max) ## QTL position index
        o <- order(maxPOSind)
        LODdiff.simu[i.simu] <- testpleio.1vs2.engine(Y=Y[, o], maxPOS=maxPOSind[o],
                                                      genoprob=genoprob.simu, ngeno=ngeno,
                                                      addcovar=addcovar, intcovar=intcovar,
                                                      method=method,
                                                      search.method=search.method,
                                                      RandomStart=RandomStart,
                                                      RandomCut=RandomCut, tol=tol,in.simu=TRUE)
      }
      pvalue <- mean(LODdiff.simu > LODdiff - tol)
      result <- list(LODdiff=LODdiff, Group=Group, chr=chr, map=map.chr,
                     maxPOS=maxPOS, maxLOD=maxLOD, LOD1=LOD1, LOD2=LOD2,
                     LODdiff.trace=LODdiff.trace,
                     map.marker=map.marker, n.simu=n.simu,
                     pvalue=pvalue)
    }
  }
  class(result) <- c("testpleio.1vs2", "list")
  attr(result, "parameters") <- list(region.l=region.l, region.r=region.r,
                                     method=method,
                                     int.method=int.method,
                                     search.method=search.method,
                                     RandomStart=RandomStart,
                                     RandomCut=RandomCut,
                                     simu.method=simu.method)
  return(result)
}
