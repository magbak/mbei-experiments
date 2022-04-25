library(ggplot2)

expA <- read_delim("/home/mag/repos/mbei-experiments/experimentA.csv")
expC <- read_delim("/home/mag/repos/mbei-experiments/experimentC.csv")

expA_mean <- expA %>% group_by(scenario, nodes) %>% summarize(final_rate=mean(final_rate)) %>% arrange(scenario, nodes) %>% ungroup()
expC_mean <- expC %>% group_by(scenario, nodes) %>% summarize(final_rate=mean(final_rate)) %>% arrange(scenario, nodes) %>% ungroup()

means <- expA_mean %>% inner_join(expC_mean, by=c("scenario", "nodes"), suffix=c(".A", ".C"))
means <- means %>% mutate(final_rate_ratio = final_rate.C/final_rate.A)
means_factors <- means %>% mutate(nodes=as_factor(nodes), scenario=as_factor(scenario))

t1<-theme(                              
  plot.background = element_blank(), 
  #panel.grid.major = element_blank(), 
  #panel.grid.minor = element_blank(), 
  strip.background = element_blank(),
  #panel.border = element_blank(), 
  panel.background = element_blank(),
  axis.line = element_line(size=.4),
)
p <- ggplot(means_factors, aes(nodes, final_rate_ratio)) + 
  theme_bw() +
  t1 + 
  geom_line(aes(group=scenario)) + 
  geom_point(aes(shape=scenario), size=4) +
  labs(x="Number of nodes in cluster", y="Mean max rate C / mean max rate A", shape="Scenario") +
  theme(text = element_text(size = 14)) +
  expand_limits(y=0)
p

ggsave("compareAC.png", p, dpi=500, width =15, height=10, units="cm")