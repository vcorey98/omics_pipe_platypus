#!/bin/bash
set -x


#source modules for current shell
source $MODULESHOME/init/bash


###################### PARAMETERS NEEDED ##############################################

#SCRATCH_PATH: (ex: /User/vcorey/scratch_dir)
#RESULTS_PATH: (ex: /Users/vcorey/MDTIP1_Results)
#REFERENCE: (ex: p_fal.fasta)
#GENUS: (ex: Plasmodium)
#SPECIES: (ex: falciparum)
#READ_TYPE (single, paired, OR mated): (ex: paired)
#GATK_VERSION: (ex: 3.2-1)
#SNPEFF_VERSION: (ex: 3.3e)

###################### FILTERS #######################################################

#CLUSTER_SIZE: (standard: 2)
#CLUSTER_WINDOW: (standard: 10)
#FS: (standard: 13.5)
#MAPPING_QUALITY: (standard: 7)
#QUALITY: (standard: 196.5)
#MAPPING_QUAL_0: (standard: 10)
#QUALITY_DEPTH: (standard: 0.0)
#DELS: (standard: 60.0)
#HAPLOTYPE_SCORE: (standard: 0.0)
#DEPTH: (standard: 14)

###################### FILE NOTES #####################################################

#FILES USED (file step # origin): $REFERENCE; $SAMPLE_NAME.raw (1); hold11.vcf, $SAMPLE_NAME_Unfiltered.vcf (2)
#FILES GENERATED: hold11.vcf, $SAMPLE_NAME_Unfiltered.vcf, $SAMPLE_NAME_snv_summary.html, $SAMPLE_NAME_snv_genes.txt, $SAMPLE_NAME.vcf

###################### REQUIRED MODULES ###############################################

module load gatk/${18}
module load snpeff/${19}


###################### ADDITIONAL VARIABLES ###########################################

SAMPLE_NAME=$1
SCRATCH_DIR=$2
RESULTS_DIR=$3
REFERENCE=$4
GENUS_ABREV=$5
SPECIES_ABREV=$6
CLUSTER_SIZE=$7
CLUSTER_WINDOW=$8
FS=$9
MAPPING_QUALITY=${10}
QUALITY=${11}
MAPPING_QUAL_0=${12}
QUALITY_DEPTH=${13}
DELS=${14}
HAPLOTYPE_SCORE=${15}
DEPTH=${16}
SNPEFF_PATH=${17}


######################## GATK FILTER/ANNOTATE SNVs #####################################
#Filter raw SNVs with pre-defined filters from parameters
java -Xms454m -Xmx3181m -jar $EBROOTGATK/GenomeAnalysisTK.jar \
	-T VariantFiltration \
	-R ${REFERENCE} \
	-V ${RESULTS_DIR}/raw_results/${SAMPLE_NAME}.raw \
	-o ${SCRATCH_DIR}/hold11.vcf \
	-cluster ${CLUSTER_SIZE} \
	-window ${CLUSTER_WINDOW} \
	-filter "FS > ${FS}" -filterName "LowFS" \
	-filter "MQ < ${MAPPING_QUALITY}" -filterName "LowMQ" \
	-filter "QUAL < ${QUALITY}" -filterName "LowQUAL" \
	-filter "MQ0 > ${MAPPING_QUAL_0}" -filterName "HighMQ0" \
	-filter "QD < ${QUALITY_DEPTH}" -filterName "LowQD" \
	-filter "Dels > ${DELS}" -filterName "HighDels" \
	-filter "HaplotypeScore < ${HAPLOTYPE_SCORE}" -filterName "HapScore" \
	-filter "DP < ${DEPTH}" -filterName "LowDP"


######################## SNPEFF ANNOTATION #############################################
#Annotate genes with Gene Name
java -jar $EBROOTSNPEFF/snpEff.jar \
	-o vcf \
	-ud 0 \
	-c ${SNPEFF_PATH}/snpEff.config ${GENUS_ABREV}"_"${SPECIES_ABREV} \
	${SCRATCH_DIR}/hold11.vcf > ${RESULTS_DIR}/raw_results/${SAMPLE_NAME}_Unfiltered.vcf

mv snpEff_summary.html ${RESULTS_DIR}/raw_results/${SAMPLE_NAME}_snv_summary.html
mv snpEff_genes.txt ${RESULTS_DIR}/raw_results/${SAMPLE_NAME}_snv_genes.txt


####################### FILTER OUT POOR QUALITY SNVS ###################################
#Remove Poor SNVs for final list
awk '$1 ~ /^#/ || ($7 ~ /PASS/ && $0 !~ /Low/ && $5 !~ /,/ && $10 !~ /^0\/1/) {print}' ${RESULTS_DIR}/raw_results/${SAMPLE_NAME}_Unfiltered.vcf > ${RESULTS_DIR}/raw_results/${SAMPLE_NAME}.vcf


exit 0
