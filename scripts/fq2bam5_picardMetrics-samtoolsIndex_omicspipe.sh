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
#SAMTOOLS_VERSION: (ex: 0.1.19)
#PICARD_VERSION (ex: 1.114)

###################### FILE NOTES #####################################################

#FILES USED (file step # origin): $REFERENCE; hold8.bam (4); hold9.bam (5)
#FILES GENERATED: $SAMPLE_NAME.gc_met, $SAMPLE_NAME.gc_bias.pdf, $SAMPLE_NAME.isize_met, $SAMPLE_NAME.isize_hist.pdf, hold9.bam, $SAMPLE_NAME.rdp_met

###################### REQUIRED MODULES ###############################################

module load samtools/$6
module load picard/$7


###################### ADDITIONAL VARIABLES ###########################################

SAMPLE_NAME=$1
SCRATCH_DIR=$2
RESULTS_DIR=$3
REFERENCE=$4
READ_ABREV=$5


###################### CREATE DIRECTORIES #############################################
#creates directories required for files generated if the do not already exist
mkdir -p ${RESULTS_DIR}/metrics


######################## PICARD CollectAlignmentSummaryMetrics ########################
#Collecting GC bias metrics
java -Xms454m -Xmx3181m -jar `which CollectGcBiasMetrics.jar` \
I=${SCRATCH_DIR}/hold8.bam \
R=${REFERENCE} \
O=${RESULTS_DIR}/metrics/${SAMPLE_NAME}.gc_met \
CHART=${RESULTS_DIR}/metrics/${SAMPLE_NAME}.gc_bias.pdf \
VALIDATION_STRINGENCY=SILENT


######################## PICARD CollectInsertSizeMetrics ##############################
#Collecting insert size metrics
if [ ${READ_ABREV} != "s" ]; then
	java -Xms454m -Xmx3181m -jar `which CollectInsertSizeMetrics.jar` \
	I=${SCRATCH_DIR}/hold8.bam \
	O=${RESULTS_DIR}/metrics/${SAMPLE_NAME}.isize_met \
	H=${RESULTS_DIR}/metrics/${SAMPLE_NAME}.isize_hist.pdf \
	VALIDATION_STRINGENCY=SILENT
fi


######################## PICARD MarkDuplicates ########################################
#Marking duplicate reads
java -Xms454m -Xmx3181m -jar `which MarkDuplicates.jar` \
I=${SCRATCH_DIR}/hold8.bam \
O=${SCRATCH_DIR}/hold9.bam \
METRICS_FILE=${RESULTS_DIR}/metrics/${SAMPLE_NAME}.rdp_met \
REMOVE_DUPLICATES=true \
VALIDATION_STRINGENCY=SILENT \
CREATE_INDEX=false COMPRESSION_LEVEL=0


######################## SAMTOOLS INDEX DUPLICATES REMOVED ############################
#Removing duplicate reads
samtools index ${SCRATCH_DIR}/hold9.bam


exit 0

