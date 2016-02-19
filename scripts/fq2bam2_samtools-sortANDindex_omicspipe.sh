#!/bin/bash
set -x


#source modules for current shell
source $MODULESHOME/init/bash


###################### PARAMETERS NEEDED ##############################################

#SCRATCH_PATH: (ex: /User/vcorey/SCRATCH_PATH)
#REFERENCE: (ex: p_fal.fasta)
#REFERENCE_VERSION: (ex: PlasmoDB-13)
#SAMTOOLS_VERSION: (ex: 0.1.19)

###################### FILE NOTES #####################################################

#FILES USED (file step # origin): $REFERENCE; hold1.sam (1); hold2.bam, hold3.bam, hold4.txt, hold5.txt, hold6.txt, hold7.bam (2)
#FILES GENERATED: hold2.bam, hold3.bam, hold4.txt, hold5.txt, hold6.txt, hold7.bam

###################### REQUIRED MODULES ###############################################

module load samtools/$5


###################### ADDITIONAL VARIABLES ###########################################

SAMPLE=$1
SCRATCH_DIR=$2
REFERENCE=$3
REFERENCE_VERSION=$4

reference_md5=`cksum ${REFERENCE} | cut -f 1 -d " "`


######################## SAMTOOLS SORT ################################################
#Generating sequence alignment map
samtools view -bSu ${SCRATCH_DIR}/hold1.sam > ${SCRATCH_DIR}/hold2.bam

#Sorting alignment map
samtools sort -@ 4 ${SCRATCH_DIR}/hold2.bam ${SCRATCH_DIR}/hold3


######################## SAMTOOLS REHEAD AND INDEX ####################################
#make binary and sort (creating header)
samtools view -H ${SCRATCH_DIR}/hold3.bam > ${SCRATCH_DIR}/hold4.txt
echo "@CO	Reference: "${REFERENCE}" ("${REFERENCE_VERSION}")	MD5: "${reference_md5} > ${SCRATCH_DIR}/hold5.txt
cat ${SCRATCH_DIR}/hold4.txt ${SCRATCH_DIR}/hold5.txt > ${SCRATCH_DIR}/hold6.txt
samtools reheader ${SCRATCH_DIR}/hold6.txt ${SCRATCH_DIR}/hold3.bam > ${SCRATCH_DIR}/hold7.bam
samtools index ${SCRATCH_DIR}/hold7.bam


exit 0