library(tweedie)
library(foreach)
library(doParallel)

simTweedieTest <- function(N){ 
  t.test(rtweedie(N, mu=10000, phi=100, power=1.9), mu=10000)$p.value 
} 

MTweedieTests <- function(N,M,sig){ 
  sum(replicate(M, simTweedieTest(N)) < sig)/M 
} 

df <- expand.grid(N = c(10,100,1000,5000, 10000), M = 1000, share_reject = NA)

# Parallel execution
cl <- makeCluster(detectCores())
registerDoParallel(cl)

# Load tweedie package on each worker in the cluster
clusterEvalQ(cl, library(tweedie))

df$share_reject <- foreach(i=1:nrow(df), .combine=c) %dopar% {
  MTweedieTests(N=df$N[i], M=df$M[i], sig=.05)
}

stopCluster(cl)

