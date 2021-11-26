#!/bin/sh
#PBS -N convert_paired.sh
#PBS -V
#PBS -q normal
#PBS -A bwa
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1
#PBS -l walltime=12:00:00

cd $PBS_O_WORKDIR

cd ./data

# convert cram file into fastq file (paired reads)
~/anaconda3/envs/bwa/bin/samtools fastq -s NA12878.fastq --reference /scratch/a1428a01/data/gatk_bundle/Homo_sapiens_assembly38.fasta -1 NA12878.R1.fastq -2 NA12878.R2.fastq NA12878.sorted.cram

