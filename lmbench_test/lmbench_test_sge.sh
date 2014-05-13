#!/bin/bash
# This is a "representative" job from Isabelle Phan
# Modified by Atom Powers to run on a single core in about an hour.
# This script calls itself recursively to avoid the 'Unable to run job: Script length does not match declared length.' error.
# qsub options
#$ -M atom.powers@seattlebiomed.org
#$ -m abes
#$ -q it-test.q
#$ -S /bin/bash
#$ -wd /nearline/it/sge_benchmarks/lmbench_test
#$ -o /tmp/$JOB_NAME.log
#$ -e /tmp/$JOB_NAME.log

mkdir /tmp/lmbench
cd /nearline/it/sge_benchmarks/lmbench_test/src
make -s rerun > /tmp/lmbench/lmbench.out

