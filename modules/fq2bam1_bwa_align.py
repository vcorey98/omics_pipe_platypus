#!/usr/bin/env python

from omics_pipe.parameters.default_parameters import default_parameters
from omics_pipe.utils import *
p = Bunch(default_parameters)


def fq2bam1_bwa_align(sample, fq2bam1_bwa_align_flag):
    '''Runs BWA to align .fastq files.
    
    input: 
        .fastq file
    output: 
        hold1.sam
    citation: 
        Li H. and Durbin R. (2010) Fast and accurate long-read alignment with Burrows-Wheeler Transform. Bioinformatics, Epub. [PMID: 20080505] 
    link: 
        http://bio-bwa.sourceforge.net/
    parameters from parameters file: 
        SCRATCH_PATH:

        RAW_DATA_DIR:
        
        RESULTS_PATH:
        
        REFERENCE:
        
        READ_TYPE:

        GENUS:

        SPECIES:
        
        BWA_VERSION:
        ''' 
    
    GENUS_ABREV = str.lower(p.GENUS[0])
    SPECIES_ABREV = str.lower(p.SPECIES[0:3])
    READ_ABREV = str.lower(p.READ_TYPE[0])
    SCRATCH_DIR = p.SCRATCH_PATH + "/scratch_" + sample
    RESULTS_DIR = p.RESULTS_PATH + "/" + GENUS_ABREV + "_" + SPECIES_ABREV + "_" + sample
    SAMPLE_NAME = GENUS_ABREV + "_" + SPECIES_ABREV + "_" + sample + "_" + READ_ABREV

    spawn_job(jobname = 'fq2bam1_bwa_align', SAMPLE = sample, LOG_PATH = p.LOG_PATH, RESULTS_EMAIL = p.RESULTS_EMAIL, SCHEDULER = p.SCHEDULER, walltime = "120:00:00", queue = p.QUEUE, nodes = 1, ppn = 32, memory = "29gb", script = "/fq2bam1_bwa-align_omicspipe.sh", args_list = [sample, SCRATCH_DIR, p.RAW_DATA_DIR, RESULTS_DIR, p.REFERENCE, READ_ABREV, p.BWA_VERSION])
    job_status(jobname = 'fq2bam1_bwa_align', resultspath = SCRATCH_DIR, SAMPLE = sample, outputfilename = "hold1.sam", FLAG_PATH = p.FLAG_PATH)
    return

if __name__ == '__main__':
    fq2bam1_bwa_align(sample, fq2bam1_bwa_align_flag)
    sys.exit(0)
