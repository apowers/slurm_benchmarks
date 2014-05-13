#!/bin/bash
#SBATCH --wckey=it-test
#SBATCH --workdir=/nearline/it/hpc-test/benchmarks/lmbench_test
#SBATCH --mail-type=ALL
#SBATCH --mail-user=atom.powers@seattlebiomed.org
#SBATCH --mem=2500
#SBATCH --mincpus=1
#SBATCH --distribution=block
#SBATCH --output=lmbench_test_%j.log

#srun make -s rerun > /tmp/lmbench_${SLURM_JOBID}.out && rm /tmp/lmbench_${SLURM_JOBID}.out
make -s rerun > /tmp/lmbench_${SLURM_JOBID}.out && rm /tmp/lmbench_${SLURM_JOBID}.out

