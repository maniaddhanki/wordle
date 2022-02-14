GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BOLD="\033[1m"
NORMAL="\033[0m"

function convert_to_array () {
  local string=$1

  local index=0
  local array=()

  while [[ $index -lt ${#string} ]]
  do
    array+=("${string:$index:1}")
    index=$(( $index + 1 ))
  done

  echo "${array[*]}"
}

function check_position() {
  local actual_position=$1
  local characters_position=$2
  local result="wrong-position"
  
  if [[ $actual_position -eq $characters_position ]]
  then
    result="matched"
  fi

  echo "${result}"
}

function check_if_matching() {
  local actual_character=$1
  local users_character=$2
  local characters_position=$3
  local actual_position=$4
  local result="unmatched"

  if [[ "${users_character}" == "${actual_character}" ]]
  then
      result=$( check_position ${actual_position} ${characters_position} )
  fi

  echo "${result}"
}

function compare_characters () {
  local actual_word=( $1 )
  local users_character=$2
  local characters_position=$3

  local index=0

  while [[ $index -lt ${#actual_word[@]} ]]
  do
    local actual_character="${actual_word[$index]}"
    result=$( check_if_matching "${actual_character}" "${users_character}" $characters_position $index )
    if [[ $result != "unmatched" ]]
    then
      break
    fi
    index=$(( $index + 1 ))
  done
  echo "${result}"
}

function validate_users_word () {
  local actual_word=( $1 )
  local users_word=( $2 )
  
  local index=0
  local validation_result=()

  while [[ $index -lt ${#users_word[@]} ]]
  do
    users_character="${users_word[${index}]}"
    validation_result+=( $( compare_characters "${actual_word[*]}" "${users_character}" $index ) )
    index=$(( $index + 1 ))
  done

  echo "${validation_result[*]}"
}


function game_over() {
  local validations=( $1 )
  local winning_condition=( matched matched matched matched matched )

  if [[ "${validations[@]}" == "${winning_condition[@]}" ]]  
  then
    echo "You guessed the correct word"
    exit 0
  fi
}

function customize_color() {
  local validation=$1
  local users_character=$2

  local result="${BOLD}${users_character}"

  if [[ "${validation}" == "matched" ]]
  then
    result="${GREEN}${users_character}${NORMAL}"
  fi
  if [[ "${validation}" == "wrong-position" ]]
  then
    result="${YELLOW}${users_character}${NORMAL}"
  fi

  echo "${result}"
}

function print_result () {
  local users_word=( $1 )
  local validations=( $2 )

  local index=0
  local result=""

  while [[ $index -lt  ${#users_word[@]} ]]
  do
    local validation=${validations[$index]}
    local users_character=${users_word[$index]}
    result+=$( customize_color "${validation}" "${users_character}" )
    index=$(( ${index} + 1 ))
  done

  echo -e "${result}${NORMAL}\n"
}

function main() {
  local actual_word=$1
  local actual_word=( $(convert_to_array "${actual_word}") )
  local users_word

  echo -e "You have 6 chances to guess the word\n"
  local chances=6

  while [[ ${chances} -gt 0 ]]
  do
    read users_word
    local users_word=( $(convert_to_array "${users_word}") )
    local validations=( $(validate_users_word "${actual_word[*]}" "${users_word[*]}") )
    print_result "${users_word[*]}" "${validations[*]}"
    game_over "${validations[*]}"
    chances=$(( ${chances} - 1 ))
  done
  echo -e "The correct word was : ${BOLD}${actual_word[*]}${NORMAL}"
  exit 1
}