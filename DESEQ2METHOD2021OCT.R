####DESeq2 Method
# Load required libraries 
library(DESeq2)
library(edgeR)
library(limma)
library(Biobase)

#### Read the data
clba=rounded2021oct
head(clba)
#create dataframe 
samplesclba <- data.frame(colnames=c("C1", "C2", "C3", "T1", "T2", "T3"), condition=as.factor(c(rep("C",3), rep("T", 3))))
#construct the data set object
ddsclba <- DESeqDataSetFromMatrix(countData = as.matrix(clba), colData=samplesclba, design=~condition)
ddsclba <- DESeq(ddsclba, betaPrior=FALSE)
#create results table 
res <- results(ddsclba, contrast=c("condition","T","C")) 
head(res)
#remove low expressed genes
nrow(res)
sum( is.na(res$pvalue) )
res <- res[ ! is.na(res$pvalue), ]
nrow(res)
#filter the results such that 1%
sig <- res[ which(res$padj < 0.01), ]
head(sig)
write.table(res)

out_file='/Users/FreddyMappin/Desktop/Deseq2OCT2021.txt'
write.table(res,file=out_file)




