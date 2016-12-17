#!/bin/bash

# Перечень пунктов меню
OPTIONS=(
"1) Изменить права для владельца"
"2) Изменить права для группы"
"3) Изменить права для остальных"
"4) Изменить права для всех"
"5) Вернуться в главное меню"
)
OPTIONS_MODE=(
"1) Добавить право записи"
"2) Удалить право записи"
"3) Добавить право чтения"
"4) Удалить право чтения"
"5) Добавить право исполнения"
"6) Удалить право исполнения"
"7) Добавить бит SUID"
"8) Удалить бит SUID"
"9) Вернуться назад"
)

recursively_or_not(){
	#рекурсивное применение изменений - возвращает 0, иначе - возвращает 1
	echo "Вы ввели путь к каталогу. Изменить права у всех файлов внутри него? y/n " 
	read a
    if [[ $a == "Y" || $a == "y" ]]; then
		return 0
	else
		return 1
	fi
}

choose_mode(){
	local err=0
	echo
	if [[ "$mode" == "u" ]]; then
		echo "Изменение прав доступа к файлу "$2" для владельца"
	elif [[ "$mode" == "g" ]]; then
		echo "Изменение прав доступа к файлу "$2" для группы"
	elif [[ "$mode" == "o" ]]; then
		echo "Изменение прав доступа к файлу "$2" для остальных"
	else
		echo "Изменение прав доступа к файлу "$2" для всех"				  
	fi
	local i=0
	if [[ "$mode" == "u" || "$mode" == "g" ]]; then
		while [ "$i" -lt 9 ]
		do
			echo ${OPTIONS_MODE[i]}
			let "i += 1"
		done
	else
		while [ "$i" -lt 6 ]
		do
			echo ${OPTIONS_MODE[i]}
			let "i += 1"
		done
		echo ${OPTIONS_MODE[8]}
	fi
	read REPLY
	case $REPLY in
		"1")#+w
			mode=$1"+w"
		;;
		"2")#-w
			mode=$1"-w"
		;;
		"3")#+r
			mode=$1"+r"
		;;
		"4")#-r
			mode=$1"-r"
		;;
		"5")#+x
			mode=$1"+x"
		;;
		"6")#-x
			mode=$1"-x"
		;;
		"7")#+s
			if [[ "$mode" == "u" || "$mode" == "g" ]]; then
				mode=$1"+s"
			else
				echo "Неверный ввод!">&2
				let "err = 1"
			fi
		;;
		"8")#-s
			if [[ "$mode" == "u" || "$mode" == "g" ]]; then
				mode=$1"-s"
			else
				echo "Неверный ввод!">&2
				let "err = 1"
			fi
		;;		
		"9") return;;
		*) echo "Неверный ввод!">&2
			let "err = 1"
		;;
	esac
	if [[ err -eq 1 ]]; then
		choose_mode $1 $2
	else
		change_mode $mode $2
	fi
}

change_mode(){
	if [[ -f $2 ]]; then
		chmod $1 $2
		exit_code=$?
	else
		recursively_or_not
		if [[ $? -eq 0 ]]; then
			chmod -R $1 $2
			exit_code=$?
		else
			chmod $1 $2
			exit_code=$?
		fi
	fi
	if [[ exit_code -ne 0 ]]; then
		echo "Не получилось изменить права для файла "$2>&2
	else
		echo "Права доступа для файла "$2" были изменены"
	fi
}

while :
do
	echo
	echo "Изменение прав доступа для файла "$1
	for opt in "${OPTIONS[@]}"
	do
		echo $opt
	done
	read REPLY
	case $REPLY in
	"1")#user
		mode="u"
		;;
	"2")#group
		mode="g"
		;;
	"3")#others
		mode="o"
		;;
	"4")#all
		mode="a"
		;;
	"5") break;;
	*) echo "Неверный ввод!">&2
		continue
		;;
	esac
	choose_mode $mode $1
done	
