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

vmstat_mb=$(vmstat --unit M)
hostname=$(hostname -f)
memory_free=$(echo "$vmstat_mb" | awk 'NR==3 {print $4}')
cpu_idle=$(echo "$vmstat_mb" | awk 'NR==3 {print $15}')
cpu_kernel=$(echo "$vmstat_mb" | awk 'NR==3 {print $14}')
disk_io=$(vmstat -d | awk 'NR==3 {print $10}')
disk_available=$(df -BM / | awk 'NR==2 {sub(/M/, "", $4); print $4}')
timestamp=$(date +'%Y-%m-%d %H:%M:%S')

host_id="(SELECT id FROM host_info WHERE hostname='$hostname')"
insert_stmt="INSERT INTO host_usage(timestamp, host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available) VALUES('$timestamp', $host_id, $memory_free, $cpu_idle, $cpu_kernel, $disk_io, '$disk_available');"

export PGPASSWORD=$psql_password
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?
