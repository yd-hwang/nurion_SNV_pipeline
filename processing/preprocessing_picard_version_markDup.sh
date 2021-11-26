#!/bin/sh
#PBS -V
#PBS -N serial_job
#PBS -q normal
#PBS -A etc
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1
#PBS -l walltime=48:00:00
#PBS -l select=1:ncpus=64:mpiprocs=1:ompthread=64

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
