library(lmtest)
library(car)

################################### preparing and cleaning tables ###################################################

load("expression.cb1.rda")
load("expression.cb2.rda")
load("clinical.cb.rda")

expression <- rbind(expression.cb1, expression.cb2)

expression[1:5,1:5] #checking
clinical.cb[1:5,1:5] #checking

clinical.cb[,1] <- gsub("\\-", "\\.", clinical.cb[,1])

expression_tmp <- t(expression[,-1])
expression_tmp <- as.data.frame(expression_tmp)

colnames(expression_tmp) <- expression[,1]

expression_tmp <- cbind(rownames(expression_tmp), expression_tmp)

colnames(expression_tmp)[1] <- "PatientID"
colnames(clinical.cb)[1] <- "PatientID"

#merging tables
merged_table <- merge(expression_tmp, clinical.cb[,c("PatientID", "gender", "age_at_initial_pathologic_diagnosis", "X_cohort")], by="PatientID")

colnames(merged_table) <- gsub("\\?\\|","G", colnames(merged_table))
colnames(merged_table) <- gsub("\\-","", colnames(merged_table))
colnames(merged_table) <- gsub("\\,","", colnames(merged_table))
colnames(merged_table) <- gsub(" ","", colnames(merged_table))

merged_table[,"X_cohort"] <- as.factor(merged_table[,"X_cohort"])
merged_table[,"gender"] <- as.factor(merged_table[,"gender"])

#checking amount of cancer types and sizes of groups of observations
sapply(levels(merged_table$X_cohort), function(i) {sum(i==merged_table$X_cohort)})
cleaned_table <- merged_table[-which(merged_table$X_cohort=="TCGA Formalin Fixed Paraffin-Embedded Pilot Phase II"),]

# cleaning
cleaned_table <- cleaned_table[-which(cleaned_table$gender == ""),]
cleaned_table <- cleaned_table[-which(is.na(cleaned_table$age_at_initial_pathologic_diagnosis)),]
cleaned_table <- droplevels(cleaned_table)

hist(as.numeric(cleaned_table$age_at_initial_pathologic_diagnosis))

#discretization of age column
groups <- quantile(cleaned_table$age_at_initial_pathologic_diagnosis, probs=((0:18)/18))
discrete_age <- as.factor(unlist(lapply(cleaned_table$age_at_initial_pathologic_diagnosis, function(a) {groups[findInterval(a, groups)]})))
cleaned_table$discrete_age <- discrete_age
levels(cleaned_table$discrete_age)


################################### performing ANOVA ###################################################

pvalue_row <- function(i){ 
  anova(lm(cleaned_table[,i]~X_cohort*discrete_age*gender, data=cleaned_table))[1:7,5]  
}

##pvalues <- matrix(unlist(lapply(2:(ncol(cleaned_table)-4),pvalue_row)),ncol=7,byrow=T)
load("pvalues.RData")

#naming pvalues matrix
colnames(pvalues) <- rownames(anova(lm(cleaned_table[,1000]~X_cohort*discrete_age*gender, data=cleaned_table)))[1:7]
rownames(pvalues) <- colnames(cleaned_table)[2:(ncol(cleaned_table)-4)]

#cleaning pvalues matrix
pvalues <- pvalues[-which(is.na(pvalues[,7])),]

head(pvalues)

par(mfrow=c(2,3))

hist(pvalues[,1])
hist(pvalues[,2])
hist(pvalues[,3])
hist(pvalues[,4])
hist(pvalues[,6])
hist(pvalues[,7])

#extracting genes with low pvalues
rownames(anova(lm(cleaned_table[,1000]~X_cohort*discrete_age*gender, data=cleaned_table)))[1:7]

best1 <- names(which((pvalues[,4] < 0.01)*(pvalues[,5] < 0.01)*(pvalues[,7] < 0.01)==1))
length(best1)

best2 <- names(which((pvalues[,4] < 0.005)*(pvalues[,5] < 0.005)==1))
length(best2)

best3 <- names(which((pvalues[,4] < 0.01)==1))
length(best3)

best4 <- names(which((pvalues[,5] < 0.01)==1))
length(best4)

