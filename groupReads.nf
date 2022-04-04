#!/usr/bin/env nextflow

nextflow.enable.dsl=2

/*  Comments are uninterpreted text included with the script.
    They are useful for describing complex parts of the workflow
    or providing useful information such as workflow usage.

    Usage:
       nextflow run count_lines.nf --input <input_file>

    Multi-line comments start with a slash asterisk /* and finish with an asterisk slash. */
//  Single line comments start with a double slash // and finish on the same line

/*  Workflow parameters are written as params.<parameter>
    and can be initialised using the `=` operator. */

/*
================================================================================
                                  nf-core/pfvar
================================================================================
Started March 2016.
Ported to nf-core MM-YYYY.
--------------------------------------------------------------------------------
nf-core/pfvar:
  An open-source analysis pipeline to detect P.falciparum variants (SNPs) in
  known anti-malarial drug resistance genes from targeted deep amplicon
  sequencing
--------------------------------------------------------------------------------
 @Homepage
  @link
--------------------------------------------------------------------------------
 @Documentation
 https://nf-co.re/pfvar/docs
--------------------------------------------------------------------------------
*/

/*Define default input for data path; can be overriden by user via giving
nextflow run GroupReads.nf --input "[path/to/data]" */
params.input = "data/*_{R1,R2}*.fastq.gz"

/*  A Nextflow process block
    Process names are written, by convention, in uppercase.
    This convention is used to enhance workflow readability. */
process GROUP_READS {
// copy results in dir called groupedReads matching glob pattern
    publishDir "groupedReads/", pattern: "*.fastq", mode: "copy"
// input has to be a tuple x() y() given the fromFilePairs method
// x=sample_id; is the * part of glob pattern
// y=reads; list of files matching the remaining <string>_{1,2}.fastq.gz
    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}_R1.fastq.gz"), path("${sample_id}_R2.fastq.gz")

    script:
    /* Triple quote syntax """, Triple-single-quoted strings may span multiple lines. The content of the string can cross line boundaries without the need to split the string in several pieces and without concatenation or newline escape characters. */
    """
    cat *R1*.fastq.gz > ${sample_id}_R1.fastq.gz
    cat *R2*.fastq.gz > ${sample_id}_R2.fastq.gz
    """

}

input_reads= Channel.fromFilePairs(params.input, size:-1)
//See https://www.nextflow.io/docs/latest/channel.html#fromfilepairs
//Match files using glob pattern and accept any # of files (-1)

workflow {

  GROUP_READS(input_reads)
  //GROUP_READS.out.view()

}
