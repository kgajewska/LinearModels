library(agricolae)
load("~/Modele liniowe i mieszane/projekt 1/clinical.cb.rda")
load("~/Modele liniowe i mieszane/projekt 1/expression.cb1.rda")
load("~/Modele liniowe i mieszane/projekt 1/expression.cb2.rda")

expression <- rbind(expression.cb1, expression.cb2)
remove(expression.cb1, expression.cb2)
clinical.cb$sampleID<-sub("-", ".", clinical.cb$sampleID)
clinical.cb$sampleID<-sub("-", ".", clinical.cb$sampleID)
clinical.cb$sampleID<-sub("-", ".", clinical.cb$sampleID)

# rownames(clinical.cb)<-clinical.cb$sampleID
# clinical.cb <-clinical.cb[,-1]

rownames(expression)<- expression$Sample
expression <- expression[, -1]

t_expression <- t(expression)
t_expression <- as.data.frame(t_expression)

# clinical.cb$id<-rownames(clinical.cb)

colnames(clinical.cb)[1]<-"id"
t_expression$id<- rownames(t_expression)
data<- merge(clinical.cb, t_expression, by="id")

colnames(data)[18] <- "CancerType"
CancerType <- data$CancerType

nrofgroups <- 0
normality<-1
cook<-0
bresuch<-0

# length(colnames(data))
# to perform test I in loop there is 200, but eventually should be length(colnames(data))
for (i in 30:200) {
  x <- data[,i]
  model = aov(x ~ CancerType)
  # in Scheffe test we do not need equal numbers of observations in groups as well as in LSD test, but we have many groups, and Scheffe is more conservative, so we will get less number of genes, what I think is quite good, because ultimately such a quantititave analysis leads to quality analysis
  nrofgroups[i]<-match(tail(scheffe.test(model, "CancerType", console = FALSE)$groups$M,1), letters)
  normality[i]<-(shapiro.test(rstandard(model))$p.value<=0.05)
  cook[i]<-max(cooks.distance(model))
  bresuch[i]<-(bptest(model)$p.value<=0.05) # I am not sure if this is proper way to use this test
}

# I think we can add a few more tests about validity of our model, especially we can add
# sth to be able to generate interesting graphs, since he said that he likes graphs

hist(nrofgroups[30:length(nrofgroups)])
boxplot(cook[30:length(cook)], ylim=c(0, 0.1))
boxplot(cook[30:length(cook)], ylim=c(0, 1))
hist(cook[30:length(cook)]) # need to be fixed
which(normality==FALSE)
length(which(normality==FALSE))/(i-30)
which(bresuch==FALSE)
length(which(bresuch==FALSE))/(i-30)

colnames(data)[nrofgroups>7 & (is.na(nrofgroups) == FALSE)] # from histogram we see that it is better to put 7

