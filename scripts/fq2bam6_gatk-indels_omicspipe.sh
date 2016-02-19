#!/bin/bash
set -x


#source modules for current shell
source $MODULESHOME/init/bash


###################### PARAMETERS NEEDED ##############################################

#SCRATCH_PATH: (ex: /User/vcorey/SCRATCH_PATH)
#REFERENCE: (ex: p_fal.fasta)
#GENUS: (ex: Plasmodium)
#SPECIES: (ex: falciparum)
#READ_TYPE (single, paired, OR mated): (ex: paired)
#GATK_VERSION (ex: 3.2-1)

###################### FILE NOTES #####################################################

#FILES USED (file step # origin): $REFERENCE; hold9.bam (5); $SAMPLE_NAME.rtc.intervals (6)
#FILES GENERATED: $SAMPLE_NAME.rtc.intervals, hold10.bam

###################### REQUIRED MODULES ###############################################

module load gatk/$4


###################### ADDITIONAL VARIABLES ###########################################

SAMPLE_NAME=$1
SCRATCH_DIR=$2
REFERENCE=$3


######################## GATK REALIGNER FINDING INDELS ################################
#Finding insertion/deletions
java -Xms454m -Xmx3181m -jar $EBROOTGATK/GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-R ${REFERENCE} \
-I ${SCRATCH_DIR}/hold9.bam \
-o ${SCRATCH_DIR}/${SAMPLE_NAME}.rtc.intervals


######################## GATK INDELREALIGN ############################################
#Realigning around insertion/deletions
java -Xms454m -Xmx3181m -jar $EBROOTGATK/GenomeAnalysisTK.jar \
-T IndelRealigner \
-R ${REFERENCE} \
-I ${SCRATCH_DIR}/hold9.bam \
-o ${SCRATCH_DIR}/hold10.bam \
-targetIntervals ${SCRATCH_DIR}/${SAMPLE_NAME}.rtc.intervals \
-compress 0


exit 0
