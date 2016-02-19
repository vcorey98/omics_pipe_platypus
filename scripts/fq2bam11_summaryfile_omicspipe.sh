#!/bin/bash
set -x


#source modules for current shell
source $MODULESHOME/init/bash


###################### PARAMETERS NEEDED ##############################################

#RESULTS_PATH: (ex: /Users/vcorey/MDTIP1_Results)
#REFERENCE: (ex: p_fal.fasta)
#REFERENCE_VERSION: (ex: PlasmoDB-13)
#GENUS: (ex: Plasmodium)
#SPECIES: (ex: falciparum)
#READ_TYPE (single, paired, OR mated): (ex: paired)
#PLATFORM: (ex: Illumina 2500 RapidRun)

###################### FILE NOTES ##################################################

#FILES USED (file step # origin): $REFERENCE; $SAMPLE_NAME.aln_met (3); $SAMPLE_NAME.isize_met (5); $SAMPLE_NAME_cov.sample_summary (9)
#FILES GENERATED: $SAMPLE_NAME_seq_summary.txt

###################### NO REQUIRED MODULES #########################################



###################### ADDITIONAL VARIABLES ########################################

SAMPLE=$1
SAMPLE_NAME=$2
RESULTS_DIR=$3
REFERENCE=$4
REFERENCE_VERSION=$5
GENUS=$6
SPECIES=$7
READ_ABREV=$8
PLATFORM=$9
reference_md5=`cksum ${REFERENCE} | cut -f 1 -d " "`


###################### CREATE SUMMARY FILE #########################################
#Create summary file
echo "Analysis start time: "`date` > ${RESULTS_DIR}/${SAMPLE}_seq_summary.txt
echo "Sample taxonomic designation: "${GENUS}" "${SPECIES} >> ${RESULTS_DIR}/${SAMPLE}_seq_summary.txt
echo "SAMPLE analyzed: "${SAMPLE} >> ${RESULTS_DIR}/${SAMPLE}_seq_summary.txt
echo "Platform used: "${PLATFORM} >> ${RESULTS_DIR}/${SAMPLE}_seq_summary.txt
echo "Reference used (md5): "${REFERENCE_VERSION}" ("${reference_md5}")" >> ${RESULTS_DIR}/${SAMPLE}_seq_summary.txt
echo "Total reads: "`awk '($1 ~ /^UNPAIRED$/) || ($1 ~ /^PAIR$/) {print $3}' ${RESULTS_DIR}/metrics/${SAMPLE_NAME}.aln_met` >> ${RESULTS_DIR}/${SAMPLE}_seq_summary.txt
echo "Aligned reads (percent): "`awk '($1 ~ /^UNPAIRED$/) || ($1 ~ /^PAIR$/) {print $6}' ${RESULTS_DIR}/metrics/${SAMPLE_NAME}.aln_met`" ("`awk '($1 ~ /^UNPAIRED$/) || ($1 ~ /^PAIR$/) {print $7}' ${RESULTS_DIR}/metrics/${SAMPLE_NAME}.aln_met`")" >> ${RESULTS_DIR}/${SAMPLE}_seq_summary.txt
echo "Mean coverage: "`awk '$1 ~ /^sample_id$/ {getline;print $10}' ${RESULTS_DIR}/metrics/${SAMPLE_NAME}_cov.sample_summary` >> ${RESULTS_DIR}/${SAMPLE}_seq_summary.txt
echo "Percent bases covered by 5 or more reads: "`awk '$1 ~ /^sample_id$/ {getline;print $8}' ${RESULTS_DIR}/metrics/${SAMPLE_NAME}_cov.sample_summary` >> ${RESULTS_DIR}/${SAMPLE}_seq_summary.txt
echo "Mean read length: "`awk '($1 ~ /^UNPAIRED$/) || ($1 ~ /^PAIR$/) {print $16}' ${RESULTS_DIR}/metrics/${SAMPLE_NAME}.aln_met` >> ${RESULTS_DIR}/${SAMPLE}_seq_summary.txt
if [ ${READ_ABREV} != "s" ]; then
	echo "Median insert size: "`awk '$1 ~ /^MEDIAN_INSERT_SIZE$/ {getline; print $1}' ${RESULTS_DIR}/metrics/${SAMPLE_NAME}.isize_met` >> ${RESULTS_DIR}/${SAMPLE}_seq_summary.txt
fi


exit 0