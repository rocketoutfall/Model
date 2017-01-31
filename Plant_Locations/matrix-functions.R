# Author: Elise Wall
# Date: 28 Jan 2017
# Purpose: To take observed data of plant locations, sort them into a matrix representing their spacial presence, then sum them by funtional type and create a heat map of species locations.
# CAVEAT: The data we have starts at T0, this makes the T0 set in row 1... so T17 in the data is in row 18 here. Keep that in mind.
#
# THERE IS STILL SOMETHING WRONG WITH LOCAIOTNS(), get warnings about matrix size I can't figure it out
# number of items to replace is not a multiple of replacement length
# It doesn't seem to have any affect on the accuracy of the matricies though. So I'm ignoring it.

library(dplyr)
library(RColorBrewer)
library(lattice)

#################
#################
#################

na.zero <- function(x) {
  x[is.na(x)] <- 0
  return(x)
}

#################
#################
#################
# locations()
# For a specified plant, make a matrix out of a row of our location 1/0 data
######################

locations <- function(row, outfallfile, tnum) {
  # row = which plant row we're looking at
  # outfall file points to the csv containing the observations for the desired outfall
  # tnum is number of transects -- count T0!!
  
  data <- read.csv(file.path(getwd(), "Data", outfallfile), header=T)
  pnum <- as.numeric(nrow(data))
  transects <- data[1:(pnum), 8:(tnum + 8)]
  horiz <- data[1:26, 5:7]
  zeros <- matrix(ncol = 1, nrow = tnum) %>%
    na.zero()
  collect <- c()
  
  # for loop to go through a column at a time (5-7)
  # if horizon == 0 then append a whole column'sworth of 0s, else it appends the observations for the transects
  for (i in 1:3) {
    if (horiz[row,i] == 0)
      collect <- c(collect, zeros) else
        collect <- c(collect, transects[row,1:(tnum)])
      next
  }
  
  # The for-loop created one loooong row of numbers, but since we know there are three columns, we can force it into a matrix with that size and a map is created
  plant <- matrix(as.numeric(collect), ncol = 3, nrow = tnum)
  
  return(plant)
}

#######################
#######################
#######################
# allplants()
# Loop through rows of the specified outfall data and create a csv file showing the locations for each plant
######################

allplants <- function(OF, tnum, type) {
  #OF is outfall, 19 or 20
  #tnum is number of transects
  #type is functional type desired (name of column in vegdata-OF)
  
  OFfile <- paste("vegdata-", OF, ".csv", sep="")
  data <- read.csv(file.path(getwd(), "Data", OFfile), header=T)
  pnum <- as.numeric(nrow(data))
  
  for(i in 1:pnum) {
    
    p <- as.data.frame(locations(i, paste("vegdata-", OF, ".csv", sep=""), tnum))
    
    write.csv(p, file=file.path(getwd(), "Data", paste("Plants", OF, sep=""), type, paste(i, strtrim(data[i,2], 5), "-", data[i,(colnames(data) == type)], ".csv", sep="")))
  }
  
  return()
  
}

#######################
#######################
#######################
# ftsummation()
# Take an outfall and specify what class of functional type you'd like. Output is the heatmap for that functional type.
######################

ftsummation <- function(OF, type, FT, tnum) {
  #FT is the specific variant of the functional type you want (Like, DR or OBL)
  match <- list.files(path = file.path(getwd(), "Data", paste("Plants", OF, sep=""), type), pattern = paste("-", FT, sep=""))
  sum <- matrix(ncol = 3, nrow = tnum) %>%
    na.zero()
  
  for (i in 1:length(match)) {
    path <- file.path(getwd(), "Data", paste("Plants", OF, sep=""), type, match[i])
    p <- read.csv(path)[ ,2:4] %>%
      data.matrix()
    sum <- sum + p
  }
  
  return(sum)
}

#######################
#######################
#######################
# makeHM()
# Mkae heatmaps and save them in Data
######################


makeHM <- function(i=1, HMdata=DR20, FT = c("DR20", "SR20", "DR19", "SR19", "Inv20", "Inv19", "Tree19", "Grass19", "Tree20", "Nat19", "Nat20"),
                   type = c("Deep-Rooted", "Shallow-Rooted", "Deep-Rooted", "Shallow-Rooted", "Invasive Grass", "Invasive Grass and Herb", "Tree", "Grass",  "Tree", "Native", "Native"),
                   CH = c(20, 20, 19, 19, 20, 19, 19, 19, 20, 19, 20)) {
  #i = what position in FT your data is
  #HMdata = name of the matrix you want to run, must be equal to FT[i]
  
  title <- paste("C", CH[i], " Functional Type Density: \n ", type[i], " Species", sep="")
  pal <- colorRampPalette(brewer.pal(9, "Greens"))(256)
  colseq <- seq(0,max(HMdata)+1,by=1)
  colnames(HMdata)  <- c("Bed","Bank", "Upland")
  
  png(filename = file.path(getwd(), 
                           "Plant_Locations", 
                           paste("C", CH[i], FT[i], ".png", sep="")
  ),
  width = 460,
  height = 550)
  
  print(levelplot(HMdata, 
                  col.regions=pal,
                  ylab = "Horizontal Distribution",
                  xlab = "Transect (1 = Outfall)",
                  colorkey = list(at = colseq, labels=list(at=colseq)),
                  main = title))
  
  dev.off()
  
}