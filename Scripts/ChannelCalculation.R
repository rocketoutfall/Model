#########################
# Outfall002 coordenates
########################

library(tidyr)
library(dplyr)

data=read.csv("Data/ChannelMatlab.csv", sep=";", dec = ",", na.strings = "NaN")  # loading Outfall 002 Data
data$X=data$X*2.54
data$Y=data$Y*2.54

A <- 0
P <- 0


for (i in 1:max(data$Section)){
  
  # extract profile of interest
  profile <- data %>%
    filter(Section == i, !Position == "Mid") %>%
    select(Position, Y, Z, n)
  
  plot(profile$Y, -profile$Z)
  # Sys.sleep(2)
  
  n = mean(profile$n)
  
  # Extract vertices
  
  a <- filter(profile, Position == "Lout") %>%
    select(Y,Z)
  
  b <- filter(profile, Position == "Lin") %>%
    select(Y,Z)
  
  c <- filter(profile, Position == "Rin") %>%
    select(Y,Z)
  
  d <- filter(profile, Position == "Rout") %>%
    select(Y,Z)
  
#  e <- filter(profile, Position == "Lout") %>%
#    select(Y,Z)
  
  # Calculate area
  Base <- d$Y-a$Y
  base <- c$Y-b$Y
  h1 <- b$Z
  h2 <- c$Z
  abc <- base*h1/2
  acd <- Base*h2/2
  A[i] = abc + acd
  
  # calcular perìmetro
  
  l1 <- sqrt((a$Y-b$Y)^2+(a$Z-b$Z)^2)
  l2 <- sqrt((b$Y-c$Y)^2+(b$Z-c$Z)^2)
  l3 <- sqrt((c$Y-d$Y)^2+(c$Z-d$Z)^2)
  l4 <- sqrt((d$Y-a$Y)^2+(d$Z-a$Z)^2)
  
  P[i] <- l1+l2+l3+l4
  
  # calcular pendiente
  s = 0.02 #For now its a fixed value until we fix our data
}

R<- A/P
V <- (R^(2/3)*sqrt(s))/(n)
Q <- A*V

Section <- seq(1:max(data$Section))

flow <- data.frame(Section, A, P, R, V, Q)

data <- left_join(data, flow, by = "Section")

write.csv(data, file = "Data/Channel.csv", row.names = F)
write.csv(flow, file = "Data/Flow.csv", row.names = F)

# for(i in 1:10){
#   JC[i] <- 2*i+4
#   print(i)
# }



















