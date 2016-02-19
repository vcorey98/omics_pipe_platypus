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
#KNOWN_SITES: (ex: p_fal.known.vcf)
#GATK_VERSION (ex: 3.2-1)

###################### FILE NOTES #####################################################

#FILES USED (file step # origin): $REFERENCE, $KNOWN_SITES; hold10.bam (6)
#FILES GENERATED: $SAMPLE_NAME.recal.table

###################### REQUIRED MODULES ###############################################

module load gatk/$5


###################### ADDITIONAL VARIABLES ###########################################

SAMPLE_NAME=$1
SCRATCH_DIR=$2
REFERENCE=$3
KNOWN_SITES=$4


######################## GATK BASE RECALIBRATOR #######################################
#Recalibrating bases (before realignment)
java -Xms454m -Xmx3181m -jar $EBROOTGATK/GenomeAnalysisTK.jar \
-T BaseRecalibrator \
-R ${REFERENCE} \
-I ${SCRATCH_DIR}/hold10.bam \
-knownSites ${KNOWN_SITES} \
-o ${SCRATCH_DIR}/${SAMPLE_NAME}.recal.table


exit 0
