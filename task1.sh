#!/bin/bash

if_s=
if_S=
flag_=

for elem in "$@"; do

        case $elem in

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
        --)

                break
		;;
        -S) if_S=1

                ;;

        -s) if_s=1

                ;;


        -*)

                echo "Данной опции не существует" >&2

                exit 2

                ;;

        esac

done



sum=0

for file in "$@"; do

        if [[ "$file" == "--" ]]; then

                flag_=1

                continue
        fi

        if [[ $flag_ || "${file:0:1}" != "-" ]]; then

                if [[ ! -e  "$file" ]]; then

                        echo "Файл '$file' не существует" >&2

                        exit_code=1

                        continue

                else

                        size=$(stat -c %s -- "$file")

                        if [[ ! $if_S ]]; then

                              echo "$size" "$file"

                        fi

                        sum=$((sum + size))

                 fi

        fi

done



if [[  $if_s || $if_S  ]]; then

        echo "Общий размер всех файлов: $sum"

fi

exit ${exit_code:-0}
