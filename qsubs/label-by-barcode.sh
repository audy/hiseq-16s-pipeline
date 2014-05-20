#PBS -M triplettlab@gmail.com
#PBS -m abe
#PBS -q default
#PBS -l pmem=2018mb
#PBS -l walltime=20:00:00
#PBS -l nodes=1:ppn=1

EXPERIMENT='miseq' # name of the experiment

SCRATCH='/scratch/lfs/adavisr' # location of your scratch directory

##
# INPUT FILES
#

# barcode list
BARCODE_FILE="$SCRATCH/combination-golay-triplett-barcodes-for-pipeline.csv"

# sequences
LEFT_READS="$SCRATCH/UF_TMST/Undetermined_S0_L001_R1_001.fastq.gz"
BC_READS="$SCRATCH/UF_TMST/Undetermined_S0_L001_I1_001.fastq.gz"
RIGHT_READS="$SCRATCH/UF_TMST/Undetermined_S0_L001_R2_001.fastq.gz"

# output for labelled by barcode
LABELLED_OUT="$SCRATCH/miseq-labelled.fastq"

# output for split by barcode
SPLIT_OUT="$scratch/miseq-split"

module load python/2.7.6

# takes raw illumina FASTQ files
# and labels them by barcode
hp-label-by-barcode \
  --barcodes $BARCODE_FILE \
  --reverse-barcode \
  --complement-barcode \
  --left-reads $LEFT_READS \
  --barcode-reads $BC_READS \
  --right-reads $RIGHT_READS \
  --output $LABELLED_OUT \
  --id-format "${EXPERIMENT}.B.%(sample_id)s %(index)s orig_bc=%(bc_seq)s new_bc=%(bc_seq)s bc_diffs=0" \
  --output-format fastq \
  --gzip

# split labelled fastq file by barcode
hp-split-by-barcode \
  --input $LABELLED_OUT \
  --format fastq \
  --output-directory $SPLIT_OUT
