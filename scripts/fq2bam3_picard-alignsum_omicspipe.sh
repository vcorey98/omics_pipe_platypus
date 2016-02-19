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
#PICARD_VERSION (ex: 1.114)

###################### FILE NOTES #####################################################

#FILES USED (file step # origin): $REFERENCE; hold7.bam (2)
#FILES GENERATED: $SAMPLE_NAME.aln_met

###################### REQUIRED MODULES ###############################################

module load picard/$8


###################### ADDITIONAL VARIABLES ###########################################

SAMPLE_NAME=$1
SCRATCH_DIR=$2
RESULTS_DIR=$3
REFERENCE=$4
GENUS_ABREV=$5
SPECIES_ABREV=$6
READ_ABREV=$7


###################### CREATE DIRECTORIES #############################################
#creates directories required for files generated if the do not already exist
mkdir -p ${RESULTS_DIR}/metrics


######################## PICARD CollectAlignmentSummaryMetrics ########################
#Collecting alignment summary metrics
java -Xms454m -Xmx3181m -jar `which CollectAlignmentSummaryMetrics.jar` \
	I=${SCRATCH_DIR}/hold7.bam \
	R=${REFERENCE} \
	O=${RESULTS_DIR}/metrics/${SAMPLE_NAME}.aln_met \
	VALIDATION_STRINGENCY=SILENT


exit 0