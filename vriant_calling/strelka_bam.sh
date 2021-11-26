#!/bin/sh
#PBS -N strelka_bam
#PBS -V
#PBS -q normal
#PBS -A bwa
#PBS -l select=1:ncpus=64:mpiprocs=1:ompthreads=64

cd $PBS_O_WORKDIR

normal_list=/scratch/a1428a01/project/19/path.NA12877.bam.txt
tumor_list=/scratch/a1428a01/project/19/path.NA12878.bam.txt

mkdir normal_link
mkdir tumor_link
mkdir strelka

cat $normal_list $tumor_list | while read line
do
        name=`basename $line`
        if [[ "$name" == "NA12877"* ]]; then
                ln -s $line normal_link/$name
                samtools index normal_link/$name
        else
                ln -s $line tumor_link/$name
                samtools index tumor_link/$name
        fi
done

# strelka variant calling
range=`seq 1 22 && echo "X" && echo "Y"`
for i in $range
do
        normal_bam=normal_link/NA12877.chr$i.bam
        tumor_bam=tumor_link/NA12878.chr$i.bam
        reference=/home01/a1426a01/hg/Homo_sapiens_assembly38.fasta

        /home01/a1426a01/strelka-2.9.10.centos6_x86_64/bin/configureStrelkaSomaticWorkflow.py \
                --normalBam $normal_bam \
                --tumorBam $tumor_bam \
                --referenceFasta $reference\
                --runDir strelka/somatic_chr$i
        strelka/somatic_chr$i/runWorkflow.py -m local -j 20
done
                                          