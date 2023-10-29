library(tictoc)

# Timing original script
tic("Original Script")
source("scripts/script_original.R")
toc()

# Timing parallel loop script
tic("Parallel Loop Script")
source("scripts/script_parallel_loop.R")
toc()

# Timing parallel MTweedieTests script
tic("Parallel MTweedieTests Script")
source("scripts/script_parallel_MTweedieTests.R")
toc()

# Comment on the results:
# Based on the timings:
# - The Original Script took 25.54 seconds.
# - The Parallel Loop Script (parallelizing the final loop) took 18.5 seconds.
# - The Parallel MTweedieTests Script (parallelizing the M simulations within the MTweedieTests function) took 13.91 seconds.

# From these timings, it's evident that the Parallel MTweedieTests Script is the fastest method.
# Possible reasons for this:
# 1. Fine-Grained Parallelism: By parallelizing the M simulations within the MTweedieTests function,
#    the task is divided into finer pieces, allowing for a more efficient distribution of work across the available cores.
# 2. Lower Overhead: While parallelizing the final loop introduces overhead due to the coordination of 
#    multiple parallel processes for each row of the dataframe, parallelizing within MTweedieTests spreads 
#    this overhead across a larger number of tasks.
# 3. Data Transfer: In the Parallel MTweedieTests method, each core performs the simulation independently, 
#    reducing the need for data transfer between cores compared to the Parallel Loop Script.
