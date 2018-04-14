## Trinity: I used read.table function on the .txt file, which returned an error message that the number
## of variables in row 1 were not equal to those in subsequent rows. I imported the data in an Excel
## file and saved it as a .csv, removing the first two rows to eliminate the issue.

##Christelle: EDIT THIS TO MATCH YOUR DIRECTORY/ FILEPATH
filepath <- "C:/Users/Kaene II/Desktop/386PROJECT1/Data Cleaning Project/Task 2/Panel8595.csv"

## Trinity: Imported .csv into "Panel_8595.2" file in R.
Panel_8595.2 <- read.table(filepath)

library(dplyr)

## Trinity: Created column names based on those given in the .txt file (Y1:F2) and filled in headers for
## the last three columns (Yr85:Yr87). 
colnames(Panel_8595.2) <- c("Y1", "Y2", "Y3", "X1", "X2", "X3", "X4", 
                            "X5", "F1", "F2", "Yr85", "Yr86", "Yr87")
#View(Panel_8595.2)
View(Panel_8595.2)
## Christelle: From the research paper, we can properly label columns
## Taking only the data from 1987 to compare it to the sample data in the paper
data87 <- filter(Panel_8595.2, Y3 ==87)
summary(data87)

## Relabling column headings
Panel_8595.3 <- Panel_8595.2
colnames(Panel_8595.3) <- c("PlantID", "Y2", "Year", "Electricity", "SO2", "NOX", "CapStock", 
                            "Employees", "HC_Coal", "HC_Oil", "HC_Gas", "Yr86", "Yr87")
## Removing superfluous variables
Panel_8595.3 <- select(Panel_8595.3,PlantID,Year,Electricity,SO2,NOX,CapStock,Employees,
                       HC_Coal,HC_Oil, HC_Gas)
## Convert all energy measurements (energy produced and heat contents) into daily averages,
## measured in MWh
## The energy data is currently in yearly avg in Wh. Divide by 10^6 to get MWh. Divide by 365 to get daily.
Panel_8595.4 <- mutate(Panel_8595.3,Year = Year + 1900, Electricity = Electricity/10^6/365)
## The heat contents are in Btu. 1Btu = 2.93E-7 MWh. Divide by 365 to get daily.
Panel_8595.4 <- mutate(Panel_8595.4,HC_Coal = HC_Coal*2.9307E-7/365,
                       HC_Oil = HC_Oil*2.9307E-7/365, 
                       HC_Gas = HC_Gas*2.9307E-7/365)
## The energies have been converted to daily averages in MWh.

View(Panel_8595.4)

##Kaene Soto 04/11/2018
## Convert all pollutants quantities, measured in annualized short tons, into daily averages.
## Pollutants are currently measure in annualized short tons. Divide by 365 to get daily short tons
Panel_8595.5<-mutate(Panel_8595.4,SO2=SO2/365,NOX=NOX/365)
View(Panel_8595.5)
##Pollutants are now converted to daily averages

## Convert all dollars (measured in 1973 $'s) into 2017 $'s
## Dollars in Capital stock are currently in dollar value from 1973, $1 in 1973 is worth $5.52 in 2017.
## So multiply by 5.52 in order to get dollars in 2017
Panel_8595.6<-mutate(Panel_8595.5,CapStock=CapStock*5.52)
View(Panel_8595.6)
## Dollars are now measured in 2017 dollar value

## Trinity: Add Phase 1 factor variable (yr >= 1990, 1 = TRUE, 0 = FALSE)
Panel_8595.7<- mutate(.data = Panel_8595.6, Phase1 = as.numeric(Year >= "1990"))

## Trinity: Generate "tidy2.txt" file, and view
write.table(Panel_8595.7, file = "tidy2.txt")
read.table("tidy2.txt")