Project 2
---------

# Introduction

The length of dendritic spine may be used as proxy for different neurological problems.

The goal of this project is to identify factors that may influence lengths of spines.
 
https://en.wikipedia.org/wiki/Dendritic_spine

# The dataset

The dataset dendriticSpines.rda (https://github.com/pbiecek/LinearModels/tree/master/MIMUW_2015/Project2) is a collection of data from three different studies (see the column Study). 

In each study two binary conditions are crossed: the mouse ,,type’’ and the treatment.

The mouse ,,type’’ is one of following: 

* WT (wild type) normal mice, 
* TG (transgenic) mice with additional genetic material and 
* KO (knock out) mice with a removed gene.

Treatments may be different: 

* from no treatment (-), 
* lit (li) or 
* some other substances (gm, dmso, chiron).

Our main target variable is the length of dendric spine (the column length). 
The way how spines are measured is following: from mouse ‘Animal ID’ the part (slice) of the brain is extracted. The slice is threated with treatment and then photos of slices are taken. Photo_ID_abs id the ID of the photo, note that this factor is nested in the Animal ID. In each photo different spines are visible. Length of spines visible on each photo is measured.


# The research objective:

Explain what factors affect the length of spines.

## Goal for phase 1:

Extract data from a single study (each group should use different study). Test if there is an interaction between the mouse type and the treatment.

Criteria:

*	Is there model validation?
*	Have you tested effect of an interaction?
*	Have you explained the effect of interaction properly (in figure or in table)?


## Goal for phase 2:

Verify what if the covariance structure in the model. Consider all three studies. Test which variables should be included in the model as random effects. Which should be included as a fixed effect? Which variable s may be removed from the model.

Criteria:

*	How do you model the effect of Animal?
*	How do you model the effect of Photo (nested or crossed)?
*	How do you model efects of mouse and treatment (not binary variables)?


## Goal for phase 3:

Find out which treatments affect lengths of spines for different mice.
Present these findings as a single graph.
Support these findings with proper statistical tests.

Criteria:

*	Which treatments are selected as important?
*	How effects of these treatments are presented?
*	Do you choose right tests for the task?


