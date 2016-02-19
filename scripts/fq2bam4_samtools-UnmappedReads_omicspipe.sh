#!/bin/bash
set -x


#source modules for current shell
source $MODULESHOME/init/bash


###################### PARAMETERS NEEDED ##############################################

#SCRATCH_PATH: (ex: /User/vcorey/SCRATCH_PATH)
#SAMTOOLS_VERSION: (ex: 0.1.19)

###################### FILE NOTES #####################################################

#FILES USED (file step # origin): hold7.bam (2); hold8.bam (4)
#FILES GENERATED: hold8.bam

###################### REQUIRED MODULES ###############################################

module load samtools/$3


###################### ADDITIONAL VARIABLES ###########################################

SAMPLE=$1
SCRATCH_DIR=$2


######################## SAMTOOLS Unmapped Reads ######################################
#Removing unmapped reads
samtools view -F 4 -b -h -o ${SCRATCH_DIR}/hold8.bam ${SCRATCH_DIR}/hold7.bam
samtools index ${SCRATCH_DIR}/hold8.bam


exit 0