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
#BWA_VERSION: (ex: 0.7)

###################### FILE NOTES #####################################################

#FILES USED (file step # origin): $REFERENCE, $INPUTFILE1, $INPUTFILE2
#FILES GENERATED: hold1.sam

###################### REQUIRED MODULES ###############################################

module load bwa/$7


###################### ADDITIONAL VARIABLES ###########################################

SAMPLE=$1
SCRATCH_DIR=$2
RAW_DATA_DIR=$3
RESULTS_DIR=$4
REFERENCE=$5
READ_ABREV=$6

INPUTFILE1=${RAW_DATA_DIR}/${SAMPLE}_1.fastq
INPUTFILE2=${RAW_DATA_DIR}/${SAMPLE}_2.fastq


###################### CREATE DIRECTORIES #############################################
#creates scratch directory and results directory if the do not already exist
mkdir -p ${SCRATCH_DIR}
mkdir -p ${RESULTS_DIR}/metrics
mkdir -p ${RESULTS_DIR}/raw_results


######################## ALIGNING WITH BWA ############################################
#align sample to reference 
if [ ${READ_ABREV} = "s" ]; then
	bwa mem -M -t 32 -R "@RG\tID:"${SAMPLE}"\tLB:NexteraXT_WGS\tPL:ILLUMINA\tSM:"${SAMPLE} ${REFERENCE} ${INPUTFILE1} > ${SCRATCH_DIR}/hold1.sam
else
	bwa mem -M -t 32 -R "@RG\tID:"${SAMPLE}"\tLB:NexteraXT_WGS\tPL:ILLUMINA\tSM:"${SAMPLE} ${REFERENCE} ${INPUTFILE1} ${INPUTFILE2} > ${SCRATCH_DIR}/hold1.sam
fi


exit 0