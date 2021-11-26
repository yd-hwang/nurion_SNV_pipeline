#!/bin/sh
#PBS -N serial_job
#PBS -V
#PBS -q normal
#PBS -A bwa
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1

cd $PBS_O_WORKDIR

input_bam=$1

# bam file indexing
samtools sort ONC_99.bam > ONC_99.sorted.bam
samtools index ONC_99.sorted.bam

mkdir sampling_bam

# bam file sampling
for i in {10..100..10}
   do
   j=`echo "scale=1;$i/100" | bc`
   echo $j
   samtools view -s $j -b ONC_99.sorted.bam > sampling/ONC_99.p$i.bam

done
