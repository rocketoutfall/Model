depths <- read.csv("H:/depths.csv")

library(ggplot2)

ggplot(depths, aes(X, elevation, color=type)) +
  theme_bw() +
  geom_smooth(span = 0.8, se = FALSE)
  
  


  geom_ribbon(data = boop[boop$Flow == 'y400',], aes(ymin = 0,ymax = predict(loess(y ~ Dist, span=.31)), fill=Flow), alpha = 0.2) +
  geom_ribbon(data = boop[boop$Flow == 'y460',], aes(ymin = 0,ymax = predict(loess(y ~ Dist, span=.31)), fill=Flow), alpha = 0.2) +
  geom_ribbon(data = boop[boop$Flow == 'y60',], aes(ymin = 0,ymax = predict(loess(y ~ Dist, span=.31)), fill=Flow), alpha = 0.2) +
  geom_ribbon(aes(ymin=0, ymax = predict(loess(y ~ Dist, span=.3)), fill=Flow), alpha=0.5) +