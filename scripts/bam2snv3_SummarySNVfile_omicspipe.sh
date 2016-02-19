#!/bin/bash
set -x


#source modules for current shell
source $MODULESHOME/init/bash


###################### PARAMETERS NEEDED ##############################################

#SCRATCH_PATH: (ex: /User/vcorey/scratch_dir)
#RESULTS_PATH: (ex: /Users/vcorey/MDTIP1_Results)
#REFERENCE: (ex: p_fal.fasta)
#REFERENCE_VERSION: (ex: PlasmoDB-13)
#GENUS: (ex: Plasmodium)
#SPECIES: (ex: falciparum)
#READ_TYPE (single, paired, OR mated): (ex: paired)
#GENE_LIST: (ex: p_fal.gene_list)

###################### FILE NOTES #####################################################

#FILES USED (file step # origin): $REFERENCE, $GENE_LIST; $SAMPLE_NAME.vcf (2); hold14.vcf, hold15.vcf (3)
#FILES GENERATED: hold14.vcf, hold15.vcf, $SAMPLE_NAME_snv.csv

###################### NO REQUIRED MODULES #############################################


###################### ADDITIONAL VARIABLES ###########################################

SAMPLE=$1
SAMPLE_NAME=$2
SCRATCH_DIR=$3
RESULTS_DIR=$4
REFERENCE=$5
REFERENCE_VERSION=$6
GENUS=$7
SPECIES=$8
READ_TYPE=$9
GENE_LIST=${10}
reference_md5=`cksum ${REFERENCE} | cut -f 1 -d " "`


####################### CREATE SAMPLE SUMMARY SNV FILE #################################
#Manipulate SNV results file into something legible
awk '$1 !~ /^#/ {gsub(/.*EFF=/,"",$8); \
	gsub(/\|/,"|@",$8); \
	gsub(/\(/,"|@",$8); \
	gsub(/\)/,"",$8); \
	split($10,a,":"); \
	print $1, $2, $4, $5, $6, $8, a[2], a[5]}' ${RESULTS_DIR}/raw_results/${SAMPLE_NAME}.vcf | \
awk '{split($6,a,"|"); \
	split($7,b,","); \
	split($8,c,","); \
	print $1, $2, $3, $4, $5, a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], b[1], b[2], c[1], c[2], c[3]}' > ${SCRATCH_DIR}/hold14.txt


####################### GRAB GENE DESCRIPTION ##########################################
#Combine SNV summary file with gene descriptions
for line in `awk '{print $12}' ${SCRATCH_DIR}/hold14.txt`; do
	if [ ${line} != "@" ]; then
		genedescrip="@"`awk -v genename=$line '$4 == genename {print $5}' ${GENE_LIST}`
	else
		genedescrip="@"
	fi
	echo ${genedescrip} >> ${SCRATCH_DIR}/hold15.txt
done


####################### FINISH SAMPLE SUMMARY SNV FILE #################################
#Annotate SNV summary file with general sample information
echo "Chromosome Position Ref_Base Alt_Base Quality Effect Impact Functional_Class Codon_Change Amino_Acid_Change Amino_Acid_Length Gene_Name Gene_ID Gene_Coding Transcript_ID Genotype_Number Ref_Count Alt_Count Ref_Probability Polyclonal_Probability Alt_Probability Gene_Descrip" > ${SCRATCH_DIR}/hold13.txt
paste ${SCRATCH_DIR}/hold14.txt ${SCRATCH_DIR}/hold15.txt >> ${SCRATCH_DIR}/hold13.txt
echo "Analysis start time: "`date` > ${RESULTS_DIR}/${SAMPLE_NAME}_snv.csv
echo "Sample taxonomic designation: "${GENUS}" "${SPECIES} >> ${RESULTS_DIR}/${SAMPLE_NAME}_snv.csv
echo "Sample analyzed: "${SAMPLE} >> ${RESULTS_DIR}/${SAMPLE_NAME}_snv.csv
echo "Reference used (md5): "${REFERENCE_VERSION}" ("${reference_md5}")" >> ${RESULTS_DIR}/${SAMPLE_NAME}_snv.csv
awk '{print $1, $2, $12, $22, $5, $3, $4, $6, $7, $8, $9, $10, $17, $18, $19, $20, $21}' ${SUMMARY_HEADER} | awk '{gsub(/@/,"",$0);gsub(/ /,",",$0);gsub(/\t/,",",$0);print}' >> ${RESULTS_DIR}/${SAMPLE_NAME}_snv.csv


exit 0
