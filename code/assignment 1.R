############################################################
#                                                          #
#                    Assignment 1 in R                     #
#                                                          #
############################################################
library(readr)

# 1. read  family63A_tab.txt (tab delimited data) 
familyA <- read_tsv("data/family63A_tab.txt")

# 2. read family63B_FreeForm.txt (free form text file)
familyB <- read_table2("data/family63B_FreeForm.txt", col_names=FALSE)
names(familyB) <- names(familyA)

# 3. read family63C.csv  (comma delimited)
familyC <- read_csv("data/family63C.csv")                               
                                
# 4. merge/append A, B, C as appropriate
familyAB <- rbind(familyA, familyB)
familyABC <- merge(familyAB, familyC, by="id")
                                
# 5. Calculate descriptive statistics or frequencies
familyABC$race <- factor(familyABC$race)
familyABC$region <- factor(familyABC$region)
#    a) whole sample
summary(familyABC)
#    b) by region
by(familyABC, familyABC$region, summary)
by(familyABC, familyABC$region, psych::describe)

# 6. Compare average E across regions
aggregate(familyABC$E, by=list(region=familyABC$region), FUN=mean)
aggregate(familyABC$E, by=list(region=familyABC$region), FUN=sd)
summary(aov(E ~ region, familyABC))

# 7. create  regional dummies  (south=1 if region=3, zero otherwise)
#    (northcentral=1 if region=2, zero otherwise)
#    (west=1 if region=4, zero otherwise)
familyABC$south <- ifelse(familyABC$region == 3, 1, 0)
familyABC$northcentral <- ifelse(familyABC$region == 2, 1, 0)
familyABC$west <- ifelse(familyABC$region == 4, 1, 0)

# 8. estimate E=f(edu) and 
#    E=f(edu, south, northcentral, west)
summary(lm(E ~ edu, familyABC))
summary(lm(E ~ edu + northcentral + west, familyABC))

# 9. Produce a graph that shows regional differences like the one in varsbyregion_R.pdf


library(ggplot2)
library(reshape2)
df <- subset(familyABC, select=c(region, E, I, W, S))
dfagg <- aggregate(df[-1], by=list(region=df$region), mean)
dfm <- melt(dfagg)

dfm$region <- factor(dfm$region,
                     levels=c(1,2,3,4),
                     labels=c("South", "Northcentral", "Northeast", "West"))
dfm$variable <- factor(dfm$variable,
                       levels=c("E", "I", "W", "S"),
                       labels=c("Earnings (Head)",
                                "Income (Family)",
                                "Wealth",
                                "Savings"))
ggplot(data=dfm, aes(x=variable, y=value, fill=region)) +
  geom_bar(stat="identity", position="dodge") + 
  geom_text(aes(x=variable, y=value, label=round(value,2)), 
            position=position_dodge(width=1), size=3, vjust=-1) +
  labs(x="", y="Average (in thousands)", 
       title = "Graph1. Family Finances",
       subtitle ="Regional Profile",
       fill = "Region") + 
  theme_minimal()
