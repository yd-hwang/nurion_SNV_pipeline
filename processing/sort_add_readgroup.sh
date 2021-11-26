#!/bin/sh
#PBS -V
#PBS -N serial_job
#PBS -q normal
#PBS -A etc
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1
#PBS -l walltime=04:00:00


cd $PBS_O_WORKDIR

# sort bam file using picard & add Readgroup using picard AddOrReplaceReadGroups

# input bam file
input_bam=$VAL.bam
# location of picard.jar
picard_loc=/home01/a1427a01/picard_dir/picard.jar

# sort bam file
java -jar $picard_loc SortSam \
        I=$input_bam \
        O=$VAL.sorted.bam \
        SO=coordinate

# add ReadGroup
java -jar $picard_loc AddOrReplaceReadGroups \
        I=$VAL.sorted.bam \
        O=$VAL.sorted.RGadded.bam \
        RGLB=Read-Group_libarary \
        RGPL=ILLUMINA \
        RGPU=Read-Group_platform \
        RGSM=Read-Group_sample_name

# remove unnecessary file
rm -rf $VAL.sorted.bam
