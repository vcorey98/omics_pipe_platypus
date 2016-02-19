#!/usr/bin/env python

from omics_pipe.parameters.default_parameters import default_parameters
from omics_pipe.utils import *
p = Bunch(default_parameters)


def fq2bam3_picard(sample, fq2bam3_picard_flag):
    '''Runs PICARD to collect alignment summary metrics.
    
    input: 
        hold7.bam
    output: 
        .aln_met file
    citation: 
        http://picard.sourceforge.net/
    link: 
        http://picard.sourceforge.net/
    parameters from parameters file: 
        SCRATCH_PATH:
        
        RESULTS_PATH:

        REFERENCE:

        GENUS:

        SPECIES:

        READ_TYPE:
        
        PICARD_VERSION:
        ''' 
    
    GENUS_ABREV = str.lower(p.GENUS[0])
    SPECIES_ABREV = str.lower(p.SPECIES[0:3])
    READ_ABREV = str.lower(p.READ_TYPE[0])
    SCRATCH_DIR = p.SCRATCH_PATH + "/scratch_" + sample
    RESULTS_DIR = p.RESULTS_PATH + "/" + GENUS_ABREV + "_" + SPECIES_ABREV + "_" + sample
    SAMPLE_NAME = GENUS_ABREV + "_" + SPECIES_ABREV + "_" + sample + "_" + READ_ABREV

    spawn_job(jobname = 'fq2bam3_picard', SAMPLE = SAMPLE_NAME, LOG_PATH = p.LOG_PATH, RESULTS_EMAIL = p.RESULTS_EMAIL, SCHEDULER = p.SCHEDULER, walltime = "120:00:00", queue = p.QUEUE, nodes = 1, ppn = 8, memory = "29gb", script = "/fq2bam3_picard-alignsum_omicspipe.sh", args_list = [SAMPLE_NAME, SCRATCH_DIR, RESULTS_DIR, p.REFERENCE, GENUS_ABREV, SPECIES_ABREV, READ_ABREV, p.PICARD_VERSION])
    job_status(jobname = 'fq2bam3_picard', resultspath = RESULTS_DIR + "/metrics", SAMPLE = sample, outputfilename = SAMPLE_NAME + ".aln_met", FLAG_PATH = p.FLAG_PATH)
    return

if __name__ == '__main__':
    fq2bam3_picard(sample, fq2bam3_picard_flag)
    sys.exit(0)
