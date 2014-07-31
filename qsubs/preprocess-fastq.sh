#PBS -M adavisr@ufl.edu
#PBS -m abe
#PBS -q default
#PBS -l pmem=2018mb
#PBS -l walltime=00:02:00
#PBS -l nodes=1:ppn=1

set -e

cd $PBS_O_WORKDIR

echo $PBS_ARRAYID
echo $INPUT

# define INPUT or run with -t
if [[ ! -z $PBS_ARRAYID ]]; then
  file_no=$(printf "%03i" $PBS_ARRAYID)
  echo "Batch Mode! t = $file_no"
  INPUT=$(find . -name *B_"$file_no".fastq)
else
  echo "Single file mode!"
fi

# trim

echo "Preprocessing $INPUT"

date

cat $INPUT \
  | sickle pe --quiet \
    -c /dev/stdin \
    -t $QUAL_TYPE \
    -s /dev/null \
    -m /dev/stdout \
    -x \
    -n 70 \
   | fastq-to-fasta \
   | rc-right-read \
   > $(basename $INPUT .fastq).preprocessed.fasta

touch $(basename $INPUT .fastq).preprocessed.complete

date
