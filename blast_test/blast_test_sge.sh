#!/bin/bash
# This is a "representative" job from Isabelle Phan
# Modified by Atom Powers to run on a single core in about an hour.
# This script calls itself recursively to avoid the 'Unable to run job: Script length does not match declared length.' error.
# qsub options
#$ -M atom.powers@seattlebiomed.org
#$ -m abes
#$ -q all.q
#$ -S /bin/bash
#$ -wd /nearline/it/sge/sge_benchmarks/blast_test
#$ -o /tmp/$JOB_NAME.log
#$ -e /tmp/$JOB_NAME.log
#$ -l h_vmem=20G
#$ -pe smp 1

BLAST='/depot/install/blast-2.2.27/bin/blastp'
DB='blast_test'
OUT='/tmp/blast/blast_test.out'

mkdir -p /tmp/blast
eval rm $OUT
cd /nearline/it/sge/sge_benchmarks/blast_test
eval $BLAST -db $DB -query $DB -out $OUT -evalue 1e-5 

