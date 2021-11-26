#PBS -N serial_job
#PBS -q normal
#PBS -A etc
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1
#PBS -l walltime=48:00:00
#PBS -l select=1:ncpus=64:mpiprocs=1:ompthread=64

cd $PBS_O_WORKDIR

vcf_file_path=/scratch/a1426a01/strelka_path.txt

/home01/a1427a01/bin/bcftools merge --force-samples `cat $vcf_file_path` -Oz -o Merged.vcf.gz
