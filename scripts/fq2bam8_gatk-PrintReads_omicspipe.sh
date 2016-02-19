#!/bin/bash
set -x


#source modules for current shell
source $MODULESHOME/init/bash


###################### PARAMETERS NEEDED ##############################################

#SCRATCH_PATH: (ex: /User/vcorey/SCRATCH_PATH)
#RESULTS_PATH: (ex: /Users/vcorey/MDTIP1_Results)
#REFERENCE: (ex: p_fal.fasta)
#GENUS: (ex: Plasmodium)
#SPECIES: (ex: falciparum)
#READ_TYPE (single, paired, OR mated): (ex: paired)
#GATK_VERSION (ex: 3.2-1)

###################### FILE NOTES #####################################################

#FILES USED (file step # origin): $REFERENCE; hold10.bam (6); $SAMPLE_NAME.recal.table (7)
#FILES GENERATED: $SAMPLE_NAME.bam

###################### REQUIRED MODULES ###############################################

module load gatk/$5


###################### ADDITIONAL VARIABLES ###########################################

SAMPLE_NAME=$1
SCRATCH_DIR=$2
RESULTS_DIR=$3
REFERENCE=$4


###################### CREATE DIRECTORIES #############################################
#creates directories required for files generated if the do not already exist
mkdir -p ${RESULTS_DIR}/raw_results


######################## GATK PRINT READS #############################################
#Printing reads
java -Xms454m -Xmx3181m -jar $EBROOTGATK/GenomeAnalysisTK.jar \
-T PrintReads \
-R ${REFERENCE} \
-I ${SCRATCH_DIR}/hold10.bam \
-o ${RESULTS_DIR}/raw_results/${SAMPLE_NAME}.bam \
-BQSR ${SCRATCH_DIR}/${SAMPLE_NAME}.recal.table \
-EOQ \
-preserveQ 5 \
-baq RECALCULATE


exit 0
