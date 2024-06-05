 #!/bin/bash                                                                          

#Colours    
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"                                                                  
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"  
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"             
turquoiseColour="\e[0;36m\033[1m"                        
grayColour="\e[0;37m\033[1m"
  
function ctrl_c(){                       
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm; exit 1                                                                                                  
}    

#Ctrl+C                                             
trap ctrl_c INT

function helpPanel(){                                                             
  echo -e "\n${yellowColour}[+]${endColour}${greyColour} Uso:${endColour}${purpleColour} $0${endColour}\n"
  echo -e "\t${blueColour}-m)${endColour}${greyColour} Dinero con el que se desea jugar${endColour}"                   
  echo -e "\t${blueColour}-t)${endColour}${greyColour} Técnica a utilizar${endColour}${purpleColour} (${endColour}${yellowColour}martingala${endColour}${blueColour}/${endColour}${yellowColour}inverseLabrouchere${endColour}${purpleColour})${endColour}\n"
  exit 1                                                      
}                                          
            
function martingala(){                                                                                                  
  echo -e "\n${yellowColour}[+]${endColour}${greyColour} Dinero actual:${endColour}${yellowColour} $money€${endColour}"
  echo -ne "${yellowColour}[+]${endColour}${greyColour} ¿Cuánto dinero tienes pensado apostar? -> ${endColour}" && read initial_bet                                   
  echo -ne "${yellowColour}[+]${endColour}${greyColour} ¿A qué deseas apostar continuamente (par/impar)? -> ${endColour}" && read par_impar                   
            
#  echo -e "\n${yellowColour}[+]${endColour}${greyColour} Vamos a jugar con una cantidad inicial de${endColour}${yellowColour} $initial_bet€${endColour}${greyColour} a${endColour}${yellowColour} $par_impar${endColour}"
            
  backup_bet=$initial_bet     
  play_counter=0
  jugadas_malas=" "                        
  max_money=$money                                                        
                            
  tput civis # Ocultar el cursor                                                                         
  while true; do    
  
        money=$(($money-$initial_bet))                                                                                
#    echo -e "\n${yellowColour}[+]${endColour}${greyColour} Acabas de apostar${endColour}${yellowColour} $initial_bet€${endColour}${greyColour} y tienes${endColour}${yellowColour} $money€${endColour}"
    random_number="$(($RANDOM % 37))"               
#    echo -e "${yellowColour}[+]${endColour}${greyColour} Ha salido el número${endColour}${blueColour} $random_number${endColour}"
#                                                                                 
    if [ ! "$money" -lt 0 ]; then # debería ser -lt "$initial_bet"                                        
      if [ "$par_impar" == "par" ]; then                                                                               
        if [ "$(($random_number % 2))" -eq 0 ]; then
          if [ "$random_number" -eq 0 ]; then                                                                                
#            echo -e "${redColour}[+] Ha salido 0${endColour}"
            initial_bet=$(($initial_bet*2))
            jugadas_malas+="$random_number "
#            echo -e "${yellowColour}[+]${endColour}${greyColour} Tienes${endColour}${yellowColour} $money€${endColour}"
          else                                                                                                         
#            echo -e "${yellowColour}[+]${endColour}${greenColour} El número es par, ¡ganas!${endColour}"
            reward=$(($initial_bet*2))
#            echo -e "${yellowColour}[+]${endColour}${greyColour} Ganas un total de${endColour}${yellowColour} $reward€${endcolour}"                          
            money=$(($money+$reward))
#            echo -e "${yellowColour}[+]${endColour}${greyColour} Tienes${endColour}${yellowColour} $money€${endColour}"
            initial_bet=$backup_bet                                                       
            if [ "$max_money" -le "$money" ]; then
              max_money=$money
            fi  
            jugadas_malas=""               
          fi                                                              
        else                
#          echo -e "${yellowColour}[+]${endColour}${redColour} El número es impar, ¡pierdes!${endColour}"
          initial_bet=$(($initial_bet*2))
          jugadas_malas+="$random_number "
#          echo -e "${yellowColour}[+]${endColour}${greyColour} Tienes${endColour}${yellowColour} $money€${endColour}"
        fi
      else # Para impares                                               
        if [ "$(($random_number % 2))" -eq 0 ]; then
            initial_bet=$(($initial_bet*2))
            jugadas_malas+="$random_number "
        else                                                                      
          reward=$(($initial_bet*2))                              
          money=$(($money+$reward))                                                                                    
          initial_bet=$backup_bet                   
          if [ "$max_money" -le "$money" ]; then                            
            max_money=$money                                  
          fi                               
          jugadas_malas=""                  

        fi    

      fi                              
    else      
      echo -e "\n${redColour}[!] No hay dinero para apostar${endColour}\n"
      echo -e "${yellowColour}[+]${endColour}${greyColour} Han habido un total de${endColour}${yellowColour} $play_counter${endColour}${greyColour} jugadas${endColour}${greyColour} con un máximo de dinero ganado de${endColour}${greenColour} $max_money€${endColour}"                                         
      echo -e "\n${yellowColour}[+]${endColour}${greyColour} A continuación se van a representar las malas jugadas consecutivas que han salido:${endColour}\n"
      echo -e "${blueColour}$jugadas_malas${endColour}\n"
      tput cnorm; exit 0
    fi

    let play_counter+=1

  done

  tput cnorm # Recuperamos el cursor
}

