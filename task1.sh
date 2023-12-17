#!/bin/bash
flag_s=
flag_S=
flag_=

for el in "$@"; do

        case $el in
        --usage)
                echo "Скрипт выводит информацию о размере файлов"
                echo
                echo "Синтаксис использования:"
                echo " $0 [ОПЦИИ] ФАЙЛ..."
                echo
                echo "ДОСТУПНЫЕ ОПЦИИ:"
                echo "  -s    Вывести суммарный размер файлов в конце"
                echo "  -S    Вывести только суммарный размер файлов"
                exit 0
                ;;
        --help)
                echo "Использование: $0 [ОПЦИИ] ФАЙЛ..."
                echo
                echo "ОПЦИИ:"
                echo "  -s    Вывести суммарный размер файлов в конце"
                echo "  -S    Вывести только суммарный размер файлов"
                echo "  --usage    Вывод информации о синтаксисе использования"
                echo "  --help     Вывод подробной справки"
                exit 0
                ;;
        -s) flag_s=1
                #break
                ;;
        -S) flag_S=1
                #break
                ;;
        --) #flag_=1
                break
                ;;
        -*)
                echo "Данной опции не существует"
                exit 2
                ;;
        esac
done
sum_size=0
for file in "$@"; do
        if [[ "$file" == "--" ]]; then
                flag_=1
                continue
        fi
        if [[ $flag_ || "${file:0:1}" != "-" ]]; then
                if [[ ! -e  "$file" ]]; then
                        echo "Файл '$file' не существует"
                        exit_status=1
                        continue
                else
                        size=$(stat -c %s -- "$file")
                        if [[ ! $flag_S ]]; then
                              echo "$size" "$file"
                        fi
                        sum_size=$((sum_size + size))
                 fi
        elif [[ "$file" != "-s" && "$file" != "-S" ]]; then
                size=$(stat -c %s "$file")
                if [[ ! $flag_S ]]; then
                        echo "$size" "$file"
                fi
                sum_size=$((sum_size + size))
        fi
done
if [[  $flag_s || $flag_S  ]]; then
        echo "Общий размер всех файлов: $all_size"
fi
exit ${exit_status:-0}
