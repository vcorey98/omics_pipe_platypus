#!/usr/bin/env python

from omics_pipe.parameters.default_parameters import default_parameters
from omics_pipe.utils import *
p = Bunch(default_parameters)


def fq2bam6_gatk_indels(sample, fq2bam6_gatk_indels_flag):
    '''Runs GATK to find indels and realign bam file around insertions/deletions.
    
    input: 
        hold9.bam
    output: 
        hold10.bam
    citation: 
        McKenna A, Hanna M, Banks E, Sivachenko A, Cibulskis K, Kernytsky A, Garimella K, Altshuler D, Gabriel S, Daly M, DePristo MA (2010). The Genome Analysis Toolkit: a MapReduce framework for analyzing next-generation DNA sequencing data. Genome Res. 20:1297-303.
    link: 
        http://www.broadinstitute.org/gatk/
    parameters from parameters file: 
        SCRATCH_PATH:

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
    SAMPLE_NAME = GENUS_ABREV + "_" + SPECIES_ABREV + "_" + sample + "_" + READ_ABREV

    spawn_job(jobname = 'fq2bam6_gatk_indels', SAMPLE = SAMPLE_NAME, LOG_PATH = p.LOG_PATH, RESULTS_EMAIL = p.RESULTS_EMAIL, SCHEDULER = p.SCHEDULER, walltime = "120:00:00", queue = p.QUEUE, nodes = 1, ppn = 8, memory = "29gb", script = "/fq2bam6_gatk-indels_omicspipe.sh", args_list = [SAMPLE_NAME, SCRATCH_DIR, p.REFERENCE, p.GATK_VERSION])
    job_status(jobname = 'fq2bam6_gatk_indels', resultspath = SCRATCH_DIR, SAMPLE = sample, outputfilename = "hold10.bam", FLAG_PATH = p.FLAG_PATH)
    return

if __name__ == '__main__':
    fq2bam6_gatk_indels(sample, fq2bam6_gatk_indels_flag)
    sys.exit(0)