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

fn test_has_negative() {
	assert !has_python_names('(?<')
}

fn test_has_positive() {
	assert has_python_names('(?P<')
}

fn test_opt_negative() {
	if _ := fix_python_names_opt('(?<') {
		assert false
	}
}

fn test_opt_positive() {
	assert fix_python_names_opt('(?P<a')! == '(?<a'
}
