#!/bin/sh
#PBS -N serial_job
#PBS -V
#PBS -q normal
#PBS -A bwa
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1

cd $PBS_O_WORKDIR

#install anaconda3
wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh

chmod +x Anaconda3-2021.05-Linux-x86_64.sh
./Anaconda3-2021.05-Linux-x86_64.sh

rm Anaconda3-2021.05-Linux-x86_64.sh

#set conda
conda create -n py3.8 python=3.8 --yes
conda activate py3.8

#install bwa
conda install -c bioconda bwa --yes

