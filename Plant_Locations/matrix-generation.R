# Author: Elise Wall
# Date: 28 Jan 2017
# Purpose: To take observed data of plant locations, sort them into a matrix representing their spacial presence, then sum them by funtional type and create a heat map of species locations.
# CAVEAT: The data we have starts at T0, this makes the T0 set in row 1... so T17 in the data is in row 18 here. Keep that in mind.
#
# THERE IS STILL SOMETHING WRONG WITH LOCAIOTNS(), get warnings about matrix size I can't figure it out
# number of items to replace is not a multiple of replacement length
# It doesn't seem to have any affect on the accuracy of the matricies though. So I'm ignoring it.

# Load all the functions I wrote in matrix-functions.R
source(file.path(getwd(), "Plant_Locations", "matrix-functions.R"))


#######################
#######################
#######################

# PLANT LOCATION GENERATION
# These save .csvs for each plant in Model>Data>Plants##>FT
# Not sure why the command line returns NULL, it works fine?
# Be sure to note how many plants did not have a functional type in the data!! ~2 dont for each combo of FT and OF

# Deep-rooted vs shallow-rooted
allplants(19, 18, "FT")
allplants(20, 7, "FT")

# Wetland Status
allplants(19, 18, "WS")
allplants(20, 7, "WS")

# Next time:
# Can try "Habitat" after this fix: Some data entry isnt perfect eg "T/S"
allplants(19, 18, "Habitat")
allplants(20, 7, "Habitat")

allplants(20, 7, "N_I")
allplants(19, 18, "N_I")

#######################
#######################
#######################

# FUNCTIONAL TYPE SUMMATION
# This generates a matrix which can be used for a heat map of a desited functional type
DR19 <- ftsummation(19, "FT", "DR", 18)
SR19 <- ftsummation(19, "FT", "SR", 18)

DR20 <- ftsummation(20, "FT", "DR", 7)
SR20 <- ftsummation(20, "FT", "SR", 7)


Inv19 <- ftsummation(19, "N_I", "0", 18)
Inv20 <- ftsummation(20, "N_I", "0", 7)

# THIS DATA STILL NEEDS TO  BE COMPLETED -- only usefull for grasses in 19 right now???
# Grass20 <- ftsummation(20, "WS", "G", 7)
  
#######################
#######################
#######################

# HEAT MAP GENERATION
##########
# http://flowingdata.com/2010/01/21/how-to-make-a-heatmap-a-quick-and-easy-solution/
library(RColorBrewer)
library(lattice)

FT <- c("DR20", "SR20", "DR19", "SR19", "Inv20", "Inv19")
# FT <- c("OBL", "UPLD", "etc....")
type <- c("Deep-Rooted", "Shallow-Rooted", "Deep-Rooted", "Shallow-Rooted", "Invasive Grass", "Invasive Grass")
CH <- c(20, 20, 19, 19, 20, 19)


# before function
i <- 6
HMdata <- Inv19

# Making heatmaps 
title <- paste("C", CH[i], " Functional Type Density: \n ", type[i], " Species", sep="")
# pal <- brewer.pal(max(HMdata)+1,"Greens")
pal <- cm.colors(256)
colseq <- seq(0,max(HMdata)+1,by=1)

png(filename = file.path(getwd(), 
                         "Plant_Locations", 
                         paste("C", CH[i], FT[i], ".png", sep="")
                         ),
    width = 460,
    height = 550)

print(levelplot(HMdata, 
                col.regions=pal,
                ylab = "From center of creek",
                xlab = "Transect (1 = Outfall)",
                colorkey = list(at = colseq, labels=list(at=colseq)),
                main = title))

dev.off()



# Origional heatmap, cant do legend
HM <- heatmap(HMdata, Rowv=NA, Colv=NA,
              col = pal,
              scale= "none",
              margins = c(5,3.5),
              main = title,
              #ColSideColors = c(),
              xlab = "From center of creek",
              ylab = "Transect (1 = Outfall)"
)

# Pretty it up like this? 
# https://learnr.wordpress.com/2010/01/26/ggplot2-quick-heatmap-plotting/


