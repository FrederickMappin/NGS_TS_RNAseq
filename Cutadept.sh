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
source activate FreddyPG

#conda init bash
conda init bash

#source
source  /home/applications/spack/applications/gcc-8.2.0/miniconda3-4.5.11-oqs2mbgv3mmo3dll2f2rbxt4plfgyqzv/etc/profile.d/conda.sh



##########################################################
#################### Setup variables #####################
##########################################################

#Adapter=AGATCGGAAGAGX (non-internal)
#Adapter=AGATCGGAAGAGX (non-internal)
#qualitycutoff=0,20
#minimumlength=20
#cut=0  

USAGE="16"

SUFFIX1="_R1_001.fastq.gz"
SUFFIX2="_R2_001.fastq.gz"

FILES="./*_R1_001.fastq.gz"

ADAPTER1="CTGTCTCTTATACACATCT"

ADAPTER2="CTGTCTCTTATACACATCT"

##########################################################
###################### RUN THE JOB #######################
##########################################################

mkdir ./FastQCtrim


echo $FILES 
for PREFIX in $FILES
do BASE=$(basename $PREFIX $SUFFIX1 )
echo $BASE

cutadapt -a ${ADAPTER1}X -A ${ADAPTER2}X -q 0,20 -m 20 -u 0 -j $USAGE-o ${BASE}_1_paired.fastq.gz -p ${BASE}_2_paired.fastq.gz ${BASE}${SUFFIX1} ${BASE}${SUFFIX2} >> result.txt


## Adapter trim sanity check, Make a fastqc file of trimmed reads 
fastqc -t $USAGE ${BASE}_1_paired.fastq.gz ${BASE}_2_paired.fastq.gz  \
--outdir  ./FastQCtrim \

done

