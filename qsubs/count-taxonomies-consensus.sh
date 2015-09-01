#PBS -q default
#PBS -M triplettlab@gmail.com
#PBS -m abe
#PBS -l pmem=8Gb
#PBS -l walltime=08:00:00
#PBS -l nodes=1:ppn=1
#PBS -N count-taxonomies
#PBS -j oe

cd $PBS_O_WORKDIR

MINLEN=70 # longer for miseq
RANK=='Species'

OUTPUT="$(basename $INPUT .uc.gz).minlen${MINLEN}.consensus.csv.gz"

zcat $INPUT \
 | hp-count-taxonomies-consensus \
    --min-length ${MINLEN} \
    --rank $RANK \
    --taxonomies $TAXONOMIES \
    --uc-file /dev/stdin \
    --output /dev/stdout \
    | gzip > $OUTPUT
