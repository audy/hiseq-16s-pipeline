#!/bin/bash

#PBS -q submit
#PBS -M adavisr@ufl.edu
#PBS -m abe
#PBS -l mem=600mb
#PBS -l walltime=00:60:00
#PBS -l nodes=1:ppn=1
#PBS -N usearch
#PBS -j oe

set -e

#
# Run a single usearch query.
#
# for example:
# qsub -v QUERY=sequences.fasta,DATABASE=gg135.97_otus.udb,IDENTITY=0.97,BASEDIR=/scratch/lfs/sequences usearch_array.qsub
#


cd $BASEDIR

UC_FILE="${QUERY}.uc"

echo "started     => $(date)"
echo "job id      => $PBS_JOBID"
echo "query       => $QUERY"
echo "identity    => $IDENTITY"
echo "output (uc) => $UC_FILE"
echo "database    => $DATABASE"
echo "base dir    => $BASEDIR"

touch $QUERY.running

usearch \
  --usearch_local $QUERY \
  --id $IDENTITY \
  --uc $UC_FILE \
  --strand plus \
  --threads 1 \
  --db $DATABASE

mv $QUERY.running $QUERY.completed
