#!/bin/bash
title="Меню для изменения владельца и группы файла"
prompt="Выберите операцию:"
nameOfuser="Введите имя владельца:"
nameOfgroup="Введите имя группы:"
nameOfFile="Введите имя файла:"
error1="Такой пользователь не существует!"
error2="Такого файла не существует!"
error3="Такой группы не существует!"
options=("Изменить имя нового владельца" "Изменить имя новой группы")
choice=("Да" "Нет")
tmp="1"
success="Операция прошла успешно!"

echo "$title"
PS3="$prompt "

  select opt in "${options[@]}" "Quit"; 
do 
    
    case "$REPLY" in
#    q = 0
    1 )  
        echo "$nameOfuser";
        read user;
        grep "$user" /etc/passwd >/dev/null
        if [ $? -ne 0 ];
        then
        echo "$error1";
        echo "$error1">&errors.txt;

#        echo "Хотите повторить?"
        
      
        else
        echo "$nameOfFile";

        read  file;
        if ! [ -f $file ]; then
        echo "$error2";
        echo "$error2">&errors.txt;
        else
        chown "$user" "$file";
        echo "$success";
fi     
      fi
;;

    2 ) echo "$nameOfgroup";
        read group;
        grep -q -E "^$group:" /etc/group >/dev/null
	if [ $? -ne 0 ]; then
        cho "$error3";
        echo "$error3">&errors.txt;

        else
        echo "$nameOfFile";

        read  file;
        if ! [ -f $file ]; then
        echo "$error2";
        else
        chown :"$group" "$file";
        echo "$success";
       fi
fi
      ;;  

    $(( ${#options[@]}+1 )) ) echo "До новых встреч!"; break;;

    *) echo "Ошибка. Попробуйте снова!";continue;;
    esac
done

