## R for data analysis
## Part 1


x <- c(4, 4, 5, 6, 7, 2, 9)     
length(x) ; mean(x)
plot(x)  # plot the vector


x <- runif(200)
summary(x)
hist(x)


# sample session
install.packages("vcd")
help(package="vcd")
library(vcd)
help(Arthritis)
Arthritis
example(Arthritis)

# some stuff