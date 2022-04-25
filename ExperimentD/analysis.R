library(ggplot2)
library(tidyverse)

folder <- "/home/mag/repos/mbei-experiments/ExperimentD"
csv_file <- paste(folder, "deltas.csv", sep="/")
deltas <- read_csv(csv_file)
deltas <- deltas %>% arrange(desc(microsecs)) 
summary(deltas)

deltas_excl <- deltas %>% filter(microsecs >= 2500)

deltas_incl <- deltas %>% filter(microsecs < 2500)
p <- ggplot(deltas_incl, aes(microsecs)) + 
  theme_bw() +
  stat_density(aes(y=..count..)) +
  scale_x_continuous(trans="log10")
p