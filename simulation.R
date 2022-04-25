time_reprocessing <- 3.0
time_ordinary <- 1.0
nodes <- 128
limit_messages_per_second <- 100

in_degree <- 3.0

xval <- seq(from=100, to=1500, by=100)
expectation <- xval * (in_degree/nodes * time_reprocessing)

