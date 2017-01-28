# Author: Elise Wall
# Date: 28 Jan 2017
# Purpose: To take observed data of plant locations, sort them into a matrix representing their spacial presence, then sum them by funtional type and create a heat map of species locations.
# CAVEAT: The data we have starts at T0, this makes the T0 set in row 1... so T17 in the data is in row 18 here. Keep that in mind.
# CUrrently working: line 59

library(dplyr)

#################
#################
#################

na.zero <- function(x) {
  x[is.na(x)] <- 0
  return(x)
}

locations <- function(row, outfallfile, tnum) {
  # row = which plant row we're looking at
  # outfall file points to the csv containing the observations for the desired outfall
  # tnum is number of transects -- count T0!!
  
  data <- read.csv(file.path(getwd(), "Data", outfallfile), header=T)
  pnum <- as.numeric(nrow(data))
  transects <- data[1:(pnum),8:(tnum+8)]
  horiz <- data[1:26,5:7]
  zeros <- matrix(ncol=1, nrow=tnum) %>%
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

# Loop through rows
############
allplants <- function(OF, tnum) {
  
  OFfile <- paste("vegdata-", OF, ".csv", sep="")
  data <- read.csv(file.path(getwd(), "Data", OFfile), header=T)
  pnum <- as.numeric(nrow(data))
  summary <- data.frame(Plant=character(0), Transect=numeric(0), H1=numeric(0), H2=numeric(0), H3=numeric(0), WS=character(0))

#currently figuring out how to append rows into one dataframe for each outfall.
# Next, outside of this function, I will use dplyr to select rows for each functional type and sum them into a new datatable.
  # Then that will be what the heatmap is made from.
  for (i in 1:pnum) {
    locations(i, OFfile, tnum), file = file.path(getwd(), "Data", paste("Plants", OF, sep=""), paste(i, strtrim(data[i,2], 5), "-", data[i,(colnames(data) == "WS")], ".csv", sep="")))
  }
  
  return()
}


#############
#############
#############

OF19 <- allplants(19, 18)
OF20 <- allplants(20, 7)

# THERE IS STILL SOMETHING WRONG, get warnings about matrix size I can't figure it out
# number of items to replace is not a multiple of replacement length
# It doesn't seem to have any affect on the accuracy of the matricies though. So I'm ignoring it.

#############
#############
#############

# Heat Map
##########
# http://flowingdata.com/2010/01/21/how-to-make-a-heatmap-a-quick-and-easy-solution/

data1 <- read.csv(file.path(getwd(), "Data", "Plants19", "1Adeno-UPL.csv")) %>%
  select(2:4) %>%
  data.matrix()

OF20m <- data
OF20_heatmap <- heatmap(OF20m, Rowv=NA, Colv=NA, col = cm.colors(256), scale="none", margins=c(5,10))

###################
# Outstanding issues: 
###################

#How are we going to sort by functionaltype or CAwetland type?
## maybe add .functional type to end of common name?
## Maybe use a dplyr fuction to make a vector with just the row numbers of plants in each functional type, then do a for loop for i in (list of numnbers in that functional type)

# Change this so that all the functions are in one file -- look up how to call your own functions from a separate file

