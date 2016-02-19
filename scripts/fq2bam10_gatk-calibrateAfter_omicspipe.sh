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
#KNOWN_SITES: (ex: p_fal.known.vcf)
#GATK_VERSION (ex: 3.2-1)

###################### FILE NOTES #####################################################

#FILES USED (file step # origin): $REFERENCE, $KNOWN_SITES; $SAMPLE_NAME.recal.table (7); $SAMPLE_NAME.bam (8); $SAMPLE_NAME.recal_comp.table (10)
#FILES GENERATED: $SAMPLE_NAME.recal_comp.table, $SAMPLE_NAME.recal.pdf

###################### REQUIRED MODULES ###############################################

module load gatk/$6
module load R/$7


###################### ADDITIONAL VARIABLES ###########################################

SAMPLE_NAME=$1
SCRATCH_DIR=$2
RESULTS_DIR=$3
REFERENCE=$4
KNOWN_SITES=$5


######################## GATK BASE RECALIBRATOR #######################################
#Recalibrating bases (after)
java -Xms454m -Xmx3181m -jar $EBROOTGATK/GenomeAnalysisTK.jar \
-T BaseRecalibrator \
-R ${REFERENCE} \
-I ${RESULTS_DIR}/raw_results/${SAMPLE_NAME}.bam \
-knownSites ${KNOWN_SITES} \
-o ${SCRATCH_DIR}/${SAMPLE_NAME}.recal_comp.table \
-BQSR ${SCRATCH_DIR}/${SAMPLE_NAME}.recal.table


######################## GATK ANALYZE COVARIATES ######################################
#Analyzing covariates
java -Xms454m -Xmx3181m -jar $EBROOTGATK/GenomeAnalysisTK.jar \
-T AnalyzeCovariates \
-R ${REFERENCE} \
-before ${SCRATCH_DIR}/${SAMPLE_NAME}.recal.table \
-after ${SCRATCH_DIR}/${SAMPLE_NAME}.recal_comp.table \
-plots ${SCRATCH_DIR}/${SAMPLE_NAME}.recal.pdf


exit 0
