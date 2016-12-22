#!/bin/bash

choose_u_or_g()
{
    while :
    do
	echo "Выберите пользователя или группу (u/g):"
	read choice_u_or_g
	if test "$choice_u_or_g" = u 
	    then
		echo "Вы выбрали пользователя"
		echo "Введите имя пользователя:"
		read name
		grep "$name" /etc/passwd >/dev/null
		if [ $? -ne 0 ]; then
		    echo "Пользователь $name не существует!">&2
		    continue
		else
		    break
		fi
	elif test "$choice_u_or_g" = g
	    then
		echo "Вы выбрали группу"
		echo "Введите имя группы:"
		read name
		grep -q -E "^$name:" /etc/group >/dev/null
		if [ $? -ne 0 ]; then
		    echo "Группа $name не существует!">&2
		    continue
		else
		    break
		fi
	else 
	    echo "Вы ввели неверную букву" >&2
	    continue
	fi
    done
}

SetRights() {    
	actions=("Установить право на чтение" "Установить право на запись" "Установить право на исполнение" "Выход")
        select act in "${actions[@]}"
        do
		case "$REPLY" in
			1)
			    r_right='r'
			    echo "Выбрано право на чтение"
			    ;;
	                2)
			    w_right='w'
			    echo "Выбрано право на запись"
			    ;;
			3)
			    x_right='x'
			    `echo "Выбрано право на исполнение"
			    ;;
			4)
			    break
			    ;;
			*) echo "Неверный ввод">&2
			   continue
			   ;;
		esac
    done
    Rights="$r_right$w_right$x_right"
}

ch=' ';
if [ -d $1 ]; then
    while :
	do
		echo "Выполнить действие рекурсивно для всех файлов директории? (да/нет)"
		read a;
		if test "$a" = "да"; then
			ch=d
			break
		elif test "$a" = "нет"; then 
			ch=f
			echo "Действие будет применено к директории"
			break
		else
			echo "Вы ввели неверную букву"
		fi
    done
else
    ch=f
fi

file_name="$1"
PS3="Введите номер пункта меню: "
options=("Добавить запись" "Удалить запись" "Изменить запись" "Выйти")

select opt in "${options[@]}"
do
    case "$opt" in
	"Добавить запись")
	    choose_u_or_g
	    while :
	    do
		echo "Добавить право на чтение? (да/нет)"
		read answ1
		if test "$answ1" = "да"; then
		    if test "$ch" = f; then
			setfacl -m "$choice_u_or_g:$name:r" $file_name
		    else
			setfacl -R -m "$choice_u_or_g:$name:r" $file_name
		    fi
		    echo "Добавлено право на чтение"
		    break
		elif test "$answ1" = "нет"; then
		    break
		else
		    echo "Вы ввели неверную букву. Попробуйте еще раз!"
		    continue
		fi
	    done
	    while :
	    do
		echo "Добавить право на запись? (да/нет)"
		read answ2
		if test "$answ2" = "да"; then
		    if test "$answ1" = "да"; then
			if test "$ch" = f; then
			    setfacl -m "$choice_u_or_g:$name:rw" $file_name
			else
			    setfacl -R -m "$choice_u_or_g:$name:rw" $file_name
			fi
		    else
			if test "$ch" = f; then
			    setfacl -m "$choice_u_or_g:$name:w" $file_name
			else
			    setfacl -R -m "$choice_u_or_g:$name:w" $file_name
			fi
		    fi
		    echo "Добавлено право на запись"
		    break
		elif test "$answ2" = "нет"; then
		    break
		else
		    echo "Вы ввели неверную букву. Попробуйте еще раз!"
		    continue
		fi
	    done
	    while :
	    do
		echo "Добавить право на исполнение? (да/нет)"
		read answ3
		if test "$answ3" = "да"; then
		    if test "$answ2" = "да"; then
			if test "$answ1" = "да"; then
			    if test "$ch" = f; then
				setfacl -m "$choice_u_or_g:$name:rwx" $file_name
			    else
				setfacl -R -m "$choice_u_or_g:$name:rwx" $file_name
			    fi
			else
			    if test "$ch" = f; then
				setfacl -m "$choice_u_or_g:$name:wx" $file_name
			    else
				setfacl -R -m "$choice_u_or_g:$name:wx" $file_name
			    fi
			fi
		    else
			if test "$answ1" = "да"; then
			    if test "$ch" = f; then
				setfacl -m "$choice_u_or_g:$name:rx" $file_name
			    else
				setfacl -R -m "$choice_u_or_g:$name:rx" $file_name
			    fi
			else
			    if test "$ch" = f; then
				setfacl -m "$choice_u_or_g:$name:x" $file_name
			    else
				setfacl -R -m "$choice_u_or_g:$name:x" $file_name
			    fi
			fi
		    fi
		    echo "Добавлено право на исполнение"
		    break
		elif test "$answ3" = "нет"; then
		    break
		else
		    echo "Вы ввели неверную букву. Попробуйте еще раз!"
		    continue
		fi
	    echo "Запись успешно добавлена"
	    echo " "
	    done
	    ;;
	    
	"Удалить запись")
	    choose_u_or_g
	    if test "$ch" = f; then
		setfacl -x $choice_u_or_g:$name: $file_name
	    else
		setfacl -R -x $choice_u_or_g:$name: $file_name
	    fi
	    echo "Запись удалена"
	    echo " "
	    ;;
	"Изменить запись")
            while :
            do
                SetRights
                while :
                do
					echo "Пользователь или группа?(u/g)"
                    read choice
					case "$choice" in
						u)
						while :
						do
							echo "Введите имя пользователя:"
							read UserName
			                		grep "$UserName" /etc/passwd >/dev/null
			               			if [ $? -ne 0 ]; then
								echo "Пользователь $UserName не существует!">&2
			                		else
								if test "$ch" = f; then
									echo "Старые права доступа:"
									getfacl $file_name
									setfacl -m u:$UserName:$Rights $file_name
									echo "Новые права доступа:"
									getfacl $file_name
									break
								elif test "$ch" = d; then 
									echo "Старые права доступа:"
							        	getfacl -R $file_name
									setfacl -R -m u:$UserName:$Rights $file_name
									echo "Новые права доступа:"
									getfacl -R $file_name
									break
								fi
							fi
				        	done
				        	break
				        	;;
						g)
						while :
						do
							echo "Введите имя группы:"
		     	            			read GroupName
			                		grep -q -E "^$GroupName:" /etc/group >/dev/null
		                    			if [ $? -ne 0 ]; then
								echo "Группа $GroupName не существует!">&2
			                		else
								if test "$ch" = f; then
									echo "Старые права доступа:"
									getfacl $file_name
									setfacl -m g:$UserName:$Rights $file_name
									echo "Новые права доступа:"
									getfacl $file_name
									break
								elif test "$ch" = d; then 
									echo "Старые права доступа:"
									getfacl -R $file_name
									setfacl -R -m g:$UserName:$Rights $file_name
									echo "Новые права доступа:"
									getfacl -R $file_name
									break
								fi
							fi
						done
			            		break
			            		;;
						*) 
						echo "Неверный ввод!">&2
						continue
						;;
		    	    		esac
		        	done
				break
	done
    	;;
	"Выйти")
	break
	;;
	*) 
	echo "Неверный аргумент"
	;;
	esac
done

