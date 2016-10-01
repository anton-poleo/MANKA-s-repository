#!/bin/bash

rights_func ()
{
r_val=$(echo "-")
w_val=$(echo "-")
x_val=$(echo "-")


options1=("Установить право на чтение" "Установить право на запись" "Установить право на исполнение" "Выйти - все необходимые права установлены")
select opt1 in "${options1[@]}"
do
    case $opt1 in
    	"Установить право на чтение")
    	    r_val=$(echo "r")
	    ;;
        "Установить право на запись")
    	    w_val=$(echo  "w")
    	    ;;
        "Установить право на исполнение")
    	    x_val=$(echo  "x")
    	    ;;
	"Выйти - все необходимые права установлены")
	    break
	    ;;
	    	*).
	     echo "Ошибка!"
	    ;;
    esac
done
rights=$r_val$w_val$x_val
}


file_name="$1"
#echo "${file_name}"
options2=("Добавить запись" "Удалить запись" "Изменить запись" "Выйти")
select opt2 in "${options2[@]}"
do
    case $opt2 in
	"Добавить запись")
	    echo "Выберите пользователя или группу (u/g):"
	    read choice
	    if test "$choice" = u
		then
		    echo "Вы выбрали пользователя"
		    echo "Введите имя пользователя:"
		    read name_user
		    rights_func
		#    echo "${rights}"
		    setfacl -m u:$name_user:$rights $file_name
		elif test "$choice" = g
		    then 
			echo "Вы выбрали группу"
			echo "Введите имя группы:"
			read name_group
			rights_func
			setfacl -m g:$name_group:$rights $file_name
		    else
			echo "Вы ввели неверную букву"
	    fi
	    ;;
	"Удалить запись")
	    ;;
	"Изменить запись")
	    echo "3"
	    ;;
	"Выйти")
	    break
	    ;;
	*) 
	    echo "Неверный аргумент"
	    ;;
    esac
done

