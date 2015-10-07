Project 1
---------

# Introduction

The Cancer Genome Atlas (TCGA) is a international effort to gather genetic and clinical data related to various types of cancer. See http://cancergenome.nih.gov/ for more details.

Dataset for selected 12 cancers is available in RTCGA.PANCAN12 package for R. https://github.com/mi2-warsaw/RTCGA.data/tree/master/RTCGA.PANCAN12

The 'expression.cb1' and 'expression.cb2' datasets are two parts of single matrix with gene expression profiles (the dataset was split into two parts due to github limitations).

The structure of this matrix is following

```{r}
> expression <- rbind(expression.cb1, expression.cb2)
> expression[1:5,1:5]
       Sample TCGA.AR.A1AH.01 TCGA.A5.A0GI.01 TCGA.BP.4165.01 TCGA.CJ.4876.01
1 ?|100133144        0.873126        1.160000              NA       -0.896874
2 ?|100134869       -0.380000       -0.332584           -1.27              NA
3     ?|10357        0.220000        1.112895           -0.39       -0.300000
4     ?|10431        1.360000        0.119982            0.09        0.510000
5    ?|155060       -0.030000        2.491257            0.63       -0.950000
```

Rows correspond to selected 16115 genes while columns correspond to 3600 patients. Name of the column is an ID of the patient.


For these patients we have also clinical data (note that clinical data is for 5158 patients). Here the structure is slightly different.
Each row is a patient. First column is an Id (note that here - is used instead of ., so be careful when merging both datasets).

We expect that two primary sources of genetic variation will be gender and cancer type (other important factors are not included here).

```{r}
> clinical.cb[1:5,c("sampleID", "X_cohort", "age_at_initial_pathologic_diagnosis", "gender")]
         sampleID          X_cohort age_at_initial_pathologic_diagnosis gender
1 TCGA-02-0001-01 TCGA Glioblastoma                                  44 FEMALE
2 TCGA-02-0003-01 TCGA Glioblastoma                                  50   MALE
3 TCGA-02-0004-01 TCGA Glioblastoma                                  59   MALE
4 TCGA-02-0006-01 TCGA Glioblastoma                                  56 FEMALE
5 TCGA-02-0007-01 TCGA Glioblastoma                                  40 FEMALE
```


# Goal

Goal of this project is to quantify sources of genetic variation among cancer types. 
Find genetic signatures -> sets of genes that differ among cancer types.


