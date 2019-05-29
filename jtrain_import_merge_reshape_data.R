# import text data file -- unformatted 
library(readr)
jtrain_a <- read_delim("data/jtrain_A10_freeform.txt", delim=" ")

# import text data file -- CSV
jtrain_b<- read_csv("data/jtrain_B300.csv")

# import text data file -- tab delimited
jtrain_c <- read_tsv("data/jtrain_C430.txt")


# import Excel file
library(readxl)
jtrain_d <- read_excel("data/jtrain_Dall.xls", 1) 


# check your data frame
str(jtrain_d)


# append (concatenate, stacking) Jtrain_A, B and c
jtrain_abc<- rbind(jtrain_a, jtrain_b, jtrain_c) # must have same column names

# discuss bind_rows
library(dplyr)
jtrain_abc<- bind_rows(jtrain_a, jtrain_b, jtrain_c) # doesn't have to have
                                                     # same column names


# a quick example of sorting a data frame

jtrain_abc_sort<- jtrain_abc[order(jtrain_abc$id),]
# or
jtrain_abc_sort<- jtrain_abc[order(jtrain_abc$married, -jtrain_abc$age),] #descending for age


# remove objects from workspace
rm(jtrain_a, jtrain_b, jtrain_c, jtrain_abc_sort)


# merge abc with d
# you can specify multiple vars with by
# all option TRUE adds extra rows to the output for any rows that have no matches

jtrain_abcd<-merge(jtrain_abc, jtrain_d, by="id", all=TRUE)


# convert categorical variables into factors
jtrain <- jtrain_abcd
jtrain$train <- factor(jtrain$train,
                       levels = c(0, 1),
                       labels = c("no training", "job training"))
jtrain$married <- factor(jtrain$married,
                       levels = c(0, 1),
                       labels = c("not married", "married"))
jtrain$unem74 <- factor(jtrain$unem74,
                         levels = c(0, 1),
                         labels = c("no", "yes"))
jtrain$unem75 <- factor(jtrain$unem75,
                        levels = c(0, 1),
                        labels = c("no", "yes"))
jtrain$unem78 <- factor(jtrain$unem78,
                        levels = c(0, 1),
                        labels = c("no", "yes"))
jtrain$race <- factor(jtrain$race,
                        levels = c(1, 2, 3),
                        labels = c("White", "Black", "Hispanic"))

## reshape data

#melting a dataset
library(reshape2)
women
melt(women)


#  GOING LONG   :)
library(reshape2)
jtrain_long<-reshape(jtrain, idvar="id", 
                     varying=list( c("re74","re75", "re78"),
                                   c("unem74","unem75", "unem78")),
                     v.names=c("re", "unem"), 
                     timevar="year" , times=c(74, 75, 78), direction="long")



# GOING WIDE   :)
jtrain_wide<- reshape(jtrain_long,
                  idvar = "id", v.names = c("re", "unem"),
                  timevar = "year", direction = "wide")
#note that var names include a period


# aggregating
mean.re78 <- aggregate(jtrain_wide$re.78, by = list(jtrain_wide$train), FUN = mean)



# collapsing  ... the aggregate function

jtrain_aggr<-aggregate(re~id,  data=jtrain_long, mean, na.rm=TRUE)


# save dataset
save(file="data/jtrain.rdata", jtrain)
