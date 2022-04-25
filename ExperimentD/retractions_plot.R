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

folder <- "/home/mag/repos/mbei-experiments/ExperimentD"
csv_file <- paste(folder, "retractions.csv", sep="/")
retractions <- read_csv(csv_file)
retractions <- retractions %>% arrange(desc(microsecs)) 
summary(retractions)

p <- ggplot(retractions, aes(microsecs)) + 
  theme_bw() +
  stat_density(aes(y=..count..), color="black", fill="blue") +
  scale_x_continuous(trans="log10") +
  labs(x="Message processing time (microseconds)", y="Count") +
  theme(text = element_text(size = 14))
p

ggsave("retractions_plot.png", p, dpi=500, width =15, height=10, units="cm")

my_retractions_df <- as.data.frame(retractions$microsecs)
colnames(my_retractions_df) = c("Retraction processing")
stargazer(my_retractions_df)