#!/bin/bash
#Run through each of the benchmarks in order on the local system.

START=`/bin/date +%F`
HOST=`hostname`
FQDN=`hostname --fqdn`
LOG="benchmark_${HOST}.log"
STAT="/usr/bin/time -ao $LOG -f '${FQDN},%C,%e,,%U,%S,%x'"

TIMES=1
[[ $1 -gt 1 ]] && TIMES=$1

touch $LOG

# via the time command, these functions will notify if they exist non-zero
function lmbench {
  cd /nearline/it/sge_benchmarks/lmbench_test
  eval $STAT ./lmbench_test.sh
} 

function blast {
  cd /nearline/it/sge_benchmarks/blast_test
  eval $STAT ./blast_test.sh
}

function gsnap {
  cd /nearline/it/sge_benchmarks/gsnap_test
  eval $STAT ./gsnap_test.sh
}

function Ethan {
  cd /nearline/it/sge_benchmarks/Ethan_test
  eval $STAT ./Ethan_test.sh
}

echo 'hostname,command,wallclock,memory time,user time,system time,exit status' >> $LOG
i=$TIMES
while [[ $i -gt 0 ]];do
  for P in lmbench blast gsnap Ethan ; do
    eval $P
  done
  $i=$(($i-1))
done

