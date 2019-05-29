# read saved R binary data frame

load("data/jtrain_all.rdata")

# summary statistics
summary(jtrain)


# t-test
t.test(re78~train, data=jtrain)

# anova
aovfit <- aov(re78~train, data=jtrain)
summary(aovfit)

# linear regression
linfit <- lm(re78~train, data=jtrain)
summary(linfit)
