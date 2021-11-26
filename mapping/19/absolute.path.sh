#!/bin/sh
#PBS -N absolute.path.sh
#PBS -V
#PBS -q normal
#PBS -A etc
#PBS -l select=1:ncpus=64:mpiprocs=1:ompthreads=64

cd $PBS_O_WORKDIR

# absoulte path of NA12877
for file in ./data/NA12877/NA12877.chr{1..22}.bam ./data/NA12877/NA12877.chrX.bam ./data/NA12877/NA12877.chrY.bam
do
	path=$(readlink -f $file)
	echo $path >> path.NA12877.bam.txt
done

# absolute path of NA12878
for file in ./data/NA12878/NA12878.chr{1..22}.bam ./data/NA12878/NA12878.chrX.bam ./data/NA12878/NA12878.chrY.bam
do
        path=$(readlink -f $file)
        echo $path >> path.NA12878.bam.txt
done
