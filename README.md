# Idmapping_fromdb2db
A wrapper of  biology id conversion of the restful api from bioDBnet website(https://biodbnet-abcc.ncifcrf.gov/)

### Introduction

Biological ID conversion is a problem we often encounter when dealing with various biological data. There are usually two ways: one is to use an online website, the most famous ones are `biomart` and `bioDBnet`; the other is to use local software such as `clusterProfiler::bitr`。


The online conversion process is cumbersome, requires uploading and downloading files, and requires secondary processing. In addition, if the number of conversions is large, it will be difficult to complete. Local conversion will have a slow database update, many conversions can not be completed, and the number of conversions is small.


To give a simple example, there is a sample file named `test_name.txt` under this project. The file is 100 **Ensmebl Trans Id**. If you want to perform downstream analysis, it is necessary to convert to **Gene Symbol**. 

If you use the `bitr` function, we can only get a small amount of mapping:

```R
library(clusterProfiler)
library(org.Hs.eg.db)
keytypes(org.Hs.eg.db)
# [1] "ACCNUM"       "ALIAS"        "ENSEMBL"      "ENSEMBLPROT"  "ENSEMBLTRANS" "ENTREZID"    
# [7] "ENZYME"       "EVIDENCE"     "EVIDENCEALL"  "GENENAME"     "GO"           "GOALL"       
#[13] "IPI"          "MAP"          "OMIM"         "ONTOLOGY"     "ONTOLOGYALL"  "PATH"        
#[19] "PFAM"         "PMID"         "PROSITE"      "REFSEQ"       "SYMBOL"       "UCSCKG"      
#[25] "UNIGENE"      "UNIPROT" 
```

```R
result<-bitr(data$gene,fromType = "ENSEMBLTRANS",toType = "SYMBOL",OrgDb = org.Hs.eg.db)
#'select()' returned 1:1 mapping between keys and columns
#Warning message:
#In bitr(data$gene, fromType = "ENSEMBLTRANS", toType = "SYMBOL",  :
#  84% of input gene IDs are fail to map...
head(result)
#      ENSEMBLTRANS    SYMBOL
#7  ENST00000418724    ZBTB22
#17 ENST00000374458    GGNBP1
#21 ENST00000588265     FXYD7
#25 ENST00000458629     CXCR6
#34 ENST00000595168 LOC400499
#38 ENST00000368547     ECHS1
```
But if we get information from the bioDBnet website, we only have 2 ids that don't match.Therefore, I hope to reduce the drawbacks of online conversion and improve conversion efficiency by packaging the api of the website.

### Usage

```R
library(RCurl)
library(rjson)
library(tidyr)
###read example data
data<-read.table("test_name.txt",header = FALSE,stringsAsFactors = FALSE)
colnames(data)<-"gene"

## you can get all input characters you can from input "getinputs" as the first parameter
bitr_db2db("getinputs")
# [1] "Affy GeneChip Array"          "Affy ID"                      "Affy Transcript Cluster ID"  
# [4] "Agilent ID"                   "Biocarta Pathway Name"        "CodeLink ID"                 
# [7] "dbSNP ID"                     "DrugBank Drug ID"             "DrugBank Drug Name"          
#[10] "EC Number"                    "Ensembl Gene ID"              "Ensembl Protein ID"
# ........

## you can get all output characters you can got from input "getoutputsforinput" as the first parameter。
bitr_db2db("getoutputsforinput","Ensembl Transcript ID")

#  [1] "Affy ID"                        "Agilent ID"                     "Allergome Code"                
#  [4] "ApiDB_CryptoDB ID"              "Biocarta Pathway Name"          "BioCyc ID"                     
#  [7] "CCDS ID"                        "Chromosomal Location"           "CleanEx ID"                    
# [10] "CodeLink ID"                    "COSMIC ID"                      "CPDB Protein Interactor"  
# ....

##to get ensmebl trans 2 symbol,you can input the follow cmd.
haha<-bitr_db2db("","Ensembl Transcript ID",data$gene,"Gene Symbol")
#[1] "your id have 1:1 mapping!"
head(haha)
#             from      to
#1 ENST00000532435   GDPD5
#2 ENST00000513185    RGMB
#3 ENST00000569370 CIAPIN1
#4 ENST00000451562    PPIA
#5 ENST00000289865   USP21
#6 ENST00000409411   PREPL

#when you make one 2 more like gene HTT
haha2<-bitr_db2db("","Gene Symbol","HTT","Ensembl Transcript ID")
[1] "waring:your id have more than one mapping!"
head(haha2)
#  from                 to
#1  HTT ENSCJAT00000027377
#2  HTT ENSBMUT00000040493
#3  HTT ENSBMUT00000040501
#4  HTT ENSBMUT00000040486
#5  HTT ENSBMUT00000040494
#6  HTT ENSBMUT00000040497
```
