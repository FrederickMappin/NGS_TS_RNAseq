#!/bin/bash
#SBATCH --qos pq_mdegenna
#SBATCH --account iacc_mdegenna
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

SUFFIX1="M_R1_001.fastq.gz"

SUFFIX2="M_R2_001.fastq.gz"

SUFFIX3="M_R1_001.fastq"

SUFFIX4="M_R2_001.fastq"


NUM1="400"
NUM2="400"


# All files with suffix1
FILES="./*M_R1_001.fastq.gz" 





##########################################################
###################### RUN THE JOB #######################
##########################################################

# Takes the prefix of all fastq.gz files 
 for PREFIX in $FILES
do BASE=$(basename $PREFIX $SUFFIX1 )


#Sanity check
echo $BASE
echo ${BASE}${SUFFIX1}
echo ${BASE}${SUFFIX2}
echo ${BASE}${SUFFIX3}
echo ${BASE}${SUFFIX4}

#Read 1 HEAD
zcat ${BASE}${SUFFIX1} | head -${NUM1} > H${BASE}${SUFFIX3}; gzip H${BASE}${SUFFIX3}

#Read 2 HEAD
zcat ${BASE}${SUFFIX2} | head -${NUM2} > H${BASE}${SUFFIX4}; gzip H${BASE}${SUFFIX4}

 

done


rm *fastq


mkdir headfiles 

mv H* headfiles

echo "Job's not finished. Job finished? I don't think so"

