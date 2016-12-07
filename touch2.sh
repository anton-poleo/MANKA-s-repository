#!/bin/bashvc
options=("Изменить имя владельца" "Изменить имя группы")

PS3="Введите:"
ptions=("Изменить имя владельца" "Изменить имя группы")
PS3="Введите:"
file="/home/alex/animals"
echo "$title"

  select opt in "${options[@]}" "Выход";
do
   case "$REPLY" in
    1 )
        while [ 1==1 ];
        do
          echo "Введите имя владельца:";
          read user;
          grep -i "^$user:" /etc/passwd >/dev/null
          if [ $? -ne 0 ];
          then
            echo "Такого пользователя не существует!">&2;
            echo "Повторить? (да/нет)"
            while [ 1==1 ];
            do
             read selection
             if [ "$selection" == "нет" ];
             then
                 break
             elif [ "$selection" == "да" ];
             then
                 break
             else
                 echo "Ошибка!"
                 echo "Попробуйте еще разок!"
		 echo "Повторить еще? (да/нет)"
             fi
             done;
           if [ "$selection" == "нет" ];
           then
               echo "1) Изменить имя владельца 3) Выход";
               echo "2) Изменить имя группы";

               break
           fi
          else
           
                if [ -d $file ];
                then
                echo "Хотите изменить рекурсивно? (да/нет)"
                        while  [ 1 ]; do
                        read ans
                        if [ "$ans" == "нет" ];
                         then
			 q=1
                         chown $user: $file
                         echo "Произошли изменения для файла папки"
                         echo "Теперь владелец - $user"
                         echo "1) Изменить имя владельца 3) Выход";
                         echo "2) Изменить имя группы";
                            break;
                        elif [ "$ans" == "да" ];
                         then
			 q=1
                         chown -R $user: $file
                         echo "Произошли изменения для всех файлов папки"
                         echo "Теперь владелец - $user"
                         echo "1) Изменить имя владельца 3) Выход";
                         echo "2) Изменить имя группы";
                         break
                        else
                         echo "Ошибка!">&2
                         echo "Попробуйте еще разок!"
                         echo "Хотите изменить рекурсивно? (да/нет)"
                         fi
                        done
                else
                        chown $user: $file
                        echo "Произошли изменения для файла"
			echo "Теперь владелец - $user"
                        echo "1) Изменить имя владельца 3) Выход";
                        echo "2) Изменить имя группы";
                        break
                fi
          fi
              if [ "$q" == 1 ]; then
              break

          fi
        done
        ;;
 2 )
        while [ 1==1 ];
        do
          echo "Введите имя группы:";
          read group;
          grep -i "^$group:" /etc/group >/dev/null
          if [ $? -ne 0 ];
          then
            echo "Такой группы не существует!">&2;
            echo "Повторить? (да/нет)"
            while [ 1==1 ];
            do
             read select
             if [ "$select" == "нет" ];
             then
                 break
             elif [ "$select" == "да" ];
             then
                 break 
             else
                 echo "Ошибка!">$2
                 echo "Попробуйте еще разок!"
                 echo "Повторить? (да/нет)"

             fi
             done;
           if [ "$select" == "нет" ];
           then
               echo "1) Изменить имя владельца 3) Выход";
               echo "2) Изменить имя группы";

                break
           fi
          else
                if [ -d $file ];
                then
                echo "Хотите изменить рекурсивно? (да/нет)"
                        while  [ 1 ]; do
                        read answ
                        if [ "$answ" == "нет" ];
                         then
                         w=1
                         chown :$group $file
                         echo "Произошли изменения для файла папки"
                         echo "Теперь группа - $group"
                         echo "1) Изменить имя владельца 3) Выход";
                         echo "2) Изменить имя группы";
                            break;
                        elif [ "$answ" == "да" ];
                         then
                         w=1
                         chown -R :$group $file
                         echo "Произошли изменения для всех файлов папки"
                         echo "Теперь группа - $user"
                         echo "1) Изменить имя владельца 3) Выход";
                         echo "2) Изменить имя группы";
                         break
                        else
                         echo "Ошибка!">&2
                         echo "Попробуйте еще разок!"
                         echo "Хотите изменить рекурсивно? (да/нет)"
                         fi
                        done
                else
                        chown :$group $file
                        echo "Произошли изменения для файла"
                        echo "Теперь группа - $group"
                        echo "1) Изменить имя владельца 3) Выход";
                        echo "2) Изменить имя группы";
                        break
                fi
          fi
              if [ "$w" == 1 ]; then
              break

          fi
        done
        ;;


    $(( ${#options[@]}+1 )) ) echo "До новых встреч!"; break;;

    * ) echo "Ошибка. Попробуйте снова!";
        echo "1) Изменить имя владельца 3) Выход";
        echo "2) Изменить имя группы";
        continue;;
esac
done

