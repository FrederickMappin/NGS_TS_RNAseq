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

SUFFIX1="_L001_R1_001.fastq.gz"

SUFFIX2="_L002_R1_001.fastq.gz"

SUFFIX3="_L001_R2_001.fastq.gz"

SUFFIX4="_L002_R2_001.fastq.gz"


# All files with suffix1
FILES="./*_L001_R1_001.fastq.gz" 





##########################################################
###################### RUN THE JOB #######################
##########################################################

# Takes the prefix of all fastq.gz files 
echo $FILES 
for PREFIX in $FILES
do base=$(basename $PREFIX $SUFFIX1 )

#Sanity check
echo $BASE
echo ${BASE}${SUFFIX1}
echo ${BASE}${SUFFIX2}
echo ${BASE}${SUFFIX3}
echo ${BASE}${SUFFIX4}

#Read 1 Lanes Merged
cat ${BASE}${SUFFIX1} ${BASE}${SUFFIX2} > ${BASE}_M_R1_001.fastq.gz

#Read 2 Lanes Merged
cat ${BASE}${SUFFIX3}  ${BASE}${SUFFIX4} > ${BASE}_M_R2_001.fastq.gz
 

done

#Sanity check: Number of lines e.g.  R1; lane 1 +lane 2  should equal Merged R1.
wc -l ./*_001.fastq.gz>linecounts.txt


echo "Job's not finished. Job finished? I don't think so"


 
