#!/bin/sh
#PBS -V
#PBS -N serial_job
#PBS -q normal
#PBS -A etc
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1
#PBS -l walltime=48:00:00
#PBS -l select=1:ncpus=64:mpiprocs=1:ompthread=64

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
