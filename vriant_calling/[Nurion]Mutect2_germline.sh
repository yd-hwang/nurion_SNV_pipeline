#!/bin/sh
#PBS -N serial_job
#PBS -V
#PBS -q normal
#PBS -A bwa
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1
#PBS -m abe
#PBS -M gkscodms99@naver.com

cd $PBS_O_WORKDIR

#reference download
wget -m https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta
wget -m https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.fai
wget -m https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dict

mv storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/* .
rm -rf storage.googleapis.com

#variant calling
input_bam=CPS41-Br-1_L1.add.bam
reference=Homo_sapiens_assembly38.fasta

gatk --java-options "-Xmx16G" Mutect2 \
    -R $reference \
    -I $input_bam \
    -O CPS41.vcf.gz
