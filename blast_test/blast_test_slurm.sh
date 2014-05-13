#!/bin/bash
# This is a "representative" job from Isabelle Phan
# Modified by Atom Powers to run on a single core in about an hour.
# This script calls itself recursively to avoid the 'Unable to run job: Script length does not match declared length.' error.
# qsub options
#SBATCH --wckey=it-test
#SBATCH --workdir=/nearline/it/hpc-test/benchmarks/blast_test
#SBATCH --mail-type=ALL
#SBATCH --mail-user=atom.powers@seattlebiomed.org
#SBATCH --mem=600
#SBATCH --mincpus=1
#SBATCH --distribution=block
#SBATCH --output=blast_test_%j.log

WD='/nearline/it/hpc-test/benchmarks/blast_test'
BLAST='/depot/sbin/blast+-2.2.29/bin/blastp'
DB='blast_test'
OUT="/tmp/blast_test_${SLURM_JOBID}.out"

srun $BLAST -db $DB -query $DB -out $OUT -evalue 1e-5 && rm $OUT

