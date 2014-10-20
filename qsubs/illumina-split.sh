#PBS -M triplettlab@gmail.com
#PBS -m abe
#PBS -q default
#PBS -l pmem=2Gb
#PBS -l walltime=20:00:00
#PBS -l nodes=1:ppn=2
#PBS -j oe

#
# REQUIRED ENVIRONMENT VARIABLES
#
# - LEFT_READS   - location of left reads
# - BC_READS     - location of barcode reads
# - RIGHT_READS  - location of right reads
# - BARCODES     - location of barcodes file
# - EXPERIMENT   - prefix for output and sample id
#

#
# EXAMPLE
#
# qsub -v BARCODES='my-barcodes.csv' \
#      -v LEFT_READS='left-reads.fastq.gz' \
#      -v RIGHT_READS='right-reads.fastq.gz' \
#      -v BC_READS='bc-reads.fastq.gz' \
#      -v EXPERIMENT='poop-experiment'


set -e
set -x

date

cd $PBS_O_WORKDIR

OUTPUT_DIRECTORY=${EXPERIMENT}-samples

mkdir -p $OUTPUT_DIRECTORY

hp-label-by-barcode \
  --barcodes $BARCODES \
  --reverse-barcode \
  --complement-barcode \
  --left-reads ${LEFT_READS} \
  --right-reads ${RIGHT_READS} \
  --barcode-reads ${BC_READS} \
  --bc-seq-proc 'lambda b: b[0:7]' \
  --output-format fastq \
  --gzip \
  --id-format "${EXPERIMENT}.B.%(sample_id)s %(index)s orig_bc=%(bc_seq)s new_bc=%(bc_seq)s bc_diffs=0" \
  --output /dev/stdout |
hp-split-by-barcode \
  --output-directory ${EXPERIMENT}-samples

touch "${EXPERIMENT}".split.completed
