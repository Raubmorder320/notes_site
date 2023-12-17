#!/bin/bash

usr="/etc/passwd"
login=$USER

#обработка -f
while getopts ":f:" opt; do
  case $opt in
    f)
      file="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND - 1))

fl=false
for arg in *; do
    if [ "$arg" == "$usr" ]; then
      fl=true
    fi
done

if [ "$fl" == false ] && [ "$usr" != "/etc/passwd" ]; then
  echo "Error: File not found: $usr" >&2
  exit 2
fi


if [ $# == 1 ]; then
  login=$1
fi


home_dir=$(grep "^$login:" "$usr" | cut -d: -f6)

if [ -z "$home_dir" ]; then
  echo "Error: User not found: $login" >&2
  exit 1
fi
echo "$home_dir"
exit 0
