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
#################### Parameter guide   ###################
##########################################################

## ILLUMINA CLIP PARAMETERS
## seedMismatches=2
## palindromeClipThreshold=30
## simpleClipThreshold=10
## minAdapterLength=8
##KeepBothRead=TRUE

## TRIMMOMATIC PARAMETERS
## headcrop=0
## leading=3
## trailing=3

## SLIDING WINDOW PARAMETERS
## slidingWindow=4
## qualityAverage=15

## minimumLength=36

##########################################################
#################### Setup variables #####################
##########################################################


USAGE="16"

SUFFIX1="_R1_001.fastq.gz"
SUFFIX2="_R2_001.fastq.gz"

FILES="./*_R1_001.fastq.gz"

SPECIES="Aedes"


##files that need to be in your working directory


ADAPTERS="./bbadapters.fa"

TRANSCRIPTOME="./VectorBase-56_AaegyptiLVP_AGWG_AnnotatedTranscripts.fa"



##########################################################
###################### RUN THE JOB #######################
##########################################################

##Test that you have required files in working directory 

if [ -f "$TRANSCRIPTOME" ]; then
    echo "$TRANSCRIPTOME exists."
else 
    echo "$TRANSCRIPTOME does not exist, please add this file to working directory." 
exit 
fi


if [ -f "$ADAPTERS" ]; then
    echo " $ADAPTERS exists."
else 
    echo "$ADAPTERS does not exist,please add this file to working directory."
exit 
fi


##Make required Directories
mkdir ./FastQCtrim


chmod 755 -R ./*
chmod 755 *

##Make salmon Index 
salmon index -t ${TRANSCRIPTOME}  $USAGE -i ${SPECIES}_transcripts_index  -k 31

## This will produce prefixes of all your files ex.Con1_S1, Con2_S2 and began for loop 
 
for PREFIX in $FILES
do BASE=$(basename $PREFIX $SUFFIX1 )

#sanity check of your variables 

if [ -f "${BASE}${SUFFIX1}" ]; then
    echo " ${BASE}${SUFFIX1} exists."
else 
    echo " Your SUFFIX or BASE isn't set correctly." 
exit
fi
if [ -f "${BASE}${SUFFIX1}" ]; then
    echo " ${BASE}${SUFFIX2} exists."
else 
    echo " Your SUFFIX or BASE isn't set correctly." 
exit
fi


##Step 1- Adapter Trim

 trimmomatic PE -threads $USAGE \
 -phred33 \
 ${BASE}${SUFFIX1} ${BASE}${SUFFIX2} \
 ${BASE}_1_paired.fastq.gz ${BASE}_1_unpaired.fastq.gz ${BASE}_2_paired.fastq.gz ${BASE}_2_unpaired.fastq.gz \
 ILLUMINACLIP:$ADAPTERS:2:30:10:8:TRUE \
  LEADING:3 \
  TRAILING:3 \
  SLIDINGWINDOW:4:15 \
  MINLEN:36 \
  2>>trimstatfile.txt \
  
## Adapter trim sanity check, Make a fastqc file of trimmed reads 
fastqc -t $USAGE ${BASE}_1_paired.fastq.gz ${BASE}_1_unpaired.fastq.gz ${BASE}_2_paired.fastq.gz ${BASE}_2_unpaired.fastq.gz \
--outdir  ./FastQCtrim \
  
  
##Salmon mapping

  salmon quant -i ./${SPECIES}_transcripts_index -p $USAGE -l A -1 ${BASE}_1_paired.fastq.gz -2 ${BASE}_2_paired.fastq.gz --validateMappings -o ${BASE}_salmon

done

#Summarize fastqc using multiqc  
 
 export LC_ALL=en_US.UTF-8
 
 multiqc ./FastQCtrim
	


## Re-label salmon quant.sf file
for i in $(ls); do
  if [ -d $i ]; then
     fname=${i##*/}
     echo $fname
     cd $i
     for z in *.sf; do
       echo $z
       cp $z ${fname}_${z}
     done
     cp *_quant.sf .
     cd ..
  fi
done

echo "Job's not finished. Job finished? I don't think so" 
   
