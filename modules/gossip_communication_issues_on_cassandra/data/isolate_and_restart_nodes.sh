

#!/bin/bash



# Identify the affected nodes

NODES="${NODE1} ${NODE2} ${NODE3}"



# Isolate the affected nodes

for NODE in $NODES

do

    echo "Isolating node: $NODE"

    ssh $NODE "sudo /sbin/iptables -A INPUT -p tcp --dport 9042 -j DROP"

done



# Restart the affected nodes

for NODE in $NODES

do

    echo "Restarting node: $NODE"

    ssh $NODE "sudo /sbin/service cassandra restart"

done