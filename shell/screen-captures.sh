#!/bin/bash

source_dir="/Users/robert/Desktop"
destination_dir="/Users/robert/screen-captures/may-28-2023"
file_extension=".png"

find "$source_dir" -type f -name "*$file_extension" -newermt "$(date +%Y-%m-%d)" -exec mv {} "$destination_dir" \;
find "$destination_dir" -type f | wc -l