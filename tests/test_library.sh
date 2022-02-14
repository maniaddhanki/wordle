source test_report.sh
source library/wordle_library.sh

function test_convert_to_array() {
  local string="radio"
  local test_description="Should convert string into an array"

  local expected=(r a d i o)
  local actual=( $( convert_to_array "${string}" ) )

  test_heading "convert_to_array"
  assert_expectation "${expected}" "${actual}" "${test_description}"
}

# Testing check_position for matched value
function test_matched_position() {
  local actual_position=3
  local characters_position=3
  local test_description="Should give result as matched"

  local expected="matched"
  local actual=$( check_position ${actual_position} ${characters_position} )

  test_heading "check_position"
  assert_expectation "${expected}" "${actual}" "${test_description}"
}

# Testing check_position for wrong-positoned value
function test_wrong_position() {
  local actual_position=3
  local characters_position=4
  local test_description="Should give result as wrong-position"

  local expected="wrong-position"
  local actual=$( check_position ${actual_position} ${characters_position} )

  assert_expectation "${expected}" "${actual}" "${test_description}"
}

# Testing check_if_matching for matched character
function test_check_if_matched() {
  local actual_character=a
  local users_character=a
  local characters_position=3
  local actual_position=3
  local test_description="Should give result as matched"

  local expected="matched"
  local actual=$( check_if_matching "${actual_character}" "${users_character}" $characters_position $actual_position )
  
  test_heading "check_if_matching"
  assert_expectation "${expected}" "${actual}" "${test_description}"
}

# Testing check_if_matching for unmatched character
function test_check_if_unmatched() {
  local actual_character=a
  local users_character=t
  local characters_position=3
  local actual_position=3
  local test_description="Should give result as unmatched"

  local expected="unmatched"
  local actual=$( check_if_matching "${actual_character}" "${users_character}" $characters_position $actual_position )
  
  assert_expectation "${expected}" "${actual}" "${test_description}"
}

# Testing compare_characters for matched character
function test_compare_matched_characters () {
  local actual_word=( t o d a y )
  local users_character="d"
  local characters_position=2
  local test_description="Should give result as matched"

  local expected="matched"
  local actual=$( compare_characters "${actual_word[*]}" "${users_character}" ${characters_position} )

  test_heading "compare_characters"
  assert_expectation "${expected}" "${actual}" "${test_description}"
}

# Testing compare_characters for unmatched character
function test_compare_unmatched_characters () {
  local actual_word=( t o d a y )
  local users_character="x"
  local characters_position=2
  local test_description="Should give result as unmatched"

  local expected="unmatched"
  local actual=$( compare_characters "${actual_word[*]}" "${users_character}" ${characters_position} )

  assert_expectation "${expected}" "${actual}" "${test_description}"
}

function test_validate_users_word () {
  local actual_word=( t o d a y )
  local users_word=( t a n g o )
  local test_description="Should give validation array"

  local expected=( "matched" "wrong-position" "unmatched" "unmatched" "wrong-position" )
  local actual=( $(validate_users_word "${actual_word[*]}" "${users_word[*]}") )

  test_heading "validate_users_word"
  assert_expectation "${expected[*]}" "${actual[*]}" "${test_description}"
}

# Testing game_over for winning condition 
function test_winning_condition () {
  local validations=( "matched" "matched" "matched" "matched" "matched" )
  local test_description="Should give the winning message"

  local expected="You guessed the correct word"
  local actual=$( game_over "${validations[*]}" )

  test_heading "game_over"
  assert_expectation "${expected}" "${actual}" "${test_description}"
}

# Testing game_over for continuation of game
function test_game_continuation () {
  local validations=( "matched" "unmatched" "matched" "matched" "matched" )
  local test_description="Should continue the game without any message"

  local expected=""
  local actual=$( game_over "${validations[*]}" )

  assert_expectation "${expected}" "${actual}" "${test_description}"
}

# Testing customize_color for matched
function test_customize_color_matched () {
  local validation="matched"
  local users_character="a"
  local test_description="Should give green color character"

  local expected="${GREEN}${users_character}${NORMAL}"
  local actual=$( customize_color "${validation}" "${users_character}" )

  test_heading "customize_color"
  assert_expectation "${expected}" "${actual}" "${test_description}"
}

# Testing customize_color for unmatched
function test_customize_color_unmatched () {
  local validation="unmatched"
  local users_character="a"
  local test_description="Should give default color character"

  local expected="${BOLD}${users_character}"
  local actual=$( customize_color "${validation}" "${users_character}" )

  assert_expectation "${expected}" "${actual}" "${test_description}"
}

# Testing customize_color for wrong-position
function test_customize_color_wrong_position () {
  local validation="wrong-position"
  local users_character="a"
  local test_description="Should give yellow color character"

  local expected="${YELLOW}${users_character}${NORMAL}"
  local actual=$( customize_color "${validation}" "${users_character}" )

  assert_expectation "${expected}" "${actual}" "${test_description}"
}

function test_print_result () {
  local users_word=( t a n g o )
  local validations=( "matched" "wrong-position" "unmatched" "unmatched" "wrong-position" )
  local test_description="Should give colored result"

  local expected=$(echo -e "${GREEN}t${NORMAL}${YELLOW}a${NORMAL}${BOLD}n${BOLD}g${YELLOW}o${NORMAL}${NORMAL}\n")
  local actual=$( print_result "${users_word[*]}" "${validations[*]}" )
  
  test_heading "print_result"
  assert_expectation "${expected}" "${actual}" "${test_description}"
}

# Testing main for wrong guesses
function test_main_wrong_guesses () {
  local actual_word="today"
  local guesses="tango
mango
tango
tango
tango
tango"

  local test_description="Should give the correct word when all guesses are wrong"
  
  local expected=$( echo -e "You have 6 chances to guess the word\n
${GREEN}t${NORMAL}${YELLOW}a${NORMAL}${BOLD}n${BOLD}g${YELLOW}o${NORMAL}${NORMAL}\n
${BOLD}m${YELLOW}a${NORMAL}${BOLD}n${BOLD}g${YELLOW}o${NORMAL}${NORMAL}\n
${GREEN}t${NORMAL}${YELLOW}a${NORMAL}${BOLD}n${BOLD}g${YELLOW}o${NORMAL}${NORMAL}\n
${GREEN}t${NORMAL}${YELLOW}a${NORMAL}${BOLD}n${BOLD}g${YELLOW}o${NORMAL}${NORMAL}\n
${GREEN}t${NORMAL}${YELLOW}a${NORMAL}${BOLD}n${BOLD}g${YELLOW}o${NORMAL}${NORMAL}\n
${GREEN}t${NORMAL}${YELLOW}a${NORMAL}${BOLD}n${BOLD}g${YELLOW}o${NORMAL}${NORMAL}\n
The correct word was : ${BOLD}t o d a y${NORMAL}" )
  local actual=$( main "${actual_word}" <<< "${guesses}" )

  test_heading "main"
  assert_expectation "${expected}" "${actual}" "${test_description}"
}

# Testing main for correct guess
function test_main_correct_guess () {
  local actual_word="today"
  local guesses="today"

  local test_description="Should give the winning message when guess is correct"
  
  local expected=$( echo -e "You have 6 chances to guess the word\n
${GREEN}t${NORMAL}${GREEN}o${NORMAL}${GREEN}d${NORMAL}${GREEN}a${NORMAL}${GREEN}y${NORMAL}${NORMAL}\n
You guessed the correct word" )
  local actual=$( main "${actual_word}" <<< "${guesses}" )

  assert_expectation "${expected}" "${actual}" "${test_description}"
}