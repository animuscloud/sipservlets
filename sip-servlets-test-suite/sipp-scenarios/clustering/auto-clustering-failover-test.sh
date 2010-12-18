export EXAMPLES_HOME=../../../sip-servlets-examples

export config1="all"
export config2="port-1"
export KILL_PARAMS="-9"
export FULLSTARTSLEEP=82
export HALFSTARTSLEEP=80

if [ "x$1" != "x" ]; then
    export FULLSTARTSLEEP=$1
fi

if [ "x$2" != "x" ]; then
    export HALFSTARTSLEEP=$2
fi

export EXIT_CODE=0;

rm -rf result.txt

# Start SIP LB
echo "#!/bin/sh" > auto-startlb.sh
echo "java -server -Xms1536m -Xmx1536m -XX:PermSize=128M -XX:MaxPermSize=256M -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -jar $JBOSS_HOME/sip-balancer/sip-balancer-jar-with-dependencies.jar -mobicents-balancer-config=$JBOSS_HOME/sip-balancer/lb-configuration.properties" >> auto-startlb.sh
chmod +x auto-startlb.sh

echo "#!/bin/sh" > auto-startlb-worst.sh
echo "java -server -Xms1536m -Xmx1536m -XX:PermSize=128M -XX:MaxPermSize=256M -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -jar $JBOSS_HOME/sip-balancer/sip-balancer-jar-with-dependencies.jar -mobicents-balancer-config=ar/worstcase-affinity-lb-configuration.properties" >> auto-startlb-worst.sh
chmod +x auto-startlb-worst.sh


./auto-startlb.sh > siplb.out &
export SIPLB=$!
echo "SIP LB $SIPLB"

##################################
# Test Custom B2BUA
##################################
echo "Test Custom B2BUA"
echo "================================"
./auto-prepare-example.sh custom-b2bua $config1
./auto-prepare-example.sh custom-b2bua $config2

./auto-start-jboss-server.sh $config2 $config2.pid 1 custom-b2bua

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-start-jboss-server.sh $config1 $config1.pid 0 custom-b2bua

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-run-test.sh custom-b2bua result.txt


#The test killed server 1, so we start it again
./auto-start-jboss-server.sh $config1 $config1.pid 0 custom-b2bua-udp-tcp

sleep $HALFSTARTSLEEP

./auto-run-test.sh custom-b2bua-udp-tcp result.txt


#The test killed server 1, so we start it again
./auto-start-jboss-server.sh $config1 $config1.pid 0 custom-b2bua-tcp-tcp

sleep $HALFSTARTSLEEP

./auto-run-test.sh custom-b2bua-tcp-tcp result.txt

#Kill the app servers
./auto-kill-process-tree.sh `cat $config1.pid` $config1
./auto-kill-process-tree.sh `cat $config2.pid` $config2

sleep 10

##################################
# Test b2bua
##################################
echo "Test b2bua"
echo "================================"
./auto-prepare-example.sh b2bua $config1
./auto-prepare-example.sh b2bua $config2

./auto-start-jboss-server.sh $config2 $config2.pid 1 b2bua

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-start-jboss-server.sh $config1 $config1.pid 0 b2bua

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-run-test.sh b2bua result.txt

#The test killed server 1, so we start it again
./auto-start-jboss-server.sh $config1 $config1.pid 0 b2bua-remote-send-bye

sleep $HALFSTARTSLEEP

./auto-run-test.sh b2bua-remote-send-bye result.txt

#The test killed server 1, so we start it again
./auto-start-jboss-server.sh $config1 $config1.pid 0 b2bua-remote-send-bye-no-ring

sleep $HALFSTARTSLEEP

./auto-run-test.sh b2bua-remote-send-bye-no-ring result.txt

#Kill the app servers
./auto-kill-process-tree.sh `cat $config1.pid` $config1
./auto-kill-process-tree.sh `cat $config2.pid` $config2

sleep 10

##################################
# Test proxy
##################################
echo "Test proxy"
echo "================================"
./auto-prepare-example.sh proxy $config1
./auto-prepare-example.sh proxy $config2

./auto-start-jboss-server.sh $config2 $config2.pid 1 proxy

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-start-jboss-server.sh $config1 $config1.pid 0 proxy

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-run-test.sh proxy result.txt

#The test killed server 1, so we start it again
./auto-start-jboss-server.sh $config1 $config1.pid 0 proxy-remote-send-bye

sleep $HALFSTARTSLEEP

./auto-run-test.sh proxy-remote-send-bye result.txt

#Kill the app servers
./auto-kill-process-tree.sh `cat $config1.pid` $config1
./auto-kill-process-tree.sh `cat $config2.pid` $config2

sleep 10

##################################
# Test UAS
##################################
echo "Test UAS"
echo "================================"
./auto-prepare-example.sh uas $config1
./auto-prepare-example.sh uas $config2

