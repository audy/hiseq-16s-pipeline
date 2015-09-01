#!/bin/bash

# miseq overlapping 16S rRNA pipeline

# - agdr

#PBS -q default
#PBS -M adavisr@ufl.edu
#PBS -m abe
#PBS -l pmem=512Mb
#PBS -l walltime=100:00:00
#PBS -l nodes=1:ppn=48
#PBS -j oe

set -e

cd $PBS_O_WORKDIR

directory="${PBS_JOBNAME}"

# label reads by barcode

# bad idea? filename formats change.
left_reads=$(find $directory -name "*R1*.fastq.gz")
right_reads=$(find $directory -name "*T1*.fastq.gz")
bc_reads=$(find $directory -name "*R2*.fastq.gz")

# assemble reads using pandaseq
  # - convert to something pandaseq-friendly
# split reads into chunks
# map chunks to database using usearch
# combine output
# generate OTU tables
# generate rank tables for the plebs
