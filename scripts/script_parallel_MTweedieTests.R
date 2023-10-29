library(tweedie)
library(foreach)
library(doParallel)

simTweedieTest <- function(N){ 
  t.test(rtweedie(N, mu=10000, phi=100, power=1.9), mu=10000)$p.value 
} 

MTweedieTests <- function(N, M, sig) {
  cl <- makeCluster(detectCores())
  registerDoParallel(cl)
  
  # Load tweedie package on each worker in the cluster
  clusterEvalQ(cl, library(tweedie))
  
  # Export the simTweedieTest function to each worker
  clusterExport(cl, "simTweedieTest")
  
  p_values <- foreach(i = 1:M, .combine = c) %dopar% {
    simTweedieTest(N)
  }
  
  stopCluster(cl)
  sum(p_values < sig) / M 
}


df <- expand.grid(N = c(10,100,1000,5000, 10000), M = 1000, share_reject = NA)

for(i in 1:nrow(df)){ 
  df$share_reject[i] <- MTweedieTests(N=df$N[i], M=df$M[i], sig=.05) 
}
