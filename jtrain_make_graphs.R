# read saved R binary data frame

load("data/jtrain_all.rdata")

library(ggplot2)
# scatter plot
ggplot(data=jtrain, aes(x=educ, y=re78)) + 
  geom_point()

# simple bar plot
ggplot(data=jtrain, aes(x=race)) +
  geom_bar()

# stacked bar plot
ggplot(data=jtrain, aes(x=train, fill=race)) +
  geom_bar()

# grouped bar plot
ggplot(data=jtrain, aes(x=train, fill=race)) +
  geom_bar(position="dodge")


# histogram
ggplot(data=jtrain, aes(x=re78)) +
  geom_histogram()

# boxplot
ggplot(data=jtrain, aes(x=train, y=re78)) +
  geom_boxplot()



library(scales)
library(ggthemes)

## a better scatter plot
p <- ggplot(data=jtrain, aes(x=educ, y=re78*1000)) +
  geom_jitter(alpha=0.3) +
  geom_smooth(method="lm") +
  scale_y_continuous(labels=dollar) +
  facet_wrap(~train) +
  labs(x="Education in Years",
       y="",
       title="Income in 1978 by Education",
       subtitle="Across job training status") 

p

p + theme_bw()

p + theme_fivethirtyeight()
  
p + theme_minimal()


# save graph
ggsave(filename="scatterplot.svg")

# mean income in 1978 by race and training
plotdata <- aggregate(jtrain$re78, 
                      by=list(train=jtrain$train, 
                              race=jtrain$race), FUN=mean)
plotdata$income <- plotdata$x*1000

p <- ggplot(data=plotdata, aes(x=train, y=income, fill=race)) +
  geom_bar(position="dodge", stat="identity") +
  labs(x="", y="", title="Mean Income in 1978", 
       subtitle="By training status and race", 
       caption="Data Source: Manolis Kaparakis",
       fill="Race") +
  scale_y_continuous(labels=dollar) +
  scale_fill_brewer(palette="Set1") 
p


