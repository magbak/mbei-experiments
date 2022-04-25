deps <- c("tidyverse")
packs <- installed.packages()

for (d in deps) {
  if (!(d %in% packs[,"Package"])) {
    install.packages(d)
  }
}
library(tidyverse)

folder <- "/home/mag/repos/mbei-experiments/ExperimentA_12_rerun"
directories <- list.dirs(path=folder)
directories <- as_tibble_col(directories) %>% filter(str_detect(directories, "output-folder"))
my_list <- list()
for (d in directories$value) {
  run <- str_match(d, regex("output-folder-(.*)", dotall=TRUE))[2]
  print(run)
  producers <- list.files(path = d, pattern = "producer*", recursive = FALSE)
  for (p in producers) {
    producer_strings <- read_csv(paste0(d, "/", p),col_names = c("txt"), show_col_types = FALSE)
    actual_rates <- producer_strings %>% filter(str_detect(txt, "had actual rate"))
    #We use the next to last actual rate
    final_rate <- actual_rates[nrow(actual_rates)-1,"txt"]
    final_rate <- str_match(final_rate, "actual rate ([0-9]+.[0-9]+) messages")[2]
    
    p_match <- str_match(p, "([0-9]+)-([0-9]+)-producer*")
    nodes <- p_match[2]
    scenario <- p_match[3]
    my_list <- append(my_list, list(list(final_rate=final_rate, run=run, nodes=nodes, scenario=scenario)))
  }  
}

tbl <- tibble(my_list)
tbl <- tbl %>% unnest_wider("my_list")
tbl <- tbl %>% mutate(final_rate=as.numeric(final_rate),
                      scenario=as.numeric(scenario),
                      nodes=as.numeric(nodes))
tbl_scenario_factors <- tbl %>% arrange(scenario, nodes) %>% mutate(scenario=as_factor(scenario))
tbl_factors <- tbl_scenario_factors %>% mutate(nodes=as_factor(nodes))

tbl_ideal_slope <- tbl_factors %>% group_by(scenario) %>% filter(nodes=="3") %>% summarize(ideal_slope=mean(final_rate/3))
scenario_size_labels <- as_labeller(c(
  '4'="Scenario size 4",
  '8'="Scenario size 8",
  '16'="Scenario size 16",
  '32'="Scenario size 32"
))

library(ggplot2)
p <- ggplot(tbl_factors, aes(scenario, final_rate)) + 
  geom_boxplot() + 
  #geom_segment(data=tbl_ideal_slope, mapping=aes(x="12", y=ideal_slope*12, xend="12", yend=ideal_slope*12)) + 
  stat_boxplot(geom = 'errorbar', width=0.2) + 
  #facet_wrap(vars(scenario), labeller=scenario_size_labels) +
  labs(x="Scenario size", y="Maximum message rate") +
  theme(text = element_text(size = 20)) +
  expand_limits(y=0)
p

ggsave("experimentA_12_rerun.png", p, dpi=500, width =20, height=20, units="cm")

#tbl_models <- tbl_scenario_factors %>% group_by(scenario) %>% mutate(nodes=as.numeric(nodes)) %>% do(coeff=lm(final_rate ~ 0 + nodes, data=.)$coefficients)
#tbl_models <- tbl_models %>% unnest_wider(coeff) %>% rename(myslope=nodes) %>% select(scenario, myslope)
#tbl_fract <- tbl_models / tbl_ideal_slope



