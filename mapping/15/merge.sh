#!/bin/sh
#PBS -N merge.sh
#PBS -V
#PBS -q normal
#PBS -A etc
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1
#PBS -l walltime=12:00:00

cd $PBS_O_WORKDIR

cd ./data/samfile

# make directory
if [ ! -d ../bamfile ] ; then
	mkdir -p ../bamfile
fi

# convert SAM to BAM
cnt=1
for samfile in *.sam
do
	echo -e "\033[43;31mNumber of files in progress: $cnt\033[0m"
	chr=$(echo $samfile | sed 's/.sam//g')
	~/anaconda3/envs/bwa/bin/samtools view -Sb $samfile > $chr.bam
	cnt=$((cnt+1))
done

# moves bamfiles
mv *.bam ../bamfile

cd ../bamfile
# merge bamfiles
~/anaconda3/envs/bwa/bin/samtools merge merged.bam *.bam