function inverseLabrouchere(){

  echo -e "\n${yellowColour}[+]${endColour}${greyColour} Dinero actual:${endColour}${yellowColour} $money€${endColour}"
  echo -ne "${yellowColour}[+]${endColour}${greyColour} ¿A qué deseas apostar continuamente (par/impar)? -> ${endColour}" && read par_impar

  declare -a my_sequence=(1 2 3 4)
  max_money=5

  echo -e "\n${yellowColour}[+]${endColour}${greyColour} Comenzamos con la secuencia${endColour}${greenColour} [${my_sequence[@]}]${endColour}"

  tput civis
  while true; do
    if [ "${#my_sequence[@]}" -eq 1 ];then
      bet=${my_sequence[0]}
    else
      if [ "${#my_sequence[@]}" -eq 0 ];then
        my_sequence=(1 2 3 4)
      fi
      bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
    fi
    money=$(($money - $bet))
    if [ ! "$money" -lt 0 ]; then
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Invertimos${endColour}${yellowColour} $bet€${endColour} y nos quedamos con${endColour}${blueColour} $money€${endColour}"

      random_number=$(($RANDOM % 37))
      echo -e "\n${yellowColour}[+]${endColour}${greyColour} Ha salido el número${endColour}${blueColour} $random_number${endColour}"

      if [ "$par_impar" == "par" ]; then
        if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ]; then
          echo "[+] El número es par, ¡ganas!"
          reward=$(($bet*2))
          let money+=$reward
          if [ "$max_money" -le "$money" ]; then
                max_money=$money
          fi
          echo "[+] Tienes $money€"
          my_sequence+=($bet)
          my_sequence=(${my_sequence[@]})
          echo "[+] Mi nueva secuencia es [${my_sequence[@]}]"
        else
          echo "[+] El número es impar o 0, ¡pierdes!"
          unset my_sequence[0]
          unset my_sequence[-1] 2>/dev/null

❯ nvim ruleta.sh
❯ nvim ruleta.sh

    /opt/ruleta  󰈸  took  13s  ✔  >....                                                                                
    money=$(($money - $bet))
    if [ ! "$money" -lt 0 ]; then
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Invertimos${endColour}${yellowColour} $bet€${endColour} y nos quedamos con${endColour}${blueColour} $money€${endColour}" 

      random_number=$(($RANDOM % 37))
      echo -e "\n${yellowColour}[+]${endColour}${greyColour} Ha salido el número${endColour}${blueColour} $random_number${endColour}"

      if [ "$par_impar" == "par" ]; then
        if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ]; then
          echo "[+] El número es par, ¡ganas!"
          reward=$(($bet*2))
          let money+=$reward
          if [ "$max_money" -le "$money" ]; then
                max_money=$money
          fi
          echo "[+] Tienes $money€"
          my_sequence+=($bet)
          my_sequence=(${my_sequence[@]})
          echo "[+] Mi nueva secuencia es [${my_sequence[@]}]"
        else
          echo "[+] El número es impar o 0, ¡pierdes!"
          unset my_sequence[0]
          unset my_sequence[-1] 2>/dev/null
          my_sequence=(${my_sequence[@]})

          echo "[+] Mi nueva secuencia es [${my_sequence[@]}]"
        fi
      fi
    else
      echo -e "\n${redColour}[!] No hay dinero para apostar${endColour}\n"
      echo -e "${yellowColour}[+]${endColour}${greyColour} Ha habido un máximo de dinero ganado de${endColour}${greenColour} $max_money€${endColour}"
      tput cnorm; exit 0
    fi
  done

  tput cnorm

}

while getopts "m:t:h" arg; do
  case $arg in
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) helpPanel;;
  esac
done

if [ $money ] && [ $technique ]; then
  if [ "$technique" == "martingala" ]; then
    martingala
  elif [ "$technique" == "inverseLabrouchere" ]; then
    inverseLabrouchere
  else
    echo -e "\n${redColour}[!] La técnica introducida no existe${endColour}"
    helpPanel
  fi
else
  helpPanel
fi

