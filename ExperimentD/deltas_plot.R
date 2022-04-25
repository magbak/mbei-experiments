deps <- c("stargazer", "tidyverse")
packs <- installed.packages()
warnings()
for (d in deps) {
  if (!(d %in% packs[,"Package"])) {
    install.packages(d)
  }
}

library(ggplot2)
library(tidyverse)
library(stargazer)

folder <- "/home/mag/repos/mbei-experiments/ExperimentD"
csv_file <- paste(folder, "deltas.csv", sep="/")
deltas <- read_csv(csv_file)
deltas <- deltas %>% arrange(desc(microsecs)) 
summary(deltas)

p <- ggplot(deltas, aes(microsecs)) + 
  theme_bw() +
  stat_density(aes(y=..count..), color="black", fill="blue") +
  scale_x_continuous(trans="log10") +
  labs(x="Message processing time (microseconds)", y="Count") +
  theme(text = element_text(size = 14))
p

ggsave("deltas_plot.png", p, dpi=500, width =15, height=10, units="cm")

my_deltas_df <- as.data.frame(deltas$microsecs)
colnames(my_deltas_df) = c("Delta processing")
stargazer(my_deltas_df)

