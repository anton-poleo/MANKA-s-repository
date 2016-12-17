#!bin/bash
if [ "$(id -u)" != "0" ]; then
   echo "Для запуска приложения нужны права root">&2
   exit 1
fi
echo "С помощью данной программы вы можете управлять безопасностью файлов и каталогов
Разработчики: Сапегина, Полеводин, Конохова, Молоткова, Языкова"


	options=("1) Работа с файлом или каталогом"
                 "2) Поиск файлов, доступных всем пользователям на запись"
                 "3) Выход"
                 "4) Помощь")

while :


do
	echo ""
	echo "Главное меню"

	#select opt in "${options[@]}"
	echo ""
	for opt in "${options[@]}"
	do
		echo "$opt"
	done
	read REPLY
		case "$REPLY" in
			1)
			flag="true"
			if [[ -a $1 || -d $1 ]] && [ $# == 1 ];
			then
				path="$1"
			else
				flag="y"
				while [[ "$flag" == "Y" || "$flag" == "y" ]]
				do
					echo ""
					echo "Неверно введено имя файла или неправильное колличество аргументов, введите пожалуйста имя файла">&2
					read -e path
					if [[ -f "$path" || -d "$path" ]]
					then
						flag="true"
					else 
						echo ""
						echo "Неверное имя файла">&2
						echo " Ввести снова?y/n"
						read -e flag
					fi
				done
			fi
			if [ "$flag" == "true" ];
			then
				option=("1) Изменить права доступа"	
					"2) Изменить владельца и группу"	
					"3) Изменить ACL права"
					"4) Назад"
					"5) Помощь")
					
				#select opt in "${option[@]}"
				while :
				do
					echo ""
				for opti in "${option[@]}"
				do
					echo "$opti"
				done
					read REPL
					case "$REPL" in
						1)./change_mode.sh "$path"							
						break
						;;	
						2)./touch2.sh "$path"
						break
						;;
						3)./acl.sh "$path"
						break
						;;
						4)
						break
						;;
						5)
						echo ""
						echo "Выберите, что вы хотите сделать с файлом или каталогом"
						;;
						*)
						echo ""
						echo "Неправильная опция">&2
						;;
	
					esac
				done
			fi
			;;
			2)
			./fileSearch.sh
			;;
			3)
			break
			;;
			4)
			echo ""
			echo "Выберите опцию, которую хотите выполнить"
			;;
			*)echo "Неправильная опция">&2
			;;
		esac
	#done
done
