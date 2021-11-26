#!/bin/sh
#PBS -N serial_job
#PBS -V
#PBS -q normal
#PBS -A etc
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1
#PBS -l walltime=04:00:00


cd $PBS_O_WORKDIR

# sam file sort using Picard

input=$1
output=$2

# location of picard.jar
picard_loc=/home01/a1427a01/picard_dir/picard.jar

# convert sam file to bam file
samtools view -Sb $input > input.bam

# picard SortSam
java -jar $picard_loc SortSam \
        I=input.bam \
        O=$output.bam \
        SORT_ORDER=coordinate

# convert sorted bam file to sam file
samtools view $output.bam > $output.sam

# delete unnecessary files
rm -rf $output.bam
rm -rf input.bam
