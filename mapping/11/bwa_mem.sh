#!/bin/sh
#PBS -N bwa_mem.sh
#PBS -V
#PBS -q normal
#PBS -A bwa
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1
#PBS -l walltime=04:00:00

cd $PBS_O_WORKDIR

for threads in {1..10}
do
	StartTime=$(date +%s.%N)
	filename=samfile$threads
	~/anaconda3/envs/bwa/bin/bwa mem -t $threads ~/data/gatk_bundle/Homo_sapiens_assembly38.fasta ~/data/testdata-master/100k_reads_hiseq/TESTX/TESTX_H7YRLADXX_S1_L001_R1_001.fastq ~/data/testdata-master/100k_reads_hiseq/TESTX/TESTX_H7YRLADXX_S1_L001_R2_001.fastq > $filename
	EndTime=$(date +%s.%N)
	runtime=$(python -c "print(${EndTime} - ${StartTime})")
	echo $filename ":" $runtime >> TimeCheck.txt
done

