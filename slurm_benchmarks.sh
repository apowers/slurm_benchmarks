#!/bin/bash
# apowers 2014.05.08 - Slurm script to test cluster performance. These jobs are not intended to do anything useful.
#SBATCH --wckey=it-test
#SBATCH --workdir=/nearline/it/hpc-test/benchmarks
#SBATCH --job-name=benchmarks
#SBATCH --mail-type=ALL
#SBATCH --mail-user=atom.powers@seattlebiomed.org
#SBATCH --output=benchmarks_%j.log
#SBATCH --mincpus=2
#SBATCH --mem=10000
#SBATCH --time=10:0:0

#== Blast Test ==#
BLAST='/depot/sbin/blast+-2.2.29/bin/blastp'
Blast_WD='/nearline/it/hpc-test/benchmarks/blast_test'
Blast_DB='blast_test'
Blast_OUT="/tmp/blast_test_${SLURM_JOB_ID}.out"
  
srun -J blast --mem=600 -t 120 -D $Blast_WD $BLAST -db $Blast_DB -query $Blast_DB -out /dev/null -evalue 1e-5
#srun -J blast -t 120 -D $Blast_WD $BLAST -db $Blast_WD -query $Blast_WD -out /dev/null -evalue 1e-5
   
#== Ethan Test ==#
Ethan_OUTDIR="/tmp/Ethan_test_${SLURM_JOB_ID}"
Ethan_OUT="${SLURM_JOB_ID}.out"
Ethan_DATA='/nearline/it/hpc-test/benchmarks/Ethan_test/'
    
srun -J Ethan --mem=3000 -t 180 mkdir -p $Ethan_OUTDIR && Ethan_test/ITTest_mod.app $Ethan_OUTDIR/ $Ethan_DATA/ > /dev/null && rm -rf $Ethan_OUTDIR
     
#== LmBench Test ==#
LmBench_WD='/nearline/it/hpc-test/benchmarks/lmbench_test'
srun -J lmbench --mem=2500 -t 30 -D $LmBench_WD make -s rerun > /dev/null

#== GSnap Test ==#
Gsnap_WD='/nearline/it/hpc-test/benchmarks/gsnap_test'
Gsnap_RUNOPS='-A sam -t 8 -N 1 -B 5 -w 100000 -E 2 --query-unk-mismatch 1 --sam-multiple-primaries --ambig-splice-noclip --trim-mismatch-score 0 --filter-chastity=either'
Gsnap_RUNDAT="-D ${WD}/gmapdb -d hg19.tb -s refGene_Ensembl.splicesites.iit "
Gsnap_OUT="/tmp/gsnap_test_${SLURM_JOBID}.out"
GSNAP='/depot/sbin/gmap-2013-09-30v2/bin/gsnap'
      
srun -J gsnap --mincpus=2 --mem=10000 -t 120 $GSNAP $Gsnap_RUNOPS $Gsnap_RUNDAT fastq/sample_1_flag.fastq fastq/sample_2_flag.fastq > /dev/null
       
