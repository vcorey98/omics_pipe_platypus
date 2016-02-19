#!/usr/bin/env python

from omics_pipe.parameters.default_parameters import default_parameters
from omics_pipe.utils import *
p = Bunch(default_parameters)


def fq2bam4_samtools(sample, fq2bam4_samtools_flag):
    '''Runs SAMTOOLS to remove unmapped reads.
    
    input: 
        hold7.bam
    output: 
        hold8.bam
    citation: 
        Li H.*, Handsaker B.*, Wysoker A., Fennell T., Ruan J., Homer N., Marth G., Abecasis G., Durbin R. and 1000 Genome Project Data Processing Subgroup (2009) The Sequence alignment/map (SAM) format and SAMtools. Bioinformatics, 25, 2078-9. [PMID: 19505943] 
    link: 
        http://samtools.sourceforge.net/
    parameters from parameters file: 
        SCRATCH_PATH:
        
        SAMTOOLS_VERSION:
        ''' 

    SCRATCH_DIR = p.SCRATCH_PATH + "/scratch_" + sample

    spawn_job(jobname = 'fq2bam4_samtools', SAMPLE = sample, LOG_PATH = p.LOG_PATH, RESULTS_EMAIL = p.RESULTS_EMAIL, SCHEDULER = p.SCHEDULER, walltime = "120:00:00", queue = p.QUEUE, nodes = 1, ppn = 8, memory = "29gb", script = "/fq2bam4_samtools-UnmappedReads_omicspipe.sh", args_list = [sample, SCRATCH_DIR, p.SAMTOOLS_VERSION])
    job_status(jobname = 'fq2bam4_samtools', resultspath = SCRATCH_DIR, SAMPLE = sample, outputfilename = "hold8.bam", FLAG_PATH = p.FLAG_PATH)
    return

if __name__ == '__main__':
    fq2bam4_samtools(sample, fq2bam4_samtools_flag)
    sys.exit(0)