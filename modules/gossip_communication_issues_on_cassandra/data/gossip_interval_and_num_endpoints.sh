bash

#!/bin/bash



# Set the gossip interval to ${INTERVAL}

gossip_interval=${INTERVAL}

cassandra_yaml_file=${PATH_TO_CASSANDRA_YAML}



# Adjust the gossip interval

sed -i "s/^#*\(gossip\_interval\:*\).*/\1 ${gossip_interval}/" ${cassandra_yaml_file}



# Set the number of endpoints to ${ENDPOINTS}

num_endpoints=${ENDPOINTS}



# Adjust the number of endpoints

sed -i "s/^#*\(num\_endpoints\:*\).*/\1 ${num_endpoints}/" ${cassandra_yaml_file}



# Restart Cassandra to apply the changes

systemctl restart cassandra.service