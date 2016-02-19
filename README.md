# omics_pipe_platypus

Running Platypus Pipeline:

The platypus pipeline can be run using the omics_pipe custom setting and adjusting the parameter file fq2snv_test-parameters.yaml (in /root/src/omics-pipe/omics_pipe/parameters).  This pathogen based sequencing pipeline can accommodate multiple pathogens (currently Plasmodium falciparum, Plasmodium vivax, Plasmodium berghei, and Leptospira interrogans).  The development of this software is described in the following paper:

Manary, et al. “Identification of pathogen genomic variants through an integrated pipeline.” BMC Bioinformatics (2014) 15:63. DOI: 10.1186/1471-2015-15-63

Platypus requires an input of either single or paired end read fastq files, as well as a suitable reference set.  

Create Reference Folder for Platypus:

Currently, we have supplied references for P. falciparum, P. vivax, P. bergehei, and L. interrogans.  To create a new reference, follow the following steps:

1.)	download the .fasta file for the reference of interest as well as the .gff file
2.)	create the .dict file:
	a.	java –jar picard/CreateSequenceDictionary.jar R=<filename.fasta> O=<newfile.dict>
3.)	create fai file:
	a.	samtools faidx <filename.fasta>
4.)	index the fasta file:
	a.	bwa index <filename.fasta>
5.)	create a chromlist file:
	a.	awk '$1 ~ /^>/ {gsub(/^>/,"",$1);print $1}' <filename.fasta> > <filename.chromlist>
6.)	create a genelist file: 
	a.	awk '$3 ~ /gene/ {print $1, $4, $5, $9, $9}' <filename.gff> | awk '{gsub(/.*Name=/,"",$4);gsub(/.*description=/,"",$5);print $0}' | awk '{gsub(/;.*/,"",$4);gsub(/;.*/,"",$5);print $1" "$2" "$3" @"$4" "$5 }' > <filename.genelist>
7.)	create a known.vcf file
	a.	If you have a known SNP file, you can supply it here in a vcf format.  If not, copy any of the other known.vcf files into your reference folder, renaming it to match your reference.  DO NOT copy the vcf.idx file.  This will not allow the pipeline to accept the known.vcf file.  The idx file will be generated the first time a sample is aligned to the reference. 

Save all of these files in the platypus_reference folder supplied in the /data/database folder.  

Finally, you will need to add the reference to the snpEff.config file located in /root/src/omics-pipe/omics_pipe/scripts/.  To do this, go into the snpEff.config file and on line 17 where it says “genomes : l_int, p_ber, p_fal, p_viv” add your genome in the same syntax (first initial genus + “_” first three initial species).  Next, lower down in the “Databases & Genomes” section, create an entry for your reference.  For example, the Plasmodium berghei genome (first one referenced) has the following:

# Plasmodium berghei 
p_ber.genome : Plasmodium_berghei

Follow this format for your reference.  It will need a hashtag title, followed by the name of your .genome file.  Please note, the .genome file is not necessary to be in your reference folder for snpEff to function.

After you have adjusted the snpEff.config file, you will need to create a folder for your genome in the snpEff data folder.  The snpEff data folder is located at /data/database/platypus_references/data/.  In this data folder, create a folder named identically to the .genome file (so, for the example above, you would create a p_ber folder).  Next, copy the .gff for your genome into this newly created folder, renaming it “genes.gff.”  Once the gff file is in the data folder, you will need to build your own database from your own reference.  Move to the folder where snpEff.jar is.  Below is an example for the p_ber genome:

java –jar snpEff.jar build –gff 3 –v p_ber  

Please note, if you wish to use a database for your reference supplied by snpEff, you can use the following code instead:

java –jar snpEff.jar download –v p_ber


Loading fastq files for Platypus:

To run files on the platypus, you will need to load your fastq files into an accessible folder.  You will refer to their location in the parameters file.  In the parameters example, the files were loaded into /data/data/test_data/.


Adjust parameters file for files:

Adjust the parameter file for your samples.  Please note, your fastq files need to be named as your sample list name + _1.fastq based on if you are running paired end or single end reads.   (ex: TEST 11895_3D7_1.fastq, TEST_11895_3D7_2.fastq).  Examples for each parameter are indicated on the right.  

Run the Platypus:

Once the files have been uploaded, the parameter file adjusted, and the reference folder generated (if needed), use the custom setting to run the platypus pipeline:

omics_pipe custom --custom_script_path ~/path/to/script --custom_script_name script_name ~/path/to/parameter/file/file.yaml


Example:
omics_pipe custom --custom_script_path /root/src/omics_pipe_platypus --custom_script_name fq2snv /root/src/omics_pipe_platypus/parameters/fq2snv_test-parameters.yaml