./auto-start-jboss-server.sh $config2 $config2.pid 1 uas

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-start-jboss-server.sh $config1 $config1.pid 0 uas

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-run-test.sh uas result.txt

#The test killed server 1, so we start it again
./auto-start-jboss-server.sh $config1 $config1.pid 0 uas-remove-attributes

sleep $HALFSTARTSLEEP

./auto-run-test.sh uas-remove-attributes result.txt

#The test killed server 1, so we start it again
./auto-start-jboss-server.sh $config1 $config1.pid 0 uas-no-attributes

sleep $HALFSTARTSLEEP

./auto-run-test.sh uas-no-attributes result.txt

#The test killed server 1, so we start it again
./auto-start-jboss-server.sh $config1 $config1.pid 0 uas-reinvite

sleep $HALFSTARTSLEEP

./auto-run-test.sh uas-reinvite result.txt

#if [ "x$3" == "xjboss-5" ]; then

#The test killed server 1, so we start it again
./auto-start-jboss-server.sh $config1 $config1.pid 0 uas-timer

sleep $HALFSTARTSLEEP

./auto-run-test.sh uas-timer result.txt

#The test killed server 1, so we start it again
./auto-start-jboss-server.sh $config1 $config1.pid 0 uas-sas-timer

sleep $HALFSTARTSLEEP

./auto-run-test.sh uas-sas-timer result.txt

#End JBoss5-specific
#fi

#Kill the app servers
./auto-kill-process-tree.sh `cat $config2.pid` $config2
./auto-kill-process-tree.sh `cat $config1.pid` $config1

sleep 10

##################################
# Test UAS bound to 0.0.0.0
##################################
echo "Test UAS with servers bound to 0.0.0.0"
echo "================================"
./auto-prepare-example.sh uas $config1
./auto-prepare-example.sh uas $config2

./auto-start-jboss-server-0.0.0.0.sh $config2 $config2.pid $ports2 2 uas-0.0.0.0
./auto-start-jboss-server-0.0.0.0.sh $config1 $config1.pid $ports1 1 uas-0.0.0.0

#Wait to boot
sleep $HALFSTARTSLEEP
#takes a bit more time to boot on 0.0.0.0
sleep $HALFSTARTSLEEP

./auto-run-test.sh uas-0.0.0.0 result.txt

#Kill the app servers
./auto-kill-process-tree.sh `cat $config1.pid` $config1
./auto-kill-process-tree.sh `cat $config2.pid` $config2

sleep 10

##################################
# Test UAS reinvite passivation
##################################
echo "Test UAS Reinvite Passivation"
echo "================================"
./auto-prepare-example.sh uas-passivation $config1
./auto-prepare-example.sh uas-passivation $config2

./auto-start-jboss-server.sh $config2 $config2.pid 1 uas-reinvite-passivation

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-start-jboss-server.sh $config1 $config1.pid 0 uas-reinvite-passivation

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-run-test.sh uas-reinvite-passivation result.txt

#Kill the app servers
./auto-kill-process-tree.sh `cat $config1.pid` $config1
./auto-kill-process-tree.sh `cat $config2.pid` $config2

sleep 10

##################################
# Test UAS SAS Expiration Timer passivation
##################################
echo "Test UAS SAS Expiration Timer Passivation"
echo "================================"
./auto-prepare-example.sh uas-passivation $config1
./auto-prepare-example.sh uas-passivation $config2

./auto-start-jboss-server.sh $config2 $config2.pid 1 uas-sas-timer-passivation

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-start-jboss-server.sh $config1 $config1.pid 0 uas-sas-timer-passivation

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-run-test.sh uas-sas-timer-passivation result.txt

#Kill the app servers
./auto-kill-process-tree.sh `cat $config1.pid` $config1
./auto-kill-process-tree.sh `cat $config2.pid` $config2

sleep 10

##################################
# Test UAS Servlet Timer passivation
##################################
echo "Test UAS Servlet Timer Passivation"
echo "================================"
./auto-prepare-example.sh uas-passivation $config1
./auto-prepare-example.sh uas-passivation $config2

./auto-start-jboss-server.sh $config2 $config2.pid 1 uas-timer-passivation

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-start-jboss-server.sh $config1 $config1.pid 0 uas-timer-passivation

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-run-test.sh uas-timer-passivation result.txt

#Kill the app servers
./auto-kill-process-tree.sh `cat $config1.pid` $config1
./auto-kill-process-tree.sh `cat $config2.pid` $config2

sleep 10

##################################
# Test proxy early failover
##################################
echo "Test proxy early failover"
echo "================================"
./auto-prepare-example.sh proxy-early $config1
./auto-prepare-example.sh proxy-early $config2

./auto-start-jboss-server.sh $config2 $config2.pid 1 proxy-early

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-start-jboss-server.sh $config1 $config1.pid 0 proxy-early

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-run-test.sh proxy-early result.txt

#Kill the app servers
./auto-kill-process-tree.sh `cat $config1.pid` $config1
./auto-kill-process-tree.sh `cat $config2.pid` $config2

