#!/bin/bash

sep=
dry_run=
res=
suffix=

#for x in "$@"; do mv "$x" "${x%.*}_name.${x##*.}"; done

while [[ $# -gt 0 ]]; do

    case $1 in
            --)
                sep=1
                shift
            ;;
            -h)
                if [[ $sep != 1 ]]; then
                    echo "namechanger.sh [-h] [-d] [-v] [--] [suffix] [file1] [file2] ..."
                    exit 0
                fi
            ;;
            -d)
                if [[ $sep != 1 ]]; then
                    dry_run=1
                fi
                shift
            ;;
            -v)
                if [[ $sep != 1 ]]; then
                    res=1
         fi
                shift
            ;;
            -*)
                if [[ $sep != 1 ]]; then
                    echo "Неизвестная опция $1" >&2
                    exit 1
                else
                    if [[ ! $suffix ]]; then
                        suffix="$1"
                    elif [[ -f $1 ]]; then
                        if [[ $dry_run == 1 ]]; then
                            echo "$1 "${1%.*}$suffix.${1##*.}""
                       elif [[ $res == 1 ]]; then
                            mv -- "$1" "${1%.*}$suffix.${1##*.}"
                            echo "${1%.*}$suffix.${1##*.}"
                        else
                            mv -- "$1" "${1%.*}$suffix.${1##*.}"
                        fi
                    else
                        echo "Файл $1 не существует" >&2
                        exit 2
		    fi
                fi
                shift
            ;;

            *)
                if [[ ! $suffix ]]; then
                        suffix="$1"
                elif [[ -f $1 ]]; then
                    if [[ $dry_run == 1 ]]; then
                        echo "$1 "${1%.*}$suffix.${1##*.}""
                    elif [[ $res == 1 ]]; then
                        mv "$1" "${1%.*}$suffix.${1##*.}"
                        echo "${1%.*}$suffix.${1##*.}"
                    else
                        if [[ "$1" != *.* || "$1" == .* ]]; then
                            mv -- "$1" "${1%.*}$suffix"
                        else
                            mv -- "$1" "${1%.*}$suffix.${1##*.}"
                        fi
                    fi
                else
                    echo "Файл $1 не существует" >&2
       exit 2
                fi
                shift
            ;;
    esac

done
