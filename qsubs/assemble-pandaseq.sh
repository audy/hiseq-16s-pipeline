#!/bin/bash

#PBS -q default
#PBS -M triplettlab@gmail.com
#PBS -l pmem=1Gb
#PBS -l walltime=00:05:00
#PBS -l nodes=1:ppn=1
#PBS -j oe

module load pandaseq

set -x
set -e

cd $PBS_O_WORKDIR

#
# usage:
# qsub -v input=input.fastq assemble-pandaseq.qsub
#
# or
# qsub -t 1-100 assemble-pandaseq.qsub
#

forward=$(basename $input .fastq).forward.fastq
reverse=$(basename $input .fastq).reverse.fastq

# 1. fix header & deinterleave fastq file

cat $input \
 | fix-header-for-pandaseq /dev/stdin \
 | deinterleave-fastq < /dev/stdin $forward $reverse

# 2. Assemble w/ Pandaseq

pandaseq \
	-f $forward \
	-r $reverse \
	-w /dev/stdout \
	-d s \
	| ./replace-fasta-id $* \
		> $@

rm $*-forward.fastq
rm $*-reverse.fastq
