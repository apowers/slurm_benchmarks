#!/bin/bash
# Runs a series of performance benchmarks on each node in the cluster.
# It takes one parameter, the number of times to run each job.
#
# Run each benchmark ten times on each node in the cluster.
# https://confluence.sbri.org/display/it/SGE+Performance
#
# cluster nodes are "compute-1-{0..21}", with some names no longer in use.
# Determine if a host is available with a simple ping.
#
# Jobs are /nearline/it/sge_benchmarks/<name>_test/start.sh
#
# Control where the job is placed by reconfiguring the it-test.q queue.
#
TIMES=$1

/usr/bin/id | grep -q 'gid=10000'
if [[ $? -ne 0 ]] ;then 
  echo "You must be a member of the IT group to use this script."
  exit 1
fi

USER=`whoami`
qconf -sm | grep -q $USER
if [[ $? -ne 0 ]] ;then 
  echo "You must be a queue manager to use this script."
  echo "Use 'qconf -sm' and 'qconf -am' to manage managers."
  exit 1
fi

while ! [[ $TIMES =~ ^[0-9]+$ ]] ;do
  echo 'Parameters Required: How many times should I start each job?'
  read TIMES
done


cd /nearline/it/sge_benchmarks

export SGE_EXECD_PORT=537
export SGE_QMASTER_PORT=536
export SGE_ROOT='/opt/gridengine'

DELLR415='compute-1-0 compute-1-1'
DELLPOWEREDGE='compute-1-2'
DELLSC1435='compute-1-3 compute-1-9 compute-1-10 compute-1-11 compute-1-12'
# 1-5 and 1-6 are retired
#SUNX4100='compute-1-4 compute-1-5 compute-1-6 compute-1-7 compute-1-8'
SUNX4100='compute-1-4 compute-1-7 compute-1-8'
# Aderem, AderemX on 1-18 through 1-20 ; 1-21 is not in service
#ATLAS1205='compute-1-13 compute-1-14 compute-1-15 compute-1-16 compute-1-17 compute-1-18 compute-1-19 compute-1-20 compute-1-21'
ATLAS1205='compute-1-13 compute-1-14 compute-1-15 compute-1-17'

# The scheduler takes longer to assign the jobs to a host than this routine takes to queue the jobs.
# This results in an unpredictable assignemnt of jobs to hosts; the opposite of what we want.
# Added code to select a host group at runtime.
PS3="Select node-group to run on; only one node-group can run at a time: "
select N in DELLR415 DELLPOWEREDGE DELLSC1435 SUNX4100 ATLAS1205; do
  eval HOSTS=\$$N
  I=$TIMES
    # reconfigure the queue to use these hosts
    cat it-test.q | sed -r "s/hostlist\s+.+/hostlist $HOSTS/" > it-test.q.tmp 
#    qconf -sq it-test.q | sed -r "s/hostlist\s+.+/hostlist $HOSTS/" > it-test.q.tmp 
    qconf -Mq it-test.q.tmp
    # Queue each job 
    while [[ $I -gt 0 ]];do
      qsub -N "blast_test_$N" blast_test/blast_test.sh
      qsub -N "gsnap_test_$N" gsnap_test/gsnap_test.sh
      qsub -N "Ethan_test_$N" Ethan_test/Ethan_test.sh
      qsub -N "lmbench_test_$N" lmbench_test/lmbench_test.sh
      I=$(($I-1))
    done
  break
done

