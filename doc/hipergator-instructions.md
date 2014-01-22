# Hipergator Instructions

This is a basic tutorial for running USEARCH and generating output
tables for 16S rRNA sequencing data on the UF Hipergator.

This covers:

1. Installation of pipeline
2. Sending data to the Hipergator
3. Scratch directories
4. Running QSUB scripts
5. Parsing output to generate QIIME-like OTU tables
   for use with other bioinformatics tools.

## 1. Install the hiseq 16S pipeline

1. Download hiseq 16S pipeline using Git
   Git is a software to manage different versions of things.
   It is similar to MS Word's "track changes" except way nerdier.

```sh
git clone https://github.com/audy/hiseq-16s-pipeline.git
```

2. Add to `$PATH`

```sh
PATH="$PATH:hiseq-16s-pipeline/bin"
```

3. Test than you can run the software

```sh
hp-count-taxonomies-single -h
```

Should result in something like:

```sh
usage: hp-count-taxonomies-single [-h] [--uc-files [UC_FILES [UC_FILES ...]]]
                                  [--output OUTPUT]

optional arguments:
  -h, --help            show this help message and exit
  --uc-files [UC_FILES [UC_FILES ...]]
  --output OUTPUT
```

If not, something went wrong.

## 2. Upload data to Hipergator

SCP - *S*ecure *C*o*p*y. A tool used to securely send files to remote machines.

```sh
# To send a file to the HPC, run locally

scp localfile user@submit.hpc.ufl.edu:

# And enter your password.
# HINT: DO NOT FORGET THE COLON AT THE END!
```

## 3. Scratch Directories

The data you are actively running computations on must be stored in
a scratch directory. The scratch directory is an array of hard drives
shared by all of the computers (nodes) at the Hipergator.

Your scratch directory is located in `/scratch/lfs/<username>`

You must move your sequences and database to this directory first using `mv`

## 4. Run sequences through OTU picking pipeline

### Download database

Just copy my copy of the database into your personal scratch directory.

```sh
cp /scratch/lfs/adavisr/gg... /scratch/lfs/<username>
```

### Run USEARCH like this.

From your scratch directory.

```sh
qsub -v DATABASE=<database_file>,QUERY=<fasta_file>,IDENTITY=0.97,BASEDIR=$PWD ~/hiseq-16s-pipeline/qsubs/usearch.sh

# this can get a bit tedious to type 150 times so we're going to use a for-loop:

for file in *.fasta; do
  qsub -v DATABASE=<database_file>,QUERY=$query,IDENTITY=0.97,BASEDIR=$PWD ~/qsubs/scripts/usearch.sh
done

This will submit a separate job for each file that ends in `.fasta`
```

Running this command should print a number. You have to do this for each fasta file.

Verify the state of your job using the `stat -u <username>` command.

The job state should eventually change from `Q` to `R`. A job state of `C`
means `C`rashed or `C`omplete.

You can automate updating the job status with the `watch` command

```sh
# update the job status every 10 seconds.
watch -n 10 qstat -u <username>
```

## 5. Create an OTU table from the output files (`uc` files)

After all the jobs have finished running, we need to generate an OTU
table that can be read by SourceTracker.

SourceTracker uses output from a different tool for analyzing 16S
amplicons known as QIIME, so we need to pass the `--qiime` argument
to get a QIIME-like OTU table.

```sh
hp-count-taxonomies-single --qiime --input *.uc --output otu_table.txt
```

---

(The End!)[http://i.imgur.com/c9Ups.gif]
