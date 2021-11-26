#!/bin/sh
#PBS -N split.sh
#PBS -V
#PBS -q normal
#PBS -A bwa
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1
#PBS -l walltime=12:00:00

cd $PBS_O_WORKDIR

# make directory & split Homo_sapiens_assembly38.fasta file
if [ ! -d ./data ] ; then
	mkdir -p ./data
	cd data
	ln -s ~/data/gatk_bundle/Homo_sapiens_assembly38.fasta Homo_sapiens_assembly38.fasta
	csplit Homo_sapiens_assembly38.fasta /chr/ {*}
	mv xx01 Homo_sapiens_assembly38_chr1.fasta
	rm xx*
	# bwa index
	~/anaconda3/envs/bwa/bin/bwa index Homo_sapiens_assembly38_chr1.fasta
	# bwa-mem2 index
	~/anaconda3/envs/bwa/bin/bwa-mem2 index Homo_sapiens_assembly38_chr1.fasta
	# WGS data
	ln -s /scratch/a1428a01/project/13/data/NA12878.fastq NA12878.fastq
	ln -s /scratch/a1428a01/project/13/data/NA12878.R1.fastq NA12878.R1.fastq
	ln -s /scratch/a1428a01/project/13/data/NA12878.R2.fastq NA12878.R2.fastq
fi
