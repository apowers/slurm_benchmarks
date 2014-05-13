#!/bin/sh
#SBATCH --wckey=it-test
#SBATCH --workdir=/nearline/it/hpc-test/benchmarks/gsnap_test
#SBATCH --mail-type=ALL
#SBATCH --mail-user=atom.powers@seattlebiomed.org
#SBATCH --mem=10000
#SBATCH --mincpus=2
#SBATCH --output=gsnap_test_%j.log

PWD='/nearline/it/hpc-test/benchmarks/gsnap_test'
RUNOPS='-A sam -t 8 -N 1 -B 5 -w 100000 -E 2 --query-unk-mismatch 1 --sam-multiple-primaries --ambig-splice-noclip --trim-mismatch-score 0 --filter-chastity=either'
#RUNOPS='-A sam -t 8 -N 1 -B 5 -w 100000 -E 2 --query-unk-mismatch 1 --sam-multiple-primaries --gmap-min-coverage 0.90 --ambig-splice-noclip --trim-mismatch-score 0 --filter-chastity=either'
RUNDAT="-D ${PWD}/gmapdb -d hg19.tb -s refGene_Ensembl.splicesites.iit "

OUT="/tmp/gsnap_test_${SLURM_JOBID}.out"
GSNAP='/depot/sbin/gmap-2013-09-30v2/bin/gsnap'

srun $GSNAP $RUNOPS $RUNDAT fastq/sample_1_flag.fastq fastq/sample_2_flag.fastq > /dev/null

#/nearline/aderem/aderem_sequence2/RNASeqUtilities/Tools/gmap-2012-06-20/src/gsnap -A sam -D /nearline/shared-projects/programTesting/gmapdb/ -d hg19.tb -s refGene_Ensembl.splicesites.iit -t 8 -N 1 -B 5 -w 100000 -E 2 --query-unk-mismatch 1 --sam-multiple-primaries --gmap-min-coverage 0.90 --ambig-splice-noclip --trim-mismatch-score 0 --filter-chastity=either $fastqdir/$sample"_1_flag.fastq" $fastqdir/$sample"_2_flag.fastq" > $sample"_gsnap.hg19.tb.sam"

