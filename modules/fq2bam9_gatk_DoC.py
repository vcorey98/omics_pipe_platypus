#!/usr/bin/env python

from omics_pipe.parameters.default_parameters import default_parameters
from omics_pipe.utils import *
p = Bunch(default_parameters)


def fq2bam9_gatk_DoC(sample, fq2bam9_gatk_DoC_flag):
    '''Runs GATK to get depth of coverage for bam file.
    
    input: 
        ${SAMPLE_NAME}.bam
    output: 
        ${SAMPLE_NAME}_cov.sample*
    citation: 
        McKenna A, Hanna M, Banks E, Sivachenko A, Cibulskis K, Kernytsky A, Garimella K, Altshuler D, Gabriel S, Daly M, DePristo MA (2010). The Genome Analysis Toolkit: a MapReduce framework for analyzing next-generation DNA sequencing data. Genome Res. 20:1297-303.
    link: 
        http://www.broadinstitute.org/gatk/
    parameters from parameters file: 
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
    RESULTS_DIR = p.RESULTS_PATH + "/" + GENUS_ABREV + "_" + SPECIES_ABREV + "_" + sample
    SAMPLE_NAME = GENUS_ABREV + "_" + SPECIES_ABREV + "_" + sample + "_" + READ_ABREV

    spawn_job(jobname = 'fq2bam9_gatk_DoC', SAMPLE = SAMPLE_NAME, LOG_PATH = p.LOG_PATH, RESULTS_EMAIL = p.RESULTS_EMAIL, SCHEDULER = p.SCHEDULER, walltime = "120:00:00", queue = p.QUEUE, nodes = 1, ppn = 8, memory = "29gb", script = "/fq2bam9_gatk-DoC_omicspipe.sh", args_list = [SAMPLE_NAME, RESULTS_DIR, p.REFERENCE, p.GATK_VERSION])
    job_status(jobname = 'fq2bam9_gatk_DoC', resultspath = RESULTS_DIR + "/metrics", SAMPLE = sample, outputfilename = SAMPLE_NAME + "_cov.sample_summary", FLAG_PATH = p.FLAG_PATH)
    return

if __name__ == '__main__':
    fq2bam9_gatk_DoC(sample, fq2bam9_gatk_DoC_flag)
    sys.exit(0)