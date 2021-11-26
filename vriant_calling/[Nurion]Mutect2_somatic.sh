#!/bin/sh
#PBS -N serial_job
#PBS -V
#PBS -q normal
#PBS -A bwa
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1

cd $PBS_O_WORKDIR

# gnomad download
wget -m https://storage.googleapis.com/gatk-best-practices/somatic-hg38/af-only-gnomad.hg38.vcf.gz
wget -m https://storage.googleapis.com/gatk-best-practices/somatic-hg38/af-only-gnomad.hg38.vcf.gz.tbi

mv storage.googleapis.com/gatk-best-practices/somatic-hg38/* .
rm -rf storage.googleapis.com

# Somatic variant calling

normal_bam=CPS41-Br-1_L1.rename.bam
tumor_bam=CPS58-Br-1_L1.add.bam

gatk --java-options "-Xmx16G" Mutect2 \
       -R Homo_sapiens_assembly38.fasta \
       -I $tumor_bam \
       -I $normal_bam \
       -normal CPS41-Br-1_L1 \
       --germline-resource af-only-gnomad.hg38.vcf.gz \
       -O somatic.vcf.gz

