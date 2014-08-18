#PBS -M adavisr@ufl.edu
#PBS -m abe
#PBS -q default
#PBS -l pmem=256mb
#PBS -l walltime=00:02:00
#PBS -l nodes=1:ppn=1

set -e
set -x

cd $PBS_O_WORKDIR


QUAL_TYPE='sanger'

echo "PBS_ARRAYID=$PBS_ARRAYID"
echo "INPUT=$INPUT"
echo "QUAL_TYPE=$QUAL_TYPE"

# define INPUT or run with -t
if [[ -z $INPUT ]]; then
  echo "Batch Mode"
  echo "Array ID = $PBS_ARRAYID"
  INPUT=$(find . -name *B_"$PBS_ARRAYID".fastq)
else
  echo "Single Mode"
fi

echo "Final input: $INPUT"

date

cat $INPUT \
  | sickle pe --quiet \
    -c /dev/stdin \
    -t $QUAL_TYPE \
    -s /dev/null \
    -m /dev/stdout \
    -x \
   | fastq-to-fasta \
   | rc-right-read \
   > $(basename $INPUT .fastq).preprocessed.fasta

touch $(basename $INPUT .fastq).preprocessed.complete

date
