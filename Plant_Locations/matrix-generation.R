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
# allplants(19, 18, "Habitat")
# allplants(20, 7, "Habitat")

#######################
#######################
#######################

# FUNCTIONAL TYPE SUMMATION
# This generates a matrix which can be used for a heat map of a desited functional type
DR19 <- ftsummation(19, "FT", "DR", 18)
SR19 <- ftsummation(19, "FT", "SR", 18)

DR20 <- ftsummation(20, "FT", "DR", 7)
SR20 <- ftsummation(20, "FT", "SR", 7)
#######################
#######################
#######################

# HEAT MAP GENERATION
##########
# http://flowingdata.com/2010/01/21/how-to-make-a-heatmap-a-quick-and-easy-solution/

data <- DR19
heatmap(data, Rowv=NA, Colv=NA, col = cm.colors(256), scale="none", margins=c(5,10))


# Pretty it up like this? 
# https://learnr.wordpress.com/2010/01/26/ggplot2-quick-heatmap-plotting/


