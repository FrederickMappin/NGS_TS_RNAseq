library(tximport)
library(readr)
library(rjson)


## Create a transcript-to-gene matching table (tx2gene) that will be used to aggregate transcript quantifications
tx2gene=T2GENE2021OCT
head(tx2gene)

## load salmon files
filesx=c("/Users/FreddyMappin/Desktop/salmonstuff/S-CON2_salmon_quant.sf","/Users/FreddyMappin/Desktop/salmonstuff/S-CON3_salmon_quant.sf","/Users/FreddyMappin/Desktop/salmonstuff/S-CON4_salmon_quant.sf","/Users/FreddyMappin/Desktop/salmonstuff/S-OCT2_salmon_quant.sf","/Users/FreddyMappin/Desktop/salmonstuff/S-OCT3_salmon_quant.sf","/Users/FreddyMappin/Desktop/salmonstuff/S-OCT4_salmon_quant.sf") 

names(filesx)= c("S-CON2_salmon_quant.sf","S-CON3_salmon_quant.sf","S-CON4_salmon_quant.sf","S-OCT2_salmon_quant.sf","S-OCT3_salmon_quant.sf","S-OCT4_salmon_quant.sf")

all(file.exists(filesx))

txi3<- tximport(filesx, type = "salmon", tx2gene = tx2gene)

out_file='/Users/FreddyMappin/Desktop/Oct2021.txt'
write.table(txi3,file=out_file)
txi