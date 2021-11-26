#!/bin/sh
#PBS -V
#PBS -N serial_job
#PBS -q normal
#PBS -A etc
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1
#PBS -l walltime=04:00:00

cd $PBS_O_WORKDIR

# preprocessing time check

# sort bam file
# add readgroup
# pcr duplicates
# local realignment
# recalibration

# input bam file
input_bam=$VAL.bam
# location of picard.jar
picard_loc=/home01/a1427a01/picard_dir/picard.jar


start_time=`date +%s.%N`
# sort bam file & fixmate process
samtools sort -n $input_bam | samtools fixmate -m - $VAL.fixmate.bam

samtools sort $VAL.fixmate.bam -o $VAL.fixmate.sorted.bam
rm -rf $VAL.fixmate.bam

end_time=`date +%s.%N`
diff=`echo "$end_time - $start_time" | bc`
echo "samtools_sort:$diff" >> time.txt


start_time=`date +%s.%N`
# add ReadGroup
samtools addreplacerg -r ID:rg_id -r LB:rg_library -r SM:rg_sm -r PL:rg_platform \
                        -m orphan_only $VAL.fixmate.sorted.bam -o $VAL.fixmate.sorted.RGadded.bam

end_time=`date +%s.%N`
diff=`echo "$end_time - $start_time" | bc`
echo "samtools_addreplacerg:$diff" >> time.txt

# remove ~.sorted.bam
rm -rf $VAL.fixmate.sorted.bam


start_time=`date +%s.%N`
# MarkDuplicates (remove duplicates)
samtools markdup -r $VAL.fixmate.sorted.RGadded.bam $VAL.fixmate.sorted.RGadded.marked.bam

end_time=`date +%s.%N`
diff=`echo "$end_time - $start_time" | bc`
echo "samtools_markdup:$diff" >> time.txt

# remove ~.sorted.RGadded.bam
rm -rf $VAL.fixmate.sorted.RGadded.bam

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

# remove ~.sorted.RGadded.marked.bam / recal.data.table
rm -rf $VAL.fixmate.sorted.RGadded.marked.bam
rm -rf recal_data.table
