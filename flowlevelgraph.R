### Lets make a graph!

library(tidyverse)
library(ggthemes)

levels = read.csv("Data/graphdata.csv", na.strings = "NaN")  # loading data aggregated from running the ChannelCalculation

boop <- gather(levels, "Flow", "y", 3:6)

# get data set up
lvl60 = select(levels, Dist, y60) %>%
  rename(y=y60)
lvl400 = select(levels, Dist, y400) %>%
  rename(y=y400)
lvl460 = select(levels, Dist, y460) %>%
  rename(y=y460)
lvlbank = select(levels, Dist, BankLow) %>%
  rename(y=BankLow)

# set graoh colors

#the graph
ggplot(boop, aes(Dist, y, group=Flow, fill=Flow)) +
  geom_smooth(se=FALSE, span=.3) +
  theme_pander() +
  labs(title ="Flow Depth Predictions", x = "Distance From OF2 (meters)", 
              y = "Depth (meters)") +
  scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9", "blue"), 
                    name="Experimental\nCondition",
                    breaks=c("ctrl", "trt1", "trt2"),
                    labels=c("Control", "Treatment 1", "Treatment 2"))
  

ggsave("plot.png", width = 7, height = 4)

# Ribbons... one day...
# geom_ribbon(data = boop[boop$Flow == 'BankLow',], aes(ymin = 0,ymax = predict(loess(y ~ Dist, span=.31)), fill=Flow), alpha = 0.2) +
#   geom_ribbon(data = boop[boop$Flow == 'y400',], aes(ymin = 0,ymax = predict(loess(y ~ Dist, span=.31)), fill=Flow), alpha = 0.2) +
#   geom_ribbon(data = boop[boop$Flow == 'y460',], aes(ymin = 0,ymax = predict(loess(y ~ Dist, span=.31)), fill=Flow), alpha = 0.2) +
#   geom_ribbon(data = boop[boop$Flow == 'y60',], aes(ymin = 0,ymax = predict(loess(y ~ Dist, span=.31)), fill=Flow), alpha = 0.2) +
#     geom_ribbon(aes(ymin=0, ymax = predict(loess(y ~ Dist, span=.3)), fill=Flow), alpha=0.5) +