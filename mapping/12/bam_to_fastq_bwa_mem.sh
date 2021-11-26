#!/bin/sh
#PBS -N bam_to_fastq_bwa_mem.sh
#PBS -V
#PBS -q normal
#PBS -A bwa
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1
#PBS -l walltime=12:00:00

cd $PBS_O_WORKDIR

~/anaconda3/envs/bwa/bin/samtools fastq /scratch/a1428a01/data/test_bam/ONC_99.bam > ONC_99.fastq

if [ ! -d ./data ]; then
        mkdir -p ./data
	mv ONC_99.fastq ./data
fi

# make directory & bwa_mem
if [ ! -d ./result ]; then
	mkdir -p ./result
fi

cd ./result

for threads in {1..10}
do
        StartTime=$(date +%s.%N)
        filename=samfile$threads
        ~/anaconda3/envs/bwa/bin/bwa mem -t $threads ~/data/gatk_bundle/Homo_sapiens_assembly38.fasta ../data/ONC_99.fastq > $filename
        EndTime=$(date +%s.%N)
        runtime=$(python -c "print(${EndTime} - ${StartTime})")
        echo $filename ":" $runtime >> TimeCheck.txt
done
