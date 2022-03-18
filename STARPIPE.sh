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

GFF="./VectorBase-56_AaegyptiLVP_AGWG.gff"

GENOME="./VectorBase-56_AaegyptiLVP_AGWG_Genome.fasta"


##########################################################
###################### RUN THE JOB #######################
##########################################################

##Test that you have required files in working directory 

if [ -f "$GFF" ]; then
    echo "$GFF exists."
else 
    echo "$GFF does not exist, please add this file to working directory." 
exit 
fi

if [ -f "$GENOME" ]; then
    echo " $GENOME exists."
else 
    echo "$GENOME does not exist,please add this file to working directory." 
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

mkdir ./${SPECIES}Index 

chmod 755 -R ./*
chmod 755 *

##Make Index
#STAR  --runThreadN $USAGE \
#--runMode genomeGenerate \
#--genomeDir ./${SPECIES}Index \
#--genomeFastaFiles $GENOME \
#--sjdbGTFfile  $GFF \
#--sjdbGTFtagExonParentTranscript Parent \



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


##Step 1- Adapter trim
 trimmomatic will trim adapters reads and produce paired and unpaired outfiles 
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


##Step 2: Map Reads 
STAR --runThreadN 16 \
--genomeDir ${SPECIES}Index \
--readFilesIn  ${BASE}_1_paired.fastq.gz, ${BASE}_2_paired.fastq.gz \
--readFilesCommand zcat \
--outSAMtype BAM SortedByCoordinate \

##Rename outfile
mv Aligned.sortedByCoord.out.bam  ${BASE}_star.bam 

## Map Reads Sanity Check 
cat Log.final.out>>starmappingstat.txt
echo  "${BASE}_1_paired.fastq.gz, ${BASE}_2_paired.fastq.gz" >> starmappingstat.txt


#Step 3:
featureCounts -p -a $GFF \
 -o  ${BASE}undp.txt  \
 -R BAM ${BASE}_star.bam \
 -T $USAGE \
 -O -M  --fraction \


#sorts the mapped and counted genes 
samtools sort  ${BASE}_star.bam.featureCounts.bam   -o ${BASE}_star.sorted.bam


#Create an index file ending in .bai
samtools index  ${BASE}_star.sorted.bam 

#Check mapping
samtools flagstat ${BASE}_star.sorted.bam >> samstatfile.txt
echo ${BASE}_star.sorted.bam >> samstatfile.txt


##dedup samples
umi_tools dedup -I ${BASE}_star.sorted.bam  --umi-separator=":" --paired  --output-stats=${BASE}deduplicated  -S ${BASE}_star.dp.bam


#Get gene count after dedup 
featureCounts -p -a $GFF \
 -o  ${BASE}dp.txt  \
 -R BAM ${BASE}_star.bam \
 -T $USAGE \
 -O -M  --fraction \


done


#Summarize fastqc using multiqc  
 
 ##export LC_ALL=en_US.UTF-8
 
  ##multiqc ./FastQCtrim
	
 echo "Job's not finished. Job finished? I don't think so"
