#!/bin/bash
#Run through each of the benchmarks in order on an AWS EC2 system.
# Run a benchmark on an EC2 host.
# (Initialize the host and wait for it to be available)
# Copy necessary data up to the host.
# Run the job and wait for it to complete.
# Copy result down.

case $1 in
  u)
    EC2HOST='ec2-54-214-140-225.us-west-2.compute.amazonaws.com'
    EC2USER='ubuntu'
    OS='ubuntu'
    ;;
  c)
    EC2HOST='ec2-54-212-57-56.us-west-2.compute.amazonaws.com'
    EC2USER='ec2-user'
    OS='redhat'
    ;;
  *)
    echo 'Specify (u)buntu or (c)entos image to run'
    exit 1
    ;;
esac

EC2KEY='sbri_it_management.pem'
LOG="benchmark_${OS}_ec2.log"
RTN=0
STAT="/usr/bin/time -f %e,,%U,%S,x"
LSTAT="/usr/bin/time -ao $LOG -f %e,,%U,%S,%x"

touch $LOG

echo 'hostname,job,wallclock,cpu time,user time,system time,exit status' >> $LOG
for P in lmbench blast gsnap Ethan ; do
  DIR="/nearline/it/sge_benchmarks"
  OUTDIR="/tmp/${P}"

  # gsnap sometimes leaves a large core dump in it's working directory; do not want
  rm ${DIR}/${P}_test/core.*
  rm ${DIR}/${P}_test/out/*

  echo "Starting ${P} pre-copy on ${EC2HOST} at `date +%F`"
  echo -n "${EC2USER}@AWS-EC2," >> $LOG
  echo -n "${P}-up," >> $LOG
  eval $LSTAT scp -i ${EC2KEY} -qr ${DIR}/${P}_test ${EC2USER}@${EC2HOST}:${DIR}

  echo "Starting ${P} benchmark on ${EC2HOST} at `date +%F`"
  echo -n "${EC2USER}@AWS-EC2," >> $LOG
  echo -n "${P}-run," >> $LOG
  eval ssh -t -i ${EC2KEY} ${EC2USER}@${EC2HOST} "$STAT ${DIR}/${P}_test/${P}_test.sh 1>/dev/null" >>$LOG
  echo $? >> $LOG

  echo "Starting ${P} result-copy on ${EC2HOST} at `date +%F`"
  echo -n "${EC2USER}@AWS-EC2," >> $LOG
  echo -n "${P}-down," >> $LOG
  eval $LSTAT scp -i ${EC2KEY} -qr ${EC2USER}@${EC2HOST}:${OUTDIR} ${DIR}/${P}_test/out/.

done

