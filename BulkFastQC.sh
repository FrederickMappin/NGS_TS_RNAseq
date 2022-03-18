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

USAGE="16"

#Dir of fastq.gz files
FILES="./*fastq.gz" 


##########################################################
###################### RUN THE JOB #######################
##########################################################
 
 mkdir ./FastQC

for f in $FILES ;
 do fastqc --outdir  ./FastQC -t $USAGE $f ; 
 done
 
 
 #Use installed multiqc to get one report for all fastqc outputs  
 
  export LC_ALL=en_US.UTF-8
 
 multiqc  ./FastQC
 
 
 
 echo "Job's not finished. Job finished? I don't think so"
 
 