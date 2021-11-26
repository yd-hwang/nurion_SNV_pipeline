#!/bin/sh
#PBS -N bwa.sh
#PBS -V
#PBS -q normal
#PBS -A bwa
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1

cd $PBS_O_WORKDIR

# make directory & bwa mem
if [ ! -d ./result ]; then
	mkdir -p ./result
fi

cd ./result

for threads in {1..10}
do
	StartTime=$(date +%s.%N)
	filename=bwa_mem$threads
	~/anaconda3/envs/bwa/bin/bwa mem -t $threads /scratch/a1428a01/project/14/data/Homo_sapiens_assembly38_chr1.fasta /scratch/a1428a01/project/14/data/NA12878.R1.fastq /scratch/a1428a01/project/14/data/NA12878.R2.fastq > $filename.sam
	EndTime=$(date +%s.%N)
	runtime=$(python -c "print(${EndTime} - ${StartTime})")
	echo $filename ":" $runtime >> TimeCheck.bwa_mem.txt
done

for threads in {1..10}
do
	StartTime=$(date +%s.%N)
	filename=bwa_mem2_$threads
	~/anaconda3/envs/bwa/bin/bwa-mem2 mem -t $threads /scratch/a1428a01/project/14/data/Homo_sapiens_assembly38_chr1.fasta /scratch/a1428a01/project/14/data/NA12878.R1.fastq /scratch/a1428a01/project/14/data/NA12878.R2.fastq > $filename.sam
	EndTime=$(date +%s.%N)
	runtime=$(python -c "print(${EndTime} - ${StartTime})")
	echo $filename ":" $runtime >> TimeCheck.bwa_mem2.txt
done
