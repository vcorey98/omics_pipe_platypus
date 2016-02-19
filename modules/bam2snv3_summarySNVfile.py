#!/usr/bin/env python

from omics_pipe.parameters.default_parameters import default_parameters
from omics_pipe.utils import *
p = Bunch(default_parameters)


def bam2snv3_summarySNVfile(sample, bam2snv3_summarySNVfile_flag):
    '''Generate summary file for sample alignment.
    
    input: 
        $SAMPLE_NAME.vcf; hold14.vcf, hold15.vcf
    output: 
        hold14.vcf, hold15.vcf, $SAMPLE_NAME_snv.csv
    parameters from parameters file: 
        SCRACTH_PATH:

        RESULTS_PATH:

        REFERENCE:

        REFERENCE_VERSION:

        GENUS:

        SPECIES:

        READ_TYPE:

        GENE_LIST:
        ''' 
   
    GENUS_ABREV = str.lower(p.GENUS[0])
    SPECIES_ABREV = str.lower(p.SPECIES[0:3])
    READ_ABREV = str.lower(p.READ_TYPE[0])
    RESULTS_DIR = p.RESULTS_PATH + "/" + GENUS_ABREV + "_" + SPECIES_ABREV + "_" + sample
    SCRATCH_DIR = p.SCRATCH_PATH + "/scratch_" + sample
    SAMPLE_NAME = GENUS_ABREV + "_" + SPECIES_ABREV + "_" + sample + "_" + READ_ABREV
   
    spawn_job(jobname = 'bam2snv3_summarySNVfile', SAMPLE = sample, LOG_PATH = p.LOG_PATH, RESULTS_EMAIL = p.RESULTS_EMAIL, SCHEDULER = p.SCHEDULER, walltime = "120:00:00", queue = p.QUEUE, nodes = 1, ppn = 8, memory = "29gb", script = "/bam2snv3_SummarySNVfile_omicspipe.sh", args_list = [sample, SAMPLE_NAME, SCRATCH_DIR, RESULTS_DIR, p.REFERENCE, p.REFERENCE_VERSION, p.GENUS, p.SPECIES, p.READ_TYPE, p.GENE_LIST])
    job_status(jobname = 'bam2snv3_summarySNVfile', resultspath = RESULTS_DIR, SAMPLE = sample, outputfilename = SAMPLE_NAME + "_snv.csv", FLAG_PATH = p.FLAG_PATH)
    return

if __name__ == '__main__':
    bam2snv3_summarySNVfile(sample, bam2snv3_summarySNVfile_flag)
    sys.exit(0)