#looking for genes with good qqnorm plot
#qqnorm plot for some genes from good_shapiro_3 and good_shapiro_4
par(mfrow=c(2,3))
plot(lm(cleaned_table[,best1[1]]~X_cohort*discrete_age*gender, data=cleaned_table), which=2)
plot(lm(cleaned_table[,best1[2]]~X_cohort*discrete_age*gender, data=cleaned_table), which=2)
plot(lm(cleaned_table[,best1[3]]~X_cohort*discrete_age*gender, data=cleaned_table), which=2)
plot(lm(cleaned_table[,best2[1]]~X_cohort*discrete_age*gender, data=cleaned_table), which=2)
plot(lm(cleaned_table[,best2[2]]~X_cohort*discrete_age*gender, data=cleaned_table), which=2)
plot(lm(cleaned_table[,best2[3]]~X_cohort*discrete_age*gender, data=cleaned_table), which=2)

#genes, which have nice qqnorm plot
good_qq_1 <- best1[c(2, 8, 12, 14, 16, 18, 31, 32, 37, 41, 64, 66, 69, 72)]
good_qq_2 <- best2[c(3, 4, 5, 9, 10 ,12, 14, 17, 18, 29, 31, 33, 35, 36, 37, 42, 44, 45, 49, 55, 54, 56, 57, 66, 70, 72, 76, 79, 80, 83, 82, 86, 88, 90, 93, 100, 103, 106, 108, 113, 114, 115, 118, 121, 123, 126, 128, 129, 132, 133, 137, 142, 146, 147, 148)]
good_qq_2 <- setdiff(good_qq_2, good_qq_1)

#Shapiro-Wilk normality test
shapiro <- function(i){
  shapiro.test(lm(cleaned_table[,i]~X_cohort*discrete_age*gender, data=cleaned_table)$residuals)$p.value
}

##good_shapiro_3 <- best3[lapply(best3, shapiro) > 0.05]
##good_shapiro_4 <- best4[lapply(best4, shapiro) > 0.05]

#qqnorm plot for some genes from good_shapiro_3 and good_shapiro_4
par(mfrow=c(2,3))
plot(lm(cleaned_table[,good_shapiro_3[1]]~X_cohort*discrete_age*gender, data=cleaned_table), which=2)
plot(lm(cleaned_table[,good_shapiro_3[2]]~X_cohort*discrete_age*gender, data=cleaned_table), which=2)
plot(lm(cleaned_table[,good_shapiro_3[3]]~X_cohort*discrete_age*gender, data=cleaned_table), which=2)
plot(lm(cleaned_table[,good_shapiro_4[1]]~X_cohort*discrete_age*gender, data=cleaned_table), which=2)
plot(lm(cleaned_table[,good_shapiro_4[2]]~X_cohort*discrete_age*gender, data=cleaned_table), which=2)
plot(lm(cleaned_table[,good_shapiro_4[3]]~X_cohort*discrete_age*gender, data=cleaned_table), which=2)

par(mfrow=c(1,1))
interaction.plot(cleaned_table$gender, cleaned_table$X_cohort, cleaned_table$ADAMTS14)
interaction.plot(cleaned_table$gender, cleaned_table$X_cohort, cleaned_table$DTNA)
interaction.plot(cleaned_table$gender, cleaned_table$X_cohort, cleaned_table$IER3)

BP_1 <- sapply(good_qq_1, function(i) bptest(cleaned_table[,i]~X_cohort*discrete_age*gender, data=cleaned_table)$p.value)
BP_2 <- sapply(good_qq_2, function(i) bptest(cleaned_table[,i]~X_cohort*discrete_age*gender, data=cleaned_table)$p.value)
BP_3 <- sapply(good_shapiro_3, function(i) bptest(cleaned_table[,i]~X_cohort*discrete_age*gender, data=cleaned_table)$p.value)
BP_4 <- sapply(good_shapiro_4, function(i) bptest(cleaned_table[,i]~X_cohort*discrete_age*gender, data=cleaned_table)$p.value)

cancer_age_sex <- good_qq_1[BP_1>=0.04]
cancer_age_AND_cancer_sex <- good_qq_2[BP_2>=0.05]
cancer_age <- good_shapiro_3[BP_3>=0.05]
cancer_sex <- good_shapiro_4[BP_4>=0.05]