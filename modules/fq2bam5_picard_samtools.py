#!/usr/bin/env python

from omics_pipe.parameters.default_parameters import default_parameters
from omics_pipe.utils import *
p = Bunch(default_parameters)


def fq2bam5_picard_samtools(sample, fq2bam5_picard_samtools_flag):
    '''Runs PICARD and SAMTOOLS to generate metrics and reindex bam file to removed duplicate reads.
    
    input: 
        hold8.bam
    output: 
        hold9.bam
    citation: 
        Li H.*, Handsaker B.*, Wysoker A., Fennell T., Ruan J., Homer N., Marth G., Abecasis G., Durbin R. and 1000 Genome Project Data Processing Subgroup (2009) The Sequence alignment/map (SAM) format and SAMtools. Bioinformatics, 25, 2078-9. [PMID: 19505943] 
        http://picard.sourceforge.net/
    link: 
        http://samtools.sourceforge.net/
        http://picard.sourceforge.net/
    parameters from parameters file: 
        SCRATCH_PATH:
        
        RESULTS_PATH:

        REFERENCE:

        GENUS:

        SPECIES:

        READ_TYPE:

        SAMTOOLS_VERSION:

        PICARD_VERSION:
        ''' 

    GENUS_ABREV = str.lower(p.GENUS[0])
    SPECIES_ABREV = str.lower(p.SPECIES[0:3])
    READ_ABREV = str.lower(p.READ_TYPE[0])
    SCRATCH_DIR = p.SCRATCH_PATH + "/scratch_" + sample
    RESULTS_DIR = p.RESULTS_PATH + "/" + GENUS_ABREV + "_" + SPECIES_ABREV + "_" + sample
    SAMPLE_NAME = GENUS_ABREV + "_" + SPECIES_ABREV + "_" + sample + "_" + READ_ABREV

    spawn_job(jobname = 'fq2bam5_picard_samtools', SAMPLE = SAMPLE_NAME, LOG_PATH = p.LOG_PATH, RESULTS_EMAIL = p.RESULTS_EMAIL, SCHEDULER = p.SCHEDULER, walltime = "120:00:00", queue = p.QUEUE, nodes = 1, ppn = 8, memory = "29gb", script = "/fq2bam5_picardMetrics-samtoolsIndex_omicspipe.sh", args_list = [SAMPLE_NAME, SCRATCH_DIR, RESULTS_DIR, p.REFERENCE, READ_ABREV, p.SAMTOOLS_VERSION, p.PICARD_VERSION])
    job_status(jobname = 'fq2bam5_picard_samtools', resultspath = SCRATCH_DIR, SAMPLE = sample, outputfilename = "hold9.bam", FLAG_PATH = p.FLAG_PATH)
    return

if __name__ == '__main__':
    fq2bam5_picard_samtools(sample, fq2bam5_picard_samtools_flag)
    sys.exit(0)