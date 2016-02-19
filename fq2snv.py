#!/usr/bin/env python
from ruffus import *
import sys
import os
import time
import datetime
import drmaa
from omics_pipe.utils import *
from omics_pipe.modules.fq2bam1_bwa_align import fq2bam1_bwa_align
from omics_pipe.modules.fq2bam2_samtools import fq2bam2_samtools
from omics_pipe.modules.fq2bam3_picard import fq2bam3_picard
from omics_pipe.modules.fq2bam4_samtools import fq2bam4_samtools
from omics_pipe.modules.fq2bam5_picard_samtools import fq2bam5_picard_samtools
from omics_pipe.modules.fq2bam6_gatk_indels import fq2bam6_gatk_indels
from omics_pipe.modules.fq2bam7_gatk_calibrate import fq2bam7_gatk_calibrate
from omics_pipe.modules.fq2bam8_gatk_PrintReads import fq2bam8_gatk_PrintReads
from omics_pipe.modules.fq2bam9_gatk_DoC import fq2bam9_gatk_DoC
from omics_pipe.modules.fq2bam10_gatk_recalibrate import fq2bam10_gatk_recalibrate
from omics_pipe.modules.fq2bam11_summaryfile import fq2bam11_summaryfile
from omics_pipe.modules.bam2snv1_gatk_rawcall import bam2snv1_gatk_rawcall
from omics_pipe.modules.bam2snv2_gatk_filtering import bam2snv2_gatk_filtering
from omics_pipe.modules.bam2snv3_summarySNVfile import bam2snv3_summarySNVfile

from omics_pipe.parameters.default_parameters import default_parameters
p = Bunch(default_parameters)

os.chdir(p.WORKING_DIR)
now = datetime.datetime.now()
date = now.strftime("%Y-%m-%d %H:%M")

print p

for step in p.STEPS:
    vars()['inputList_' + step] = []
    for sample in p.SAMPLE_LIST:
        vars()['inputList_' + step].append([sample, "%s/%s_%s_completed.flag" % (p.FLAG_PATH, step, sample)])
    print vars()['inputList_' + step]


############### fq2bam1_bwa_align ##################
@parallel(inputList_fq2bam1_bwa_align)
@check_if_uptodate(check_file_exists)
def run_fq2bam1_bwa_align(sample, fq2bam1_bwa_align_flag):
    fq2bam1_bwa_align(sample, fq2bam1_bwa_align_flag)
    return

############### fq2bam2_samtools ##################
@follows(run_fq2bam1_bwa_align)
@parallel(inputList_fq2bam2_samtools)
@check_if_uptodate(check_file_exists)
def run_fq2bam2_samtools(sample, fq2bam2_samtools_flag):
    fq2bam2_samtools(sample, fq2bam2_samtools_flag)
    return

############### fq2bam3_picard ##################
@follows(run_fq2bam2_samtools)
@parallel(inputList_fq2bam3_picard)
@check_if_uptodate(check_file_exists)
def run_fq2bam3_picard(sample, fq2bam3_picard_flag):
    fq2bam3_picard(sample, fq2bam3_picard_flag)
    return

############### fq2bam4_samtools ##################
@follows(run_fq2bam3_picard)
@parallel(inputList_fq2bam4_samtools)
@check_if_uptodate(check_file_exists)
def run_fq2bam4_samtools(sample, fq2bam4_samtools_flag):
    fq2bam4_samtools(sample, fq2bam4_samtools_flag)
    return

############### fq2bam5_picard_samtools ##################
@follows(run_fq2bam4_samtools)
@parallel(inputList_fq2bam5_picard_samtools)
@check_if_uptodate(check_file_exists)
def run_fq2bam5_picard_samtools(sample, fq2bam5_picard_samtools_flag):
    fq2bam5_picard_samtools(sample, fq2bam5_picard_samtools_flag)
    return

############### fq2bam6_gatk_indels ##################
@follows(run_fq2bam5_picard_samtools)
@parallel(inputList_fq2bam6_gatk_indels)
@check_if_uptodate(check_file_exists)
def run_fq2bam6_gatk_indels(sample, fq2bam6_gatk_indels_flag):
    fq2bam6_gatk_indels(sample, fq2bam6_gatk_indels_flag)
    return

############### fq2bam7_gatk_calibrate ##################
@follows(run_fq2bam6_gatk_indels)
@parallel(inputList_fq2bam7_gatk_calibrate)
@check_if_uptodate(check_file_exists)
def run_fq2bam7_gatk_calibrate(sample, fq2bam7_gatk_calibrate_flag):
    fq2bam7_gatk_calibrate(sample, fq2bam7_gatk_calibrate_flag)
    return

############### fq2bam8_gatk_PrintReads ##################
@follows(run_fq2bam7_gatk_calibrate)
@parallel(inputList_fq2bam8_gatk_PrintReads)
@check_if_uptodate(check_file_exists)
def run_fq2bam8_gatk_PrintReads(sample, fq2bam8_gatk_PrintReads_flag):
    fq2bam8_gatk_PrintReads(sample, fq2bam8_gatk_PrintReads_flag)
    return

############### fq2bam9_gatk_DoC ##################
@follows(run_fq2bam8_gatk_PrintReads)
@parallel(inputList_fq2bam9_gatk_DoC)
@check_if_uptodate(check_file_exists)
def run_fq2bam9_gatk_DoC(sample, fq2bam9_gatk_DoC_flag):
    fq2bam9_gatk_DoC(sample, fq2bam9_gatk_DoC_flag)
    return

############### fq2bam10_gatk_recalibrate ##################
@follows(run_fq2bam9_gatk_DoC)
@parallel(inputList_fq2bam10_gatk_recalibrate)
@check_if_uptodate(check_file_exists)
def run_fq2bam10_gatk_recalibrate(sample, fq2bam10_gatk_recalibrate_flag):
    fq2bam10_gatk_recalibrate(sample, fq2bam10_gatk_recalibrate_flag)
    return

############### fq2bam11_summaryfile ##################
@follows(run_fq2bam10_gatk_recalibrate)
@parallel(inputList_fq2bam11_summaryfile)
@check_if_uptodate(check_file_exists)
def run_fq2bam11_summaryfile(sample, fq2bam11_summaryfile_flag):
    fq2bam11_summaryfile(sample, fq2bam11_summaryfile_flag)
    return

############### bam2snv1_gatk_rawcall ##################
@follows(run_fq2bam11_summaryfile)
@parallel(inputList_bam2snv1_gatk_rawcall)
@check_if_uptodate(check_file_exists)
def run_bam2snv1_gatk_rawcall(sample, bam2snv1_gatk_rawcall_flag):
    bam2snv1_gatk_rawcall(sample, bam2snv1_gatk_rawcall_flag)
    return

############### bam2snv2_gatk_filtering ##################
@follows(run_bam2snv1_gatk_rawcall)
@parallel(inputList_bam2snv2_gatk_filtering)
@check_if_uptodate(check_file_exists)
def run_bam2snv2_gatk_filtering(sample, bam2snv2_gatk_filtering_flag):
    bam2snv2_gatk_filtering(sample, bam2snv2_gatk_filtering_flag)
    return

############### bam2snv3_summarySNVfile ##################
@follows(run_bam2snv2_gatk_filtering)
@parallel(inputList_bam2snv3_summarySNVfile)
@check_if_uptodate(check_file_exists)
def run_bam2snv3_summarySNVfile(sample, bam2snv3_summarySNVfile_flag):
    bam2snv3_summarySNVfile(sample, bam2snv3_summarySNVfile_flag)
    return


@follows(run_bam2snv3_summarySNVfile) 
@parallel(inputList_last_function)
@check_if_uptodate(check_file_exists)
def last_function(sample, last_function_flag):
    print "This pipeline has finished successfully!!! Have a cookie."
    pipeline_graph_output = p.FLAG_PATH + "/pipeline_" + sample + "_" + str(date) + ".pdf"
    #pipeline_printout_graph (pipeline_graph_output,'pdf', step, no_key_legend=False)
    stage = "last_function"
    flag_file = "%s/%s_%s_completed.flag" % (p.FLAG_PATH, stage, sample)
    open(flag_file, 'w').close()
    return   


if __name__ == '__main__':

        pipeline_run(p.STEP, multiprocess = p.PIPE_MULTIPROCESS, verbose = p.PIPE_VERBOSE, gnu_make_maximal_rebuild_mode = p.PIPE_REBUILD)




