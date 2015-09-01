#PBS -q default
#PBS -M triplettlab@gmail.com
#PBS -m abe
#PBS -l pmem=8Gb
#PBS -l walltime=08:00:00
#PBS -l nodes=1:ppn=1
#PBS -N count-taxonomies
#PBS -j oe

cd $PBS_O_WORKDIR
# 70 - hiseq
MINLEN=350 # 350 - for miseq

OUTPUT="$(basename $INPUT .uc.gz).minlen${MINLEN}.csv.gz"

zcat $INPUT \
 | hp-count-taxonomies \
    --min-length ${MINLEN} \
    --uc-file /dev/stdin \
    --output /dev/stdout \
    | gzip > $OUTPUT
