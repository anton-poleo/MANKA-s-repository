echo "Выбранная операция: изменить запись (ACL права файла)"
SetRights() {    
	actions=("Установить право на чтение" "Установить право на запись" "Установить право на исполнение" "Выход")
    select act in "${actions[@]}"
    do
		case "$REPLY" in
			1)
			    r_right='r'
			    echo "Установлено право на чтение"
			    ;;
	                2)
			    w_right='w'
			    echo "Установлено право на запись"
			    ;;
			3)
			    x_right='x'
			    echo "Установлено право на исполнение"
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


while :
do
	echo "Введите название файла:"
	read FileName
	# FileName = "$1"
	if ! [ -f $FileName ]; then
		echo "Файл не существует!">&2

	else
		SetRights
		while :
		do
			echo "Пользователь или группа?(user/group)"
                read choice
	        case "$choice" in
				user)
					while :
				        do
						echo "Введите имя пользователя:"
		                                read UserName
			                        grep "$UserName" /etc/passwd >/dev/null
			                        if [ $? -ne 0 ]; then
							echo "Пользователь $UserName не существует!">&2
			                        else
							echo "Старые права доступа:"
				                        getfacl $FileName
		                                        setfacl -m u:$UserName:$Rights $FileName
		                                        echo "Новые права доспута:"
		                                        getfacl $FileName
						    break
						fi
					done
					break
					;;
				group)
					while :
					do
						echo "Введите имя группы:"
		     	                        read GroupName
			                        grep -q -E "^$GroupName:" /etc/group >/dev/null
		                                if [ $? -ne 0 ]; then
							echo "Группа $GroupName не существует!">&2
			                        else
							echo "Старые права доступа:"
		                                        getfacl $FileName
		                                        setfacl -m g:$GroupName:$Rights $FileName
		                                        echo "Новые права доспута:"
	                                                getfacl $FileName
						    break
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
    fi
done
