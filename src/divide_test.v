module onig

__global re = &RegEx(unsafe { nil })

fn testsuite_begin() {
	re = onig_new('a', opt_none)!
}

fn testsuite_end() {
	re.free()
}

fn test_split_empty_1() {
	assert re.split('', opt_none)! == ['']
}

fn test_split_empty_2() {
	assert re.split('a', opt_none)! == ['', '']
}

fn test_split_empty_3() {
	assert re.split('aa', opt_none)! == ['', '', '']
}

fn test_split_1() {
	assert re.split('b', opt_none)! == ['b']
}

fn test_split_2() {
	assert re.split('bac', opt_none)! == ['b', 'c']
}

fn test_split_3() {
	assert re.split('bacad', opt_none)! == ['b', 'c', 'd']
}

fn test_split_first_empty_1() {
	assert re.split_first('', opt_none)! == ['']
}

fn test_split_first_empty_2() {
	assert re.split_first('a', opt_none)! == ['', '']
}

fn test_split_first_empty_3() {
	assert re.split_first('aa', opt_none)! == ['', 'a']
}

fn test_split_first_1() {
	assert re.split_first('b', opt_none)! == ['b']
}

fn test_split_first_2() {
	assert re.split_first('bac', opt_none)! == ['b', 'c']
}

fn test_split_first_3() {
	assert re.split_first('bacad', opt_none)! == ['b', 'cad']
}

fn test_chop_empty_1() {
	assert re.chop('', opt_none)! == ['']
}

fn test_chop_empty_2() {
	assert re.chop('a', opt_none)! == ['', 'a', '']
}

fn test_chop_empty_3() {
	assert re.chop('aa', opt_none)! == ['', 'a', '', 'a', '']
}

fn test_chop_1() {
	assert re.chop('b', opt_none)! == ['b']
}

fn test_chop_2() {
	assert re.chop('bac', opt_none)! == ['b', 'a', 'c']
}

fn test_chop_3() {
	assert re.chop('bacad', opt_none)! == ['b', 'a', 'c', 'a', 'd']
}

fn test_chop_first_empty_1() {
	assert re.chop_first('', opt_none)! == ['']
}

fn test_chop_first_empty_2() {
	assert re.chop_first('a', opt_none)! == ['', 'a', '']
}

fn test_chop_first_empty_3() {
	assert re.chop_first('aa', opt_none)! == ['', 'a', 'a']
}

fn test_chop_first_1() {
	assert re.chop_first('b', opt_none)! == ['b']
}

fn test_chop_first_2() {
	assert re.chop_first('bac', opt_none)! == ['b', 'a', 'c']
}

fn test_chop_first_3() {
	assert re.chop_first('bacad', opt_none)! == ['b', 'a', 'cad']
}
