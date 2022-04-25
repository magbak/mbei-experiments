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
csv_file <- paste(folder, "events.csv", sep="/")
events <- read_csv(csv_file)
events <- events %>% arrange(desc(microsecs)) 
summary(events)

p <- ggplot(events, aes(microsecs)) + 
  theme_bw() +
  stat_density(aes(y=..count..), color="black", fill="blue") +
  scale_x_continuous(trans="log10") +
  labs(x="Message processing time (microseconds)", y="Count") +
  theme(text = element_text(size = 14))
p

ggsave("events_plot.png", p, dpi=500, width =15, height=10, units="cm")

my_events_df <- as.data.frame(events$microsecs)
colnames(my_events_df) = c("Event processing")
stargazer(my_events_df)