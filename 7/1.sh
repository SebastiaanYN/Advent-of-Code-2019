#!/bin/bash

# https://stackoverflow.com/a/3846321
permute() {
  local items="$1"
  local out="$2"
  local i

  [[ "$items" == "" ]] && echo "$out" && return
  for (( i=0; i<${#items}; i++ )); do
    permute "${items:0:i}${items:i+1}" "$out${items:i:1}"
  done
}

load_intcode() {
  cp ../5/2.php intcode.php
}

remove_intcode() {
  rm intcode.php
}

run_intcode() {
  local phase_setting=$1
  local input_signal=$2

  # Run the intcode program with the given input
  local output=$(echo "$phase_setting
$input_signal" | php intcode.php)

  # Get the last word as the intcode program outputs "Input: Input: {output}"
  local output_signal=$(echo $output | awk '{print $NF}')
  echo $output_signal
}

run_sequence() {
  local seq=$1
  local output_signal="0"

  for (( i=0; i<${#seq}; i++ )); do
    output_signal=$(run_intcode "${seq:i:1}" "$output_signal")
  done

  echo $output_signal
}

find_max_thruster_signal() {
  local phase_settings=$1
  local max="0"
  
  while read -r line; do
    thruster_signal=$(run_sequence $line)
    
    if [ $thruster_signal -gt $max ]; then
      max=$thruster_signal
    fi
  done <<< $(permute $1)

  echo $max
}

load_intcode
find_max_thruster_signal "01234"
remove_intcode
