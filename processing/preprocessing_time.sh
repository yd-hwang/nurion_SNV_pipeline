#!/bin/sh
#PBS -V
#PBS -N serial_job
#PBS -q normal
#PBS -A etc
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1
#PBS -l walltime=04:00:00

cd $PBS_O_WORKDIR

# input bam file
input_bam=$VAL.bam
# location of picard.jar
picard_loc=/home01/a1427a01/picard_dir/picard.jar

start_time=`date +%s.%N`
# sort bam file
java -jar $picard_loc SortSam \
        I=$input_bam \
        O=$VAL.sorted.bam \
        SO=coordinate

end_time=`date +%s.%N`
diff=`echo "$end_time - $start_time" | bc`
echo "SortSam:$diff" >> time_1.txt


start_time=`date +%s.%N`
# add ReadGroup
java -jar $picard_loc AddOrReplaceReadGroups \
        I=$VAL.sorted.bam \
        O=$VAL.sorted.RGadded.bam \
        RGLB=Read-Group_libarary \
        RGPL=ILLUMINA \
        RGPU=Read-Group_platform \
        RGSM=Read-Group_samplename

end_time=`date +%s.%N`
diff=`echo "$end_time - $start_time" | bc`
echo "AddOrReplaceReadGroups:$diff" >> time_1.txt

# remove ~.sorted.bam
rm -rf $VAL.sorted.bam


start_time=`date +%s.%N`
# MarkDuplicates (remove duplicates)
java -jar $picard_loc MarkDuplicates REMOVE_DUPLICATES=true \
        I=$VAL.sorted.RGadded.bam \
        O=$VAL.sorted.RGadded.marked.bam \
        M=marked_dup_metrics.txt

end_time=`date +%s.%N`
diff=`echo "$end_time - $start_time" | bc`
echo "MarkDuplicates:$diff" >> time_1.txt

# remove ~.sorted.RGadded.bam / marked_dup_metrices.txt
rm -rf $VAL.sorted.RGadded.bam
rm -rf marked_dup_metrics.txt

# BaseRecalibrator (make recalibration model)
fasta=/home01/a1427a01/datadrive/gatk_bundle/Homo_sapiens_assembly38.fasta
dbsnp=/home01/a1427a01/datadrive/gatk_bundle/dbsnp_138.hg38.vcf

start_time=`date +%s.%N`
# BaseRecalibrator
gatk BaseRecalibrator \
-I $VAL.sorted.RGadded.marked.bam \
-R $fasta \
--known-sites $dbsnp \
-O recal_data.table

end_time=`date +%s.%N`
diff=`echo "$end_time - $start_time" | bc`
echo "BaseRecalibrator:$diff" >> time_1.txt

start_time=`date +%s.%N`
# ApplyBQSR (readjust quality score)
gatk ApplyBQSR \
-R $fasta \
-I $VAL.sorted.RGadded.marked.bam \
--bqsr-recal-file recal_data.table \
-O $VAL.sorted.RGadded.marked.recal.bam

end_time=`date +%s.%N`
diff=`echo "$end_time - $start_time" | bc`
echo "ApplyBQSR:$diff" >> time_1.txt

# remove ~.sorted.RGadded.marked.bam / recal.data.table
rm -rf $VAL.sorted.RGadded.marked.bam
rm -rf recal_data.table

# preprocessing time check file
cat time_1.txt
