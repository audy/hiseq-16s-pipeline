#!/bin/bash

#PBS -q default
#PBS -M triplettlab@gmail.com
#PBS -l pmem=4Gb
#PBS -l walltime=01:00:00
#PBS -l nodes=1:ppn=1
#PBS -N usearch-array
#PBS -j oe

set -e

#
# Can be run with -t:
#
# for example:
# qsub -t 1-10 DATABASE=gg135.97_otus.udb usearch_array.qsub
#
#
# Or by specifying the query
# qsub -v QUERY=..,DATABASE=.. usearch_array.qsub
#

set -x

IDENTITY=0.97

cd $PBS_O_WORKDIR

STRAND='plus'

# define INPUT or run with -t
if [[ -z $QUERY ]]; then
  QUERY=$(find . -name *B_"$PBS_ARRAYID"-assembled.fasta)
else
  echo "Single file mode!"
fi

UC_FILE=$(basename $QUERY .fasta).${PBS_JOBNAME}.uc

echo "query       => $QUERY"
echo "identity    => $IDENTITY"
echo "output (uc) => $UC_FILE"
echo "database    => $DATABASE"


usearch \
  --usearch_local $QUERY \
  --id $IDENTITY \
  --uc $UC_FILE \
  --strand $STRAND \
  --threads 1 \
  --query_cov 0.95 \
  --db $DATABASE

touch $(basename $UC_FILE .uc).${PBS_JOBNAME}.complete
