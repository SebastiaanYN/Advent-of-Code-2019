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
  node=$(which node)

  # Run the intcode program using pipexec
  #
  # The stderr of A is sent to the stdin of B
  # The stderr of B is sent to the stdin of C
  # etc.
  output=$(pipexec -- \
    [ A $node wrapper.js $1 0 ] \
    [ B $node wrapper.js $2 ] \
    [ C $node wrapper.js $3 ] \
    [ D $node wrapper.js $4 ] \
    [ E $node wrapper.js $5 ] \
    '{A:2>B:0}' \
    '{B:2>C:0}' \
    '{C:2>D:0}' \
    '{D:2>E:0}' \
    '{E:2>A:0}')

  # Get the last word as the wrapper logs multiple times
  local output_signal=$(echo $output | awk '{print $NF}')
  echo $output_signal
}

run_sequence() {
  local seq=$1
  local output=$(run_intcode "${seq:0:1}" "${seq:1:1}" "${seq:2:1}" "${seq:3:1}" "${seq:4:1}")
  echo $output
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
find_max_thruster_signal "56789"
remove_intcode
