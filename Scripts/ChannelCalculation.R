#########################
# Outfall002 coordenates
########################

library(tidyr)
library(dplyr)

Outfall02=read.csv("Data/002Coordenates.csv", sep=";", dec = ",")
Outfall02$X=Outfall02$X*2.54
Outfall02$Y=Outfall02$Y*2.54
