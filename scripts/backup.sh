#!/bin/bash

filename=$1

if [[ $filename =~ \/$ ]]; then
  filename=$(echo "$filename" | sed -E 's/\/$//')
fi

if [[ $filename =~ \.backup$ ]]; then
  processed_filename=$(echo "$filename" | sed -E 's/\.backup(\/)?$//')
  mv "$filename" "$processed_filename"
  echo "Moved $filename to $processed_filename"
else
  processed_filename="${filename}.backup"
  mv "$filename" "$processed_filename"
  echo "Moved $filename to $processed_filename"
fi
