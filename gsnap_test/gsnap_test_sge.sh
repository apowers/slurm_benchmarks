#!/bin/sh
#$ -cwd
#$ -j y
#$ -l h_vmem=2.6G
#$ -pe smp 8
#$ -M atom.powers@seattlebiomed.org
#$ -m abes
#$ -q it-test.q
#$ -S /bin/bash
#$ -wd /nearline/it/sge_benchmarks/gsnap_test
#$ -o /tmp/$JOB_NAME-$JOB_ID.log
#$ -e /tmp/$JOB_NAME-$JOB_ID.log

RUNOPS='-A sam -t 8 -N 1 -B 5 -w 100000 -E 2 --query-unk-mismatch 1 --sam-multiple-primaries --ambig-splice-noclip --trim-mismatch-score 0 --filter-chastity=either'
#RUNOPS='-A sam -t 8 -N 1 -B 5 -w 100000 -E 2 --query-unk-mismatch 1 --sam-multiple-primaries --gmap-min-coverage 0.90 --ambig-splice-noclip --trim-mismatch-score 0 --filter-chastity=either'
RUNDAT='-D /nearline/it/sge_benchmarks/gsnap_test/gmapdb -d hg19.tb -s refGene_Ensembl.splicesites.iit '

OUT="/tmp/gsnap/gsnap_test.out"
mkdir "/tmp/gsnap"

eval rm $OUT
cd /nearline/it/sge_benchmarks/gsnap_test
eval /depot/install/gmap-2013-07-20/bin/gsnap $RUNOPS $RUNDAT fastq/sample_1_flag.fastq fastq/sample_2_flag.fastq > $OUT
[[ $? = 0 ]] || exit -1
RTN=$?

#/nearline/aderem/aderem_sequence2/RNASeqUtilities/Tools/gmap-2012-06-20/src/gsnap -A sam -D /nearline/shared-projects/programTesting/gmapdb/ -d hg19.tb -s refGene_Ensembl.splicesites.iit -t 8 -N 1 -B 5 -w 100000 -E 2 --query-unk-mismatch 1 --sam-multiple-primaries --gmap-min-coverage 0.90 --ambig-splice-noclip --trim-mismatch-score 0 --filter-chastity=either $fastqdir/$sample"_1_flag.fastq" $fastqdir/$sample"_2_flag.fastq" > $sample"_gsnap.hg19.tb.sam"

[[ $? -eq 0 ]] && rm  /tmp/$JOB_NAME-$JOB_ID.log 

exit $RTN

