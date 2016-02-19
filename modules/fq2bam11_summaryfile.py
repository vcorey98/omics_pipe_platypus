#!/usr/bin/env python

from omics_pipe.parameters.default_parameters import default_parameters
from omics_pipe.utils import *
p = Bunch(default_parameters)


def fq2bam11_summaryfile(sample, fq2bam11_summaryfile_flag):
    '''Generate summary file for sample alignment.
    
    input: 
        $SAMPLE_NAME.aln_met, $SAMPLE_NAME.isize_met, $SAMPLE_NAME_cov.sample_summary
    output: 
        $SAMPLE_NAME_seq_summary.txt
    parameters from parameters file: 
        RESULTS_PATH:

        REFERENCE:

        REFERENCE_VERSION:

        GENUS:

        SPECIES:

        READ_TYPE:

        PLATFORM:
        ''' 

    GENUS_ABREV = str.lower(p.GENUS[0])
    SPECIES_ABREV = str.lower(p.SPECIES[0:3])
    READ_ABREV = str.lower(p.READ_TYPE[0])
    RESULTS_DIR = p.RESULTS_PATH + "/" + GENUS_ABREV + "_" + SPECIES_ABREV + "_" + sample
    SAMPLE_NAME = GENUS_ABREV + "_" + SPECIES_ABREV + "_" + sample + "_" + READ_ABREV

    spawn_job(jobname = 'fq2bam11_summaryfile', SAMPLE = sample, LOG_PATH = p.LOG_PATH, RESULTS_EMAIL = p.RESULTS_EMAIL, SCHEDULER = p.SCHEDULER, walltime = "120:00:00", queue = p.QUEUE, nodes = 1, ppn = 8, memory = "29gb", script = "/fq2bam11_summaryfile_omicspipe.sh", args_list = [sample, SAMPLE_NAME, RESULTS_DIR, p.REFERENCE, p.REFERENCE_VERSION, p.GENUS, p.SPECIES, READ_ABREV, p.PLATFORM])
    job_status(jobname = 'fq2bam11_summaryfile', resultspath = RESULTS_DIR, SAMPLE = sample, outputfilename = sample + "_seq_summary.txt", FLAG_PATH = p.FLAG_PATH)
    return

if __name__ == '__main__':
    fq2bam11_summaryfile(sample, fq2bam11_summaryfile_flag)
    sys.exit(0)