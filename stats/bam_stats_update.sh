#!/bin/sh
#PBS -V
#PBS -N bam_stats_update.sh
#PBS -q normal
#PBS -A etc
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1
#PBS -l walltime=04:00:00

cd $PBS_O_WORKDIR

input=bwa_mem.bam # input BAM file
output=result_sh2.txt # output text file

# name column
echo "file size (MB)" > name_col.txt
/home01/a1430a01/anaconda3/bin/samtools stats $input | grep '^SN' | cut -f 1 -d ':' | cut -f2 >> name_col.txt

# value column
ls -lh $input | awk '{print $5}' | sed 's/[^0-9]//g' > value_col.txt
/home01/a1430a01/anaconda3/bin/samtools stats $input | grep '^SN' | cut -f3 >> value_col.txt

# output text file
paste name_col.txt value_col.txt > $output
rm name_col.txt
rm value_col.txt