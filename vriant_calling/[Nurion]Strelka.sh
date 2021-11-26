#!/bin/sh
#PBS -N serial_job
#PBS -V
#PBS -q normal
#PBS -A bwa
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1

cd $PBS_O_WORKDIR

conda create -n py2.7 python=2.7 --yes
conda activate py2.7

#strelka download
wget https://github.com/Illumina/strelka/releases/download/v2.9.10/strelka-2.9.10.centos6_x86_64.tar.bz2
tar -xvjf strelka-2.9.10.centos6_x86_64.tar.bz2
rm strelka-2.9.10.centos6_x86_64.tar.bz2

#germline calling
input_bam=CPS41-Br-1_L1.rename.bam

strelka-2.9.10.centos6_x86_64/bin/configureStrelkaGermlineWorkflow.py \
     --bam $input_bam \
     --referenceFasta Homo_sapiens_assembly38.fasta \
     --runDir germline

germline/runWorkflow.py -m local -j 20

#somatic calling
tumor=CPS58-Br-1_L1.add.bam

strelka-2.9.10.centos6_x86_64/bin/configureStrelkaSomaticWorkflow.py \
     --normalBam $input_bam \
     --tumorBam $tumor \
     --referenceFasta $reference\
     --runDir somatic

somatic/runWorkflow.py -m local -j 20
