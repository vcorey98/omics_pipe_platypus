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
#GATK_VERSION: (ex: 3.2-1)

###################### FILE NOTES #####################################################

#FILES USED (file step # origin): $REFERENCE; $SAMPLE_NAME.bam (fq2bam8)
#FILES GENERATED: $SAMPLE_NAME.raw

###################### REQUIRED MODULES ###############################################

module load gatk/$7


###################### ADDITIONAL VARIABLES ###########################################

SAMPLE_NAME=$1
RESULTS_DIR=$2
REFERENCE=$3
GENUS_ABREV=$4
SPECIES_ABREV=$5
READ_ABREV=$6

######################## GATK RAW SNV CALLS ###########################################
#Generate raw SNV calls
java -Xms454m -Xmx3181m -jar $EBROOTGATK/GenomeAnalysisTK.jar \
	-T UnifiedGenotyper \
	-R ${REFERENCE} \
	-I ${RESULTS_DIR}/raw_results/${SAMPLE_NAME}.bam \
	-o ${RESULTS_DIR}/raw_results/${SAMPLE_NAME}.raw \
	-nt 32 \
	-baq CALCULATE_AS_NECESSARY \
	-A AlleleBalanceBySample


exit 0
