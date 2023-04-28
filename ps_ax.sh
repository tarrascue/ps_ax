#!/bin/bash

# Get the list of all running processes
all_processes=$(ls /proc | grep "^[0-9]*$" | sort -n)

# Loop through each process and retrieve the required information
for pid in $all_processes
do
    # Get the process status
    status=$(cat /proc/$pid/status | grep "State:" | awk '{print $2}')

    # Get the process command
    command=$(cat /proc/$pid/cmdline | tr '\0' ' ' | sed 's/ *$//')

    # Get the process owner
    owner=$(ls -ld /proc/$pid | awk '{print $3}')

    # Get the process start time
    start_time=$(cat /proc/$pid/stat | awk '{print $22}')

    # Get the process CPU and memory usage
    cpu_usage=$(cat /proc/$pid/stat | awk '{print $14+$15}')
    mem_usage=$(cat /proc/$pid/statm | awk '{print $2}')

    # Convert start time to a readable format
    start_time=$(date -d@$((start_time/100)) "+%Y-%m-%d %H:%M:%S")

    # Print the process information
    echo "$pid $owner $status $cpu_usage $mem_usage $start_time $command"
done