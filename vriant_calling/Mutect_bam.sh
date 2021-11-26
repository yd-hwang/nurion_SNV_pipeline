#!/bin/sh
#PBS -N Mutect2
#PBS -V
#PBS -q normal
#PBS -A bwa
#PBS -l select=1:ncpus=64:mpiprocs=1:ompthreads=64

cd $PBS_O_WORKDIR

mkdir normal_link
mkdir tumor_link
normal_list=/scratch/a1428a01/project/19/path.NA12877.bam.txt
tumor_list=/scratch/a1428a01/project/19/path.NA12878.bam.txt

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

range=`seq 1 22 && echo 'X' && echo "Y"`
for i in $range
do
        qsub -v num=$i /scratch/a1426a01/Mutect2.sh
done

