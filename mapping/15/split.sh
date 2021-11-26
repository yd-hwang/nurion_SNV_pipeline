#!/bin/sh
#PBS -N split.sh
#PBS -V
#PBS -q normal
#PBS -A etc
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1
#PBS -l walltime=12:00:00

cd $PBS_O_WORKDIR

# make directory & split Homo_sapiens_assembly38.fasta file
if [ ! -d ./data ] ; then
        mkdir -p ./data
        cd ./data
        ln -s ~/data/gatk_bundle/Homo_sapiens_assembly38.fasta Homo_sapiens_assembly38.fasta
        csplit Homo_sapiens_assembly38.fasta /chr/ {*}
        rm xx00
        for var in xx*
        do
                chromosome=$(grep 'chr' $var | cut -f 1 -d ' ' | sed 's/^.//')
		mv $var $chromosome.fasta
        done
	# move files to use
	if [ ! -d ./reference ] ; then
		mkdir -p ./reference
		mv chr{1..22}.fasta chrX.fasta chrY.fasta ./reference
	fi
	# remove unnecessary files
	rm chr*
        # WGS data
        ln -s /scratch/a1428a01/project/13/data/NA12878.fastq NA12878.fastq
        ln -s /scratch/a1428a01/project/13/data/NA12878.R1.fastq NA12878.R1.fastq
        ln -s /scratch/a1428a01/project/13/data/NA12878.R2.fastq NA12878.R2.fastq
fi