sleep 10

##################################
# Test Custom B2BUA Early Dialog Failover
##################################
echo "Test Custom B2BUA Early Dialog Failover"
echo "================================"
./auto-prepare-example.sh custom-b2bua-early $config1
./auto-prepare-example.sh custom-b2bua-early $config2

./auto-start-jboss-server.sh $config2 $config2.pid 1 custom-b2bua-early

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-start-jboss-server.sh $config1 $config1.pid 0 custom-b2bua-early

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-run-test.sh custom-b2bua-early result.txt

#Kill the app servers
./auto-kill-process-tree.sh `cat $config1.pid` $config1
./auto-kill-process-tree.sh `cat $config2.pid` $config2

sleep 10

##################################
# Test b2bua Early Dialog Failover
##################################
echo "Test b2bua early dialog failover"
echo "================================"
./auto-prepare-example.sh b2bua-early $config1
./auto-prepare-example.sh b2bua-early $config2

./auto-start-jboss-server.sh $config2 $config2.pid 1 b2bua-early

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-start-jboss-server.sh $config1 $config1.pid 0 b2bua-early

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-run-test.sh b2bua-early result.txt

#Kill the app servers
./auto-kill-process-tree.sh `cat $config1.pid` $config1
./auto-kill-process-tree.sh `cat $config2.pid` $config2

sleep 10

##################################
# Test b2bua Forward Ack Early Dialog Failover
##################################
echo "Test b2bua early dialog failover Forward Ack"
echo "================================"

./auto-start-jboss-server.sh $config2 $config2.pid 1 b2bua-early-fwd-ack

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-start-jboss-server.sh $config1 $config1.pid 0 b2bua-early-fwd-ack

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-run-test.sh b2bua-early-fwd-ack result.txt

#Kill the app servers
./auto-kill-process-tree.sh `cat $config1.pid` $config1
./auto-kill-process-tree.sh `cat $config2.pid` $config2

sleep 10

##################################
# Test AR
##################################
echo "Test Proxy-B2bua AR"
echo "================================"

#We must kill the LB here and make it use worstcase affinity
./auto-kill-process-tree.sh $SIPLB siplb
./auto-startlb-worst.sh > siplb.out &
export SIPLB=$!
echo "SIP LB $SIPLB"

./auto-prepare-example.sh proxy-b2bua-ar $config1
./auto-prepare-example.sh proxy-b2bua-ar $config2

./auto-start-jboss-server.sh $config2 $config2.pid 1 proxy-b2bua-ar

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-start-jboss-server.sh $config1 $config1.pid 0 proxy-b2bua-ar

# SIPp should be running by the time JBoss finishes the startup, hence we use half start time here.

#cleanup flag files for this test
rm -rf *.flag

sleep $HALFSTARTSLEEP
./auto-run-test.sh proxy-b2bua-ar result-ignore.txt

sleep 20
if [ -f lssdestryed.flag -a -f cb2buadestryed.flag ]; then
    #success if both flags are present
    echo "proxy-b2bua-ar 0" >> result.txt
else
    #failure is one of the flags is missing
    echo "proxy-b2bua-ar 1" >> result.txt
fi

#some debug info
cat result.txt
ls

#Kill the app servers
./auto-kill-process-tree.sh `cat $config1.pid` $config1
./auto-kill-process-tree.sh `cat $config2.pid` $config2

sleep 10


##################################
# Test UAC (should always be the last test or it may messed up the other tests) 
##################################
echo "Test UAC"
echo "================================"
./auto-prepare-example.sh uac $config1 -Dsend.on.init=true
./auto-prepare-example.sh uac $config2 -Dsend.on.init=false

./auto-start-jboss-server.sh $config2 $config2.pid 1 uac

#Wait to boot
sleep $HALFSTARTSLEEP

./auto-start-jboss-server.sh $config1 $config1.pid 0 uac

# SIPp should be running by the time JBoss finishes the startup, hence we use half start time here.

sleep 50
./auto-run-test.sh uac result.txt

#Kill the app servers
./auto-kill-process-tree.sh `cat $config1.pid` $config1
./auto-kill-process-tree.sh `cat $config2.pid` $config2

sleep 10



##################################
# Cleanup
##################################

#Kill all processes
./auto-kill-process-tree.sh `cat $config1.pid` $config1
./auto-kill-process-tree.sh `cat $config2.pid` $config2
./auto-kill-process-tree.sh $SIPLB siplb


kill $KILL_PARAMS `cat $config1.pid`
#echo "Exit status for JBOSS1 $JBOSS1: $?"
kill $KILL_PARAMS `cat $config2.pid`
#echo "Exit status for JBOSS2 $JBOSS2: $?"
kill $KILL_PARAMS $SIPLB
#echo "Exit status for SIPLB $SIPLB: $?"

./auto-generate-junit-test-report.sh result.txt report.xml

exit $EXIT_CODE
