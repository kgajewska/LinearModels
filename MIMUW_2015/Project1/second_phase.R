################################### creating table ###################################################

load("expression.cb1.rda")
load("expression.cb2.rda")
load("clinical.cb.rda")

expression <- rbind(expression.cb1, expression.cb2)


clinical.cb[1:5,1:5] #checking
clinical.cb[,1] <- gsub("\\-", "\\.", clinical.cb[,1])
clinical.cb[1:5,1:5] #checking

expression_tmp <- t(expression[,-1])
expression_tmp <- as.data.frame(expression_tmp)

expression[1:5,1:5] #checking
expression_tmp[1:5,1:5] #checking

colnames(expression_tmp) <- expression[,1]

expression[1:5,1:5] #checking
expression_tmp[1:5,1:5] #checking

expression_tmp <- cbind(rownames(expression_tmp), expression_tmp)
expression_tmp[1:5,1:5] #checking

dim(expression_tmp) #checking
dim(expression) #checking

colnames(expression_tmp)[1] <- "PatientID"
colnames(clinical.cb)[1] <- "PatientID"

expression_tmp[1:5,1:5] #checking
clinical.cb[1:5,1:5] #checking

merged_table <- merge(expression_tmp, clinical.cb[,c("PatientID", "gender", "age_at_initial_pathologic_diagnosis", "X_cohort")], by="PatientID")

colnames(merged_table)[1:5] #checking
colnames(merged_table)[16110:length(colnames(merged_table))] #checking

colnames(merged_table) <- gsub("\\?\\|","G", colnames(merged_table))
colnames(merged_table) <- gsub("\\-","", colnames(merged_table))
colnames(merged_table) <- gsub("\\,","", colnames(merged_table))
colnames(merged_table) <- gsub(" ","", colnames(merged_table))
colnames(merged_table) <- paste("G", colnames(merged_table), sep="")

dim(merged_table) #checking
merged_table[1:5, 1:5] #checking
merged_table[1:5, 16110:16117] #checking
colnames(merged_table)[1:5] #checking
colnames(merged_table)[16110:length(colnames(merged_table))] #checking

merged_table[,"GX_cohort"] <- as.factor(merged_table[,"GX_cohort"])
merged_table[,"Ggender"] <- as.factor(merged_table[,"Ggender"])

sapply(levels(merged_table$GX_cohort), function(i) {sum(i==merged_table$GX_cohort)})

#cleaning
cleaned_table <- merged_table[-which(merged_table$GX_cohort=="TCGA Formalin Fixed Paraffin-Embedded Pilot Phase II"),]
cleaned_table <- cleaned_table[-which(cleaned_table$Ggender == ""),]
cleaned_table <- cleaned_table[-which(is.na(cleaned_table$Gage_at_initial_pathologic_diagnosis)),]
unique(cleaned_table$Gage_at_initial_pathologic_diagnosis)
dim(cleaned_table)
cleaned_table <- droplevels(cleaned_table)

sapply(levels(cleaned_table$GX_cohort), function(i) {sum(i==cleaned_table$GX_cohort)})

dim(cleaned_table)
dim(merged_table)

hist(as.numeric(cleaned_table$Gage_at_initial_pathologic_diagnosis))

sum(is.na(cleaned_table$Gage_at_initial_pathologic_diagnosis))

#discretization 1
cleaned_table$group_age <- cleaned_table$Gage_at_initial_pathologic_diagnosis %/% 5
cleaned_table[,"group_age"] <- as.factor(cleaned_table[,"group_age"])
levels(cleaned_table$group_age)

#discretization 2
groups <- quantile(cleaned_table$Gage_at_initial_pathologic_diagnosis, probs=((0:18)/18))
discrete_age <- unlist(lapply(cleaned_table$Gage_at_initial_pathologic_diagnosis, function(a) {groups[findInterval(a, groups)]}))
discrete_age <- as.factor(discrete_age)
cleaned_table$discrete_age <- discrete_age
levels(cleaned_table$discrete_age)

anova(lm(cleaned_table[,1000]~GX_cohort*discrete_age*Ggender, data=cleaned_table))
boxplot(GX_cohort~discrete_age+Ggender, data=cleaned_table)

PVcolumn <- function(i){ 
  anova(lm(cleaned_table[,i]~GX_cohort*discrete_age*Ggender, data=cleaned_table))[1:7,5]  
}

#pvalues <- matrix(unlist(lapply(2:(ncol(cleaned_table)-4),PVcolumn )),ncol=7,byrow=T)
load("pvalues2.RData")


