#!/bin/bash

minsize=1
human=false

helpf() {
  echo "Формат вызова:"
  echo "topsize [--help] [-h] [-N] [-s minsize] [--] [dir...]"
  echo "--help      - вывод справки"
  echo "-N          - количества файлов (если не указано, выводятся все файлы)"
  echo "-s minsize  - вывод размера в человекочитаемом формате"
  echo "dir...      - каталог (и) поиск (если не указаны, исползуется текущий каталог)"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help)
      helpf
      exit 0
      ;;
    -h)
      human=true
      shift
      ;;
    -N)
      if [[ $# -gt 1 ]]; then
        N="$2"
        shift 2
      else
        echo "Ошибка: не указан минимальный размер после опции -s"
        print_help
        exit 1
      fi
      ;;
    --)
      shift
      directory=("$@")
      break
      ;;
  esac
done

if [ -z "$1" ]; then
    directory="."
else
    directory="$1"
fi

if [ -z "$N" ]; then
    find "$directory" -type f -size +"$minsize"c -exec du -b {} + | sort -nr | while read size file; do
        if [ $human = true ]; then
            size=$(numfmt --to=si $size)
        fi
        echo "$size $file"
    done
else
    find "$directory" -type f -size +"$minsize"c -exec du -b {} + | sort -nr | head -n "$N" | while read size file; do
        if [ $human = true ]; then
            size=$(numfmt --to=si $size)
        fi
        echo "$size $file"
    done
fi
