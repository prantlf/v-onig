module onig

fn test_empty() {
	assert fix_python_names('') == ''
}

fn test_missing() {
	assert fix_python_names('a') == 'a'
}

fn test_trailing_1() {
	assert fix_python_names('(?P<') == '(?P<'
}

fn test_trailing_2() {
	assert fix_python_names(' (?P<') == ' (?P<'
}

fn test_name_1() {
	assert fix_python_names('(?P<a') == '(?<a'
}

fn test_name_2() {
	assert fix_python_names(' (?P<a ') == ' (?<a '
}

fn test_two_names_1() {
	assert fix_python_names('(?P<(?P<b') == '(?<(?<b'
}

fn test_two_names_2() {
	assert fix_python_names(' (?P< (?P<b') == ' (?< (?<b'
}

fn test_two_names_3() {
	assert fix_python_names(' (?P<a (?P<b ') == ' (?<a (?<b '
}
