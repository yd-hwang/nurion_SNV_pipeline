#!/bin/sh
#PBS -N bwa-mem2.sh
#PBS -V
#PBS -q normal
#PBS -A etc
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1

cd $PBS_O_WORKDIR

cd ./data
#bwa-mem2 index & bwa-mem2 mem
cd ./reference
cnt=1
for reference in chr{1..22}.fasta chrX.fasta chrY.fasta
do
	echo -e "\033[43;31mNumber of files in progress: $cnt\033[0m"
        chr=$(basename /scratch/a1428a01/project/15/data/reference/$reference .fasta)
       	~/anaconda3/envs/bwa/bin/bwa-mem2 index /scratch/a1428a01/project/15/data/reference/$reference
       	~/anaconda3/envs/bwa/bin/bwa-mem2 mem -t 10 /scratch/a1428a01/project/15/data/reference/$reference /scratch/a1428a01/project/15/data/NA12878.R1.fastq /scratch/a1428a01/project/15/data/NA12878.R2.fastq > $chr.sam
         cnt=$((cnt+1))
done

if [ ! -d ../samfile ] ; then
	 mkdir -p ../samfile
         mv *.sam ../samfile
fi