colnames(pvalues) <- rownames(anova(lm(cleaned_table[,1000]~GX_cohort*discrete_age*Ggender, data=cleaned_table)))[1:7]
rownames(pvalues) <- colnames(cleaned_table)[2:(ncol(cleaned_table)-5)]

pvalues <- pvalues[-which(is.na(pvalues[,7])),]

head(pvalues)
tail(pvalues)
dim(pvalues)

sum(pvalues[,1]==0)
sum(pvalues[,2]==0)
sum(pvalues[,3]==0)
sum(pvalues[,4]==0)
sum(pvalues[,5]==0)
sum(pvalues[,6]==0)
sum(pvalues[,7]==0)

hist(pvalues[,1])
hist(pvalues[,2])
hist(pvalues[,3])
hist(pvalues[,4])
hist(pvalues[,5])
hist(pvalues[,6])
hist(pvalues[,7])

plot(ecdf(pvalues[,1]))
plot(ecdf(pvalues[,2]))
plot(ecdf(pvalues[,3]))
plot(ecdf(pvalues[,4]))
plot(ecdf(pvalues[,5]))
plot(ecdf(pvalues[,6]))
plot(ecdf(pvalues[,7]))

qqnorm(lm(cleaned_table[,2019]~GX_cohort*group_age*Ggender, data=cleaned_table)$residuals)

#save(pvalues, file="pvalues.Rdata")


sum((pvalues[,4] < 0.01)*(pvalues[,5] < 0.01)*(pvalues[,7] < 0.01))
thebest1 <- names(which((pvalues[,4] < 0.01)*(pvalues[,5] < 0.01)*(pvalues[,7] < 0.01)==1))


sum((pvalues[,4] < 0.005)*(pvalues[,5] < 0.005))
thebest2 <- names(which((pvalues[,4] < 0.005)*(pvalues[,5] < 0.005)==1))



show_plots <- function(names){
  par(mfrow=c(1,1))
  for (i in names){
    plot(lm(cleaned_table[,i]~GX_cohort*discrete_age*Ggender, data=cleaned_table), which=2)
    cat (i, "   ", which(i==names), "   ")
    cat ("Press [enter] to continue.")
    line <- readline()
  }
}

good_qq_1 <- thebest1[c(2, 8, 12, 14, 16, 18, 31, 32, 37, 41, 64, 66, 69, 72)]

good_qq_2 <- thebest2[c(3, 4, 5, 9, 10 ,12, 14, 17, 18, 29, 31, 33, 35, 36, 37, 42, 44, 45, 49, 55, 54, 56, 57, 66, 70, 72, 76, 79, 80, 83, 82, 86, 88, 90, 93, 100, 103, 106, 108, 113, 114, 115, 118, 121, 123, 126, 128, 129, 132, 133, 137, 142, 146, 147, 148)]

good_qq_2 <- setdiff(good_qq_2, good_qq_1)

sum(pvalues[,4] < 0.01)
thebest3 <- names(which((pvalues[,4] < 0.01)==1))

sum(pvalues[,5] < 0.01)
thebest4 <- names(which((pvalues[,5] < 0.01)==1))

shapiro <- function(i){
  shapiro.test(lm(cleaned_table[,i]~GX_cohort*discrete_age*Ggender, data=cleaned_table)$residuals)$p.value
}

good_shapiro_3 <- thebest3[lapply(thebest3, shapiro) > 0.05]
good_shapiro_4 <- thebest4[lapply(thebest4, shapiro) > 0.05]


lapply(good_qq_1, function(i) bptest(cleaned_table[,i]~GX_cohort*discrete_age*Ggender, data=cleaned_table))
lapply(good_qq_2, function(i) bptest(cleaned_table[,i]~GX_cohort*discrete_age*Ggender, data=cleaned_table))
lapply(good_shapiro_3, function(i) bptest(cleaned_table[,i]~GX_cohort*discrete_age*Ggender, data=cleaned_table))
lapply(good_shapiro_4, function(i) bptest(cleaned_table[,i]~GX_cohort*discrete_age*Ggender, data=cleaned_table))


show_plots(good_shapiro_3)

save(good_qq_1, file="good_qq_1")
save(good_qq_2, file="good_qq_2")
save(good_shapiro_3, file="good_shapiro_3")
save(good_shapiro_4, file="good_shapiro_4")


par(mfrow=c(1,1))
interaction.plot(cleaned_table$GX_cohort, cleaned_table$group_age, cleaned_table$GCLEC5A)
interaction.plot(cleaned_table$GX_cohort, cleaned_table$Ggender, cleaned_table$GCLEC5A)
levels(cleaned_table$Ggender)
#CO DALEJ:
# *tukey
# *interaction plot
# *kontrasty
# *wykresy (boxplot)