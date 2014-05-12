#PBS -M triplettlab@gmail.com
#PBS -m abe
#PBS -q default
#PBS -l pmem=2048mb
#PBS -l walltime=20:00:00
#PBS -l nodes=1:ppn=8

#
# Preprocessing Pipeline:
#
# raw reads -> ...
# label by barcode -> ...
# quality trimming -> ...
# convert from fastq to fasta -> ...
# reverse-complement "right" read -> ...
# split into chunks to be clustered later
#

#
# REQUIRED ENVIRONMENT VARIABLES
#
# - EXPERIMENT   - name of the experiment
# - QUAL_TYPE    - type of quality scores
# - BARCODES     - location of barcodes file
# - LEFT_READS   - location of left reads
# - BC_READS     - location of barcode reads
# - RIGHT_READS  - location of right reads
#

#
# REQUIREMENTS
#
# These programs need to be in your $PATH
#
# - sickle
# - fastq-to-fasta
# - rc-right-read
# - hp-label-by-barcode
#

#
# EXAMPLE
#
# qsub -v EXPERIMENT='my-experiment' \
#      -v QUAL_TYPE='sanger' \
#      -v BARCODES='my-barcodes.csv' \
#      -v LEFT_READS='left-reads.fastq.gz' \
#      -v RIGHT_READS='right-reads.fastq.gz' \
#      -v BC_READS='bc-reads.fastq.gz'

#
# OTHER PARAMETERS
#

# locate of scratch directory
SCRATCH='/scratch/lfs/adavisr'

# number of sequences per split file
CHUNK_SIZE=100000

set -e
set -x

date

hp-label-by-barcode \
  --barcodes $BARCODES \
  --revcomp-barcode \
  --left-reads $LEFT_READS \
  --right-reads $RIGHT_READS \
  --barcode-reads $BC_READS \
  --output-format fastq \
  --gzip \
  --id-format "${EXPERIMENT}_B_%(barcode)s %(index)s" \
  --bc-seq-proc 'lambda b: b[0:7]' \
  --output /dev/stdout \
  | sickle pe --quiet \
    -c /dev/stdin \
    -t $QUAL_TYPE \
    -s /dev/null \
    -m /dev/stdout \
    -n 70 \
    -x \
    -n \
  | fastq-to-fasta \
  | rc-right-read \
  | hp-split-for-array \
     --fasta-file /dev/stdin \
     --chunk-size $CHUNK_SIZE \
     --directory $SCRATCH/$EXPERIMENT-split

date
