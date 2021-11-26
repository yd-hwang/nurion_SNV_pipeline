#!/bin/sh
#PBS -N Mutect2
#PBS -V
#PBS -q normal
#PBS -A bwa
#PBS -l select=1:ncpus=64:mpiprocs=1:ompthreads=64

cd $PBS_O_WORKDIR

#Mutect2 variant calling

normal_bam=/scratch/a1426a01/normal_link/NA12877.chr$num.bam
tumor_bam=/scratch/a1426a01/tumor_link/NA12878.chr$num.bam
reference=/home01/a1426a01/hg/Homo_sapiens_assembly38.fasta
resource=/home01/a1426a01/hg/af-only-gnomad.hg38.vcf.gz

gatk --java-options "-Xmx16G" Mutect2 \
     -R $reference \
     -I $tumor_bam \
     -I $normal_bam \
     -normal NA12877 \
     --germline-resource $resource \
     -O Mutect2/somatic_chr$num.vcf.gz

