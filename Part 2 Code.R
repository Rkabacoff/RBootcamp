## An Introduction to R data analysis
## Part 2

# types of vectors
a <- c(1, 2, 5, 3, 6, -2, 4)
b <- c("one", "two", "three")
c <- c(TRUE, TRUE, TRUE, FALSE, TRUE, FALSE)

# identifying vector elements
a <- c(1, 2, 5, 3, 6, -2, 4)
a[3]
a[c(1, 3, 5)]
a[2:6]   

# creating a matrix
y <- matrix(1:20, nrow=5)
y

y <- matrix(1:20, nrow=5, byrow=TRUE)
y

data <- c(3615, 365, 2212, 3624, 6315, 4530)
rnames <- c("Alabama", "Alaska", "Arizona")
cnames <- c("Population", "Income")
y <- matrix(data, ncol=2, dimnames=list(rnames, cnames))
y


# using matrix subscripts
x <- matrix(1:10, nrow = 2)
x
x[2, ]                                    
x[, 2]                      
x[1, 4]   
x[1, c(4, 5)] 


# creating a data frame
ptID <- c(111, 208, 113, 408)
age           <- c(25, 34, 28, 52)
diabetes  <- c("Type1", "Type2", "Type1", "Type1")
status       <- c("Poor", "Improved", "Excellent", "Poor")
ptdata <- data.frame(ptID, age, diabetes, status)
ptdata

# specifying data frame elements
ptdata[1:2]
ptdata[c("diabetes", "status")]
ptdata$age
ptdata[1:2]
ptdata[2:3, 1:2]
ptdata[c(1,3), 1:2]

# the with() function
with(mtcars, {
    summary(mpg)
    plot(mpg, disp)
})


# factors
ptdata$sex <- c(1, 1, 2, 5)
ptdata$sex <- factor(ptdata$sex, levels=c(1, 2),
                 labels=c("Male", "Female"))

    
# lists
g <- "My First List"
h <- c(25, 26, 18, 39)
j <- matrix(1:10, nrow = 5)
k <- c("one", "two", "three")
mylist <- list(title = g, ages = h, mymatrix=j, mystrings=k)   
mylist

mylist[[2]]  
mylist[["ages"]]
mylist$ages

mylist$ages[2]  
mylist[[2]][2]
mylist$mymatrix[2,2]
mylist[[3]][,2]

# input data
library(readr)
jtrainB300 <- read_csv("data/jtrain_B300.csv")
jtrainA10 <- read_delim("data/jtrain_A10_freeform.txt", delim=" ")
jtrainC430 <- read_tsv("data/jtrain_C430.txt")

library(readxl)
jtrain_Dall <- read_excel("data/jtrain_Dall.xls")

# functions for working with objects
class(mtcars)
names(mtcars)
length(mtcars)
dim(mtcars)
str(mtcars)
head(mtcars)

# Salaries dataset
data(Salaries, package="carData")
name(Salaries)
head(Salaries)

# adding new variables 
experience <- (yrs.since.phd + yrs.service/2)    # fails

experience <- (Salaries$yrs.since.phd + 
                 Salariesyrs.service/2)    # doesn't fail but.

Salaries$experience <- (Salaries$yrs.since.phd + 
                          Salariesyrs.service/2)    # works

Salaries <- transform(Salaries, 
                      experience =(yrs.since.phd + yrs.service /2)) # better


# using transform
Salaries <- transform(Salaries, 
                      logSalary = log(salary),
                      experience = ( yrs.since.phd + yrs.service)/2,
                      salaryCat = cut(salary, 
                                      quantile(salary, probs=c(0, .33, .66, 1)),
                                      labels=c("low", "med", "high")),
                      discipline = factor(discipline, levels=c("A", "B"),
                                          labels=c("Theoretical", "Applied"))
                      
)


# renaming variables in a data frame
names(Salaries)
names(Salaries)[3:4] <- c("yrs.post.phd", "yrs.of.service")
names(Salaries)

# working with missing data
data(sleep, package="VIM")
head(sleep)
head(is.na(sleep))
colSums(is.na(sleep))
colMeans(is.na(sleep))
newSleep <- na.omit(sleep)
     
# subsetting a data frame

# selecting variables
df <- Salaries[c("rank", "sex", "salary")]
df <- Salaries[c(1, 5, 6)]
df <- df[-c(2, 3, 4)]

# selecting observations
newdata <- Salaries[1:5, ] 
newdata <- Salaries[Salaries$sex=="Female" & 
                      Salaries$salary > 100000, ]

# using subset
newdata <- subset(Salaries,
                  salary >= 200000 | salary <  60000, 
                  select=c(sex, rank, salary)) 

newdata <- subset(Salaries, 
                  sex=="Female" & salary > 60000,
                  select=yrs.post.phd:salary) 



# sorting data frames
index <- order(Salaries$rank, Salaries$salary)
Salaries  <- Salaries[index, ]
head(Salaries)

index <- order(Salaries$rank, -Salaries$salary)
newdf <- Salaries[index, ]
head(newdf)

# aggregation
aggdata <- aggregate(mtcars[c("mpg", "disp", "wt")],
                     by=list(cylinder=mtcars$cyl, gears = mtcars$gear),
                     FUN=mean, na.rm=TRUE)
aggdata

# by group processing
by(mtcars[c("mpg", "hp")], mtcars$am, summary)


