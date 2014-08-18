#PBS -q default
#PBS -M triplettlab@gmail.com
#PBS -m abe
#PBS -l pmem=8Gb
#PBS -l walltime=08:00:00
#PBS -l nodes=1:ppn=1
#PBS -N count-taxonomies
#PBS -j oe

cd $PBS_O_WORKDIR

MINLEN=245 # longer for miseq

cat *.uc \
 | hp-count-taxonomies \
    --min-len ${MINLEN} \
    --uc-file /dev/stdin \
    --output /dev/stdout \
    | gzip > "$(basename $INPUT .uc.gz).minlen${MINLEN}.csv.gz"
