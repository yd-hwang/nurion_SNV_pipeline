#!/bin/sh
#PBS -V
#PBS -N py_plot.sh
#PBS -q normal
#PBS -A etc
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1
#PBS -l walltime=04:00:00

cd $PBS_O_WORKDIR

python plot.py