#!/usr/bin/env python

from omics_pipe.parameters.default_parameters import default_parameters
from omics_pipe.utils import *
p = Bunch(default_parameters)


def bam2snv2_gatk_filtering(sample, bam2snv2_gatk_filtering_flag):
    '''Generate summary file for sample alignment.
    
    input: 
        $SAMPLE_NAME.raw
    output: 
        $SAMPLE_NAME.vcf
    parameters from parameters file: 
        SCRATCH_PATH:

        RESULTS_PATH:

        REFERENCE:

        GENUS:

        SPECIES:

        READ_TYPE:

        CLUSTER_SIZE:

        CLUSTER_WINDOW:

        FS:

        MAPPING_QUALITY:

        QUALITY:

        MAPPING_QUAL_0:

        QUALITY_DEPTH:

        DELS:

        HAPLOTYPE_SCORE:

        DEPTH:

        SNPEFF_PATH:

        GATK_VERSION:

        SNPEFF_VERSION:
        ''' 
    
    GENUS_ABREV = str.lower(p.GENUS[0])
    SPECIES_ABREV = str.lower(p.SPECIES[0:3])
    READ_ABREV = str.lower(p.READ_TYPE[0])
    RESULTS_DIR = p.RESULTS_PATH + "/" + GENUS_ABREV + "_" + SPECIES_ABREV + "_" + sample
    SCRATCH_DIR = p.SCRATCH_PATH + "/scratch_" + sample
    SAMPLE_NAME = GENUS_ABREV + "_" + SPECIES_ABREV + "_" + sample + "_" + READ_ABREV
    
    spawn_job(jobname = 'bam2snv2_gatk_filtering', SAMPLE = SAMPLE_NAME, LOG_PATH = p.LOG_PATH, RESULTS_EMAIL = p.RESULTS_EMAIL, SCHEDULER = p.SCHEDULER, walltime = "120:00:00", queue = p.QUEUE, nodes = 1, ppn = 8, memory = "29gb", script = "/bam2snv2_gatk-snpeff-FilterAndAnnotations_omicspipe.sh", args_list = [SAMPLE_NAME, SCRATCH_DIR, RESULTS_DIR, p.REFERENCE, GENUS_ABREV, SPECIES_ABREV, p.CLUSTER_SIZE, p.CLUSTER_WINDOW, p.FS, p.MAPPING_QUALITY, p.QUALITY, p.MAPPING_QUAL_0, p.QUALITY_DEPTH, p.DELS, p.HAPLOTYPE_SCORE, p.DEPTH, p.SNPEFF_PATH, p.GATK_VERSION, p.SNPEFF_VERSION])
    job_status(jobname = 'bam2snv2_gatk_filtering', resultspath = RESULTS_DIR + "/raw_results", SAMPLE = sample, outputfilename = SAMPLE_NAME + ".vcf", FLAG_PATH = p.FLAG_PATH)
    return

if __name__ == '__main__':
    bam2snv2_gatk_filtering(sample, bam2snv2_gatk_filtering_flag)
    sys.exit(0)