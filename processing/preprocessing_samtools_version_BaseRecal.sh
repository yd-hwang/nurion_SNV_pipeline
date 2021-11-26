#!/bin/sh
#PBS -V
#PBS -N serial_job
#PBS -q long
#PBS -A etc
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1
#PBS -l walltime=120:00:00
#PBS -l select=1:ncpus=64:mpiprocs=1:ompthread=64

cd $PBS_O_WORKDIR

# BaseRecalibrator (make recalibration model)
fasta=/home01/a1427a01/datadrive/gatk_bundle/Homo_sapiens_assembly38.fasta
dbsnp=/home01/a1427a01/datadrive/gatk_bundle/dbsnp_138.hg38.vcf


start_time=`date +%s.%N`
# BaseRecalibrator
gatk BaseRecalibrator \
-I $VAL.fixmate.sorted.RGadded.marked.bam \
-R $fasta \
--known-sites $dbsnp \
-O recal_data.table

end_time=`date +%s.%N`
diff=`echo "$end_time - $start_time" | bc`
echo "BaseRecalibrator:$diff" >> time.txt

start_time=`date +%s.%N`
# ApplyBQSR (readjust quality score)
gatk ApplyBQSR \
-R $fasta \
-I $VAL.fixmate.sorted.RGadded.marked.bam \
--bqsr-recal-file recal_data.table \
-O $VAL.fixmate.sorted.RGadded.marked.recal.bam

end_time=`date +%s.%N`
diff=`echo "$end_time - $start_time" | bc`
echo "ApplyBQSR:$diff" >> time.txt

# remove recal.data.table
rm -rf recal_data.table
