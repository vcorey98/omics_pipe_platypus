#!/bin/bash
set -x


#source modules for current shell
source $MODULESHOME/init/bash


###################### PARAMETERS NEEDED ##############################################

#RESULTS_PATH: (ex: /Users/vcorey/MDTIP1_Results)
#REFERENCE: (ex: p_fal.fasta)
#GENUS: (ex: Plasmodium)
#SPECIES: (ex: falciparum)
#READ_TYPE (single, paired, OR mated): (ex: paired)
#GATK_VERSION (ex: 3.2-1)

###################### FILE NOTES #####################################################

#FILES USED (file step # origin): $REFERENCE; $SAMPLE_NAME.bam (8)
#FILES GENERATED: $SAMPLE_NAME_cov.sample_interval_statistics, $SAMPLE_NAME_cov.sample_interval_summary, $SAMPLE_NAME_cov.sample_statistics, $SAMPLE_NAME_cov.sample_summary

###################### REQUIRED MODULES ###############################################

module load gatk/$4


###################### ADDITIONAL VARIABLES ###########################################

SAMPLE_NAME=$1
RESULTS_DIR=$2
REFERENCE=$3


###################### CREATE DIRECTORIES #############################################
#creates directories required for files generated if the do not already exist
mkdir -p ${RESULTS_DIR}/metrics


######################## GATK DEPTH OF COVERAGE #######################################
#Getting depth of coverage
java -Xms454m -Xmx3181m -jar $EBROOTGATK/GenomeAnalysisTK.jar \
-T DepthOfCoverage \
-R ${REFERENCE} \
-I ${RESULTS_DIR}/raw_results/${SAMPLE_NAME}.bam \
-omitBaseOutput \
-omitLocusTable \
-ct 3 -ct 4 -ct 5 -ct 8 -ct 10 -ct 12 -ct 15 -ct 20 \
-o ${RESULTS_DIR}/metrics/${SAMPLE_NAME}_cov


exit 0
