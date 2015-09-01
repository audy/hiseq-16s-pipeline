#!/bin/bash

#PBS -q default
#PBS -M triplettlab@gmail.com
#PBS -l pmem=4Gb
#PBS -l walltime=06:00:00
#PBS -l nodes=1:ppn=1
#PBS -j oe

set -x
set -e

cd $PBS_O_WORKDIR

uclust \
  --input $PBS_JOBNAME \
  --id ${identity:=0.97} \
  --maxaccepts ${max_accepts:=1} \
  --maxrejects ${max_rejects:=1} \
  --band ${band_radius:=1} \
  --uc ${out:=${PBS_JOBNAME}.uc} \
  --nowordcountreject \
  --allhits \
  --usersort
