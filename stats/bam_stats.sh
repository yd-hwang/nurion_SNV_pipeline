#!/bin/sh
#PBS -V
#PBS -N bam_stats.sh
#PBS -q normal
#PBS -A etc
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1
#PBS -l walltime=04:00:00

cd $PBS_O_WORKDIR

input=bwa_mem.bam # input BAM file
output=result_sh1.txt # output text file

# BAM file size
echo "# BAM file size" >> $output
ls -lh $input | awk '{print $5}' >> $output

# SN(Summary Number) information in samtools stats
echo "# SN information" >> $output
/home01/a1430a01/anaconda3/bin/samtools stats $input | grep '^SN' >> $output