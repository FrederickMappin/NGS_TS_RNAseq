#!/bin/bash
# Number of nodes
#SBATCH -N 1
# Number of tasks
#SBATCH -n 16
#SBATCH --output=log

##########################################################
############ Setup environment ###########################
##########################################################

##module load 


#source activate env



#conda init bash

#source






##########################################################
#################### Setup variables #####################
##########################################################

# 


#Set the suffix of the files you want to merge 

suffix1="_L001_R1_001.fastq.gz"

suffix2="_L002_R1_001.fastq.gz"

suffix3="_L001_R2_001.fastq.gz"

suffix4="_L002_R2_001.fastq.gz"


# All files with suffix1
files="./*_L001_R1_001.fastq.gz" 





##########################################################
###################### RUN THE JOB #######################
##########################################################

# Takes the prefix of all fastq.gz files 
echo $files 
for prefix in $files
do base=$(basename $prefix $suffix1 )

#Sanity check
echo $base 
echo ${base}${suffix1}
echo ${base}${suffix2}
echo ${base}${suffix3}
echo ${base}${suffix4}

#Read 1 Lanes Merged
cat ${base}${suffix1} ${base}${suffix2} > ${base}_M_R1_001.fastq.gz

#Read 2 Lanes Merged
cat ${base}${suffix3}  ${base}${suffix4} > ${base}_M_R2_001.fastq.gz
 

done

#Sanity check: Number of lines e.g.  R1; lane 1 +lane 2  should equal Merged R1.
wc -l ./*_001.fastq.gz>linecounts.txt


echo "Job's not finished. Job finished? I don't think so"


 
