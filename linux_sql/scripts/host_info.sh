#!/bin/bash

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    exit 1
fi

hostname=$(hostname -f)
lscpu_out=$(lscpu)
cpu_number=$(echo "$lscpu_out" | grep "^CPU(s):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out" | grep "Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out" | grep "Model name:" | awk -F':' '{print $2}' | xargs)
cpu_ghz=$(echo "$cpu_model" | grep -oP '\d+\.\d+GHz' | head -1 | sed 's/GHz$//')
cpu_mhz=$(awk "BEGIN {printf \"%.0f\", $cpu_ghz * 1000}")
l2_cache=$(echo "$lscpu_out" | grep "L2 cache:" | awk '{print $3}' | sed 's/K$//')
total_mem=$(free -m | awk '/^Mem:/{print $2}' | xargs)
timestamp=$(date +'%Y-%m-%d %H:%M:%S')

insert_stmt="INSERT INTO host_info(hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, timestamp, total_mem) VALUES ('$hostname', $cpu_number, '$cpu_architecture', '$cpu_model', $cpu_mhz, $l2_cache, '$timestamp', $total_mem);"

export PGPASSWORD=$psql_password

psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"

exit $?
