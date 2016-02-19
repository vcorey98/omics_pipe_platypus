#!/usr/bin/env python

from omics_pipe.parameters.default_parameters import default_parameters
from omics_pipe.utils import *
p = Bunch(default_parameters)


def fq2bam8_gatk_PrintReads(sample, fq2bam8_gatk_PrintReads_flag):
    '''Runs GATK to print reads.
    
    input: 
        hold10.bam
    output: 
        ${SAMPLE_NAME}.bam
    citation: 
        McKenna A, Hanna M, Banks E, Sivachenko A, Cibulskis K, Kernytsky A, Garimella K, Altshuler D, Gabriel S, Daly M, DePristo MA (2010). The Genome Analysis Toolkit: a MapReduce framework for analyzing next-generation DNA sequencing data. Genome Res. 20:1297-303.
    link: 
        http://www.broadinstitute.org/gatk/
    parameters from parameters file: 
        SCRATCH_PATH:

        RESULTS_PATH:

        REFERENCE:

        GENUS:

        SPECIES:

        READ_TYPE:

        GATK_VERSION:
        ''' 
    
    GENUS_ABREV = str.lower(p.GENUS[0])
    SPECIES_ABREV = str.lower(p.SPECIES[0:3])
    READ_ABREV = str.lower(p.READ_TYPE[0])
    SCRATCH_DIR = p.SCRATCH_PATH + "/scratch_" + sample
    RESULTS_DIR = p.RESULTS_PATH + "/" + GENUS_ABREV + "_" + SPECIES_ABREV + "_" + sample
    SAMPLE_NAME = GENUS_ABREV + "_" + SPECIES_ABREV + "_" + sample + "_" + READ_ABREV

    spawn_job(jobname = 'fq2bam8_gatk_PrintReads', SAMPLE = SAMPLE_NAME, LOG_PATH = p.LOG_PATH, RESULTS_EMAIL = p.RESULTS_EMAIL, SCHEDULER = p.SCHEDULER, walltime = "120:00:00", queue = p.QUEUE, nodes = 1, ppn = 8, memory = "29gb", script = "/fq2bam8_gatk-PrintReads_omicspipe.sh", args_list = [SAMPLE_NAME, SCRATCH_DIR, RESULTS_DIR, p.REFERENCE, p.GATK_VERSION])
    job_status(jobname = 'fq2bam8_gatk_PrintReads', resultspath = RESULTS_DIR + "/raw_results", SAMPLE = sample, outputfilename = SAMPLE_NAME + ".bam", FLAG_PATH = p.FLAG_PATH)
    return

if __name__ == '__main__':
    fq2bam8_gatk_PrintReads(sample, fq2bam8_gatk_PrintReads_flag)
    sys.exit(0)