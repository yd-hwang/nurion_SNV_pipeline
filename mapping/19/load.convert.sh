#!/bin/sh
#PBS -N load.convert.sh
#PBS -V
#PBS -q normal
#PBS -A bwa
#PBS -l select=1:ncpus=64:mpiprocs=1:ompthreads=64

cd $PBS_O_WORKDIR

# make directory & symbolic link
if [ ! -d ./data ] ; then
        mkdir -p ./data
	cd ./data
	ln -s /scratch/a1430a01/NA12877.bam NA12877.bam
	ln -s /scratch/a1430a01/NA12878.bam NA12878.bam
fi

# samtools index
~/anaconda3/envs/bwa/bin/samtools index /scratch/a1428a01/project/19/data/NA12877.bam
~/anaconda3/envs/bwa/bin/samtools index /scratch/a1428a01/project/19/data/NA12878.bam

# convert cram file into bam file by chromosome number
for chr in chr{1..22} chrX chrY
do
	~/anaconda3/envs/bwa/bin/samtools view -hb /scratch/a1428a01/project/19/data/NA12877.bam $chr > NA12877.$chr.bam
	~/anaconda3/envs/bwa/bin/samtools view -hb /scratch/a1428a01/project/19/data/NA12878.bam $chr > NA12878.$chr.bam
done

# make directory & move BAM file
if [ ! -d ./NA12877 ] ; then
        mkdir -p ./NA12877
	mv NA12877.*.bam ./NA12877
fi

if [ ! -d ./NA12878 ] ; then
        mkdir -p ./NA12878
        mv NA12878.*.bam ./NA12878
fi
