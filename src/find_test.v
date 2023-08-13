module onig

__global re = &RegEx(unsafe { nil })

fn testsuite_begin() {
	re = onig_new('a', opt_none)!
}

fn testsuite_end() {
	re.free()
}

fn test_matches_yes() {
	assert re.matches('a', opt_none)!
	assert re.matches_within(' a', 1, -1, opt_none)!
	assert re.matches_within('a ', 0, 1, opt_none)!
}

fn test_matches_no() {
	assert !re.matches('b', opt_none)!
	assert !re.matches('a ', opt_none)!
	assert !re.matches(' a', opt_none)!
	assert !re.matches_within('a', 0, 0, opt_none)!
	assert !re.matches_within(' a', 0, -1, opt_none)!
	assert !re.matches_within('a ', 1, -1, opt_none)!
}

fn test_contains_yes() {
	assert re.contains('aa', opt_none)!
	assert re.contains(' aa', opt_none)!
	assert re.contains_within('aa ', 1, -1, opt_none)!
}

fn test_contains_no() {
	assert !re.contains('b', opt_none)!
	assert !re.contains_within('a ', 0, 0, opt_none)!
	assert !re.contains_within('a ', 1, -1, opt_none)!
}

fn test_starts_with_yes() {
	assert re.starts_with('a ', opt_none)!
	assert re.starts_with_within(' a ', 1, -1, opt_none)!
}

fn test_starts_with_no() {
	assert !re.starts_with('b', opt_none)!
	assert !re.starts_with(' a ', opt_none)!
	assert !re.starts_with_within('a ', 0, 0, opt_none)!
	assert !re.starts_with_within('a ', 1, -1, opt_none)!
}

fn test_index_of_yes() {
	assert re.index_of('aa', opt_none)! == 0
	assert re.index_of(' aa', opt_none)! == 1
	assert re.index_of_within('aa ', 1, -1, opt_none)! == 1
}

fn test_index_of_no() {
	assert re.index_of('b', opt_none)! == -1
	assert re.index_of_within('a ', 0, 0, opt_none)! == -1
	assert re.index_of_within('a ', 1, -1, opt_none)! == -1
}

fn test_index_range_yes() {
	mut start, mut end := re.index_range('aa', opt_none)!
	assert start == 0
	assert end == 1
	start, end = re.index_range(' aa', opt_none)!
	assert start == 1
	assert end == 2
	start, end = re.index_range_within('aa ', 1, -1, opt_none)!
	assert start == 1
	assert end == 2
}

fn test_index_range_no() {
	mut start, mut end := re.index_range('b', opt_none)!
	assert start == -1
	assert end == -1
	start, end = re.index_range_within('a ', 0, 0, opt_none)!
	assert start == -1
	assert end == -1
	start, end = re.index_range_within('a ', 1, -1, opt_none)!
	assert start == -1
	assert end == -1
}

fn test_last_index_of_yes() {
	assert re.last_index_of('aa', opt_none)! == 1
	assert re.last_index_of('aa ', opt_none)! == 1
	assert re.last_index_of_within('aa', 0, 1, opt_none)! == 0
}

fn test_last_index_of_no() {
	assert re.last_index_of('b', opt_none)! == -1
	assert re.last_index_of_within('a ', 0, 0, opt_none)! == -1
	assert re.last_index_of_within('a ', 1, -1, opt_none)! == -1
}

fn test_last_index_range_yes() {
	mut start, mut end := re.last_index_range('aa', opt_none)!
	assert start == 1
	assert end == 2
	start, end = re.last_index_range('aa ', opt_none)!
	assert start == 1
	assert end == 2
	start, end = re.last_index_range_within('aa', 0, 1, opt_none)!
	assert start == 0
	assert end == 1
}

fn test_last_index_range_no() {
	mut start, mut end := re.last_index_range('b', opt_none)!
	assert start == -1
	assert end == -1
	start, end = re.last_index_range_within('a ', 0, 0, opt_none)!
	assert start == -1
	assert end == -1
	start, end = re.last_index_range_within('a ', 1, -1, opt_none)!
	assert start == -1
	assert end == -1
}

fn test_ends_with_yes() {
	assert re.ends_with(' a', opt_none)!
	assert re.ends_with_within('  a', 1, -1, opt_none)!
}

fn test_ends_with_no() {
	assert !re.ends_with('b', opt_none)!
	assert !re.ends_with(' a ', opt_none)!
	assert !re.ends_with_within(' a', 0, 0, opt_none)!
	assert !re.ends_with_within(' a ', 1, -1, opt_none)!
}

fn test_count_of_yes() {
	assert re.count_of('aa', opt_none)! == 2
	assert re.count_of(' aa', opt_none)! == 2
	assert re.count_of_within('aa ', 1, -1, opt_none)! == 1
}

fn test_count_of_no() {
	assert re.count_of('b', opt_none)! == 0
	assert re.count_of_within('a ', 0, 0, opt_none)! == 0
	assert re.count_of_within('a ', 1, -1, opt_none)! == 0
}
