module onig

__global (
	re     = &RegEx(unsafe { nil })
	re_grp = &RegEx(unsafe { nil })
)

fn testsuite_begin() {
	re = onig_new('a', opt_none)!
	re_grp = onig_new('a(\\w)', opt_none)!
}

fn testsuite_end() {
	re.free()
	re_grp.free()
}

fn test_replace_empty() {
	assert re.replace('', 'c', opt_none)! == ''
}

fn test_replace_no() {
	assert re.replace('b', 'c', opt_none)! == 'b'
}

fn test_replace_yes() {
	assert re.replace('a', 'c', opt_none)! == 'c'
}

fn test_replace_after() {
	assert re.replace('ba', 'c', opt_none)! == 'bc'
}

fn test_replace_before() {
	assert re.replace('ab', 'c', opt_none)! == 'cb'
}

fn test_replace_two() {
	assert re.replace('aa', 'c', opt_none)! == 'cc'
}

fn test_replace_between() {
	assert re.replace('babab', 'c', opt_none)! == 'bcbcb'
}

fn test_replace_first_empty() {
	assert re.replace_first('', 'c', opt_none)! == ''
}

fn test_replace_first_no() {
	assert re.replace_first('b', 'c', opt_none)! == 'b'
}

fn test_replace_first_yes() {
	assert re.replace_first('a', 'c', opt_none)! == 'c'
}

fn test_replace_first_after() {
	assert re.replace_first('ba', 'c', opt_none)! == 'bc'
}

fn test_replace_first_before() {
	assert re.replace_first('ab', 'c', opt_none)! == 'cb'
}

fn test_replace_first_only() {
	assert re.replace_first('aa', 'c', opt_none)! == 'ca'
}

fn test_replace_plain() {
	assert re_grp.replace('ab', 'c', opt_replace_groups)! == 'c'
}

fn test_replace_group() {
	assert re_grp.replace('ab', '$1', opt_replace_groups)! == 'b'
}

fn test_replace_group_within() {
	assert re_grp.replace('ab', 'c$1d', opt_replace_groups)! == 'cbd'
}

fn test_replace_whole() {
	assert re_grp.replace('ab', '$0', opt_replace_groups)! == 'ab'
}

fn test_replace_group_out() {
	assert re_grp.replace('ab', '$2', opt_replace_groups)! == ''
}

fn test_replace_escaped_group() {
	assert re_grp.replace('ab', '\\$1', opt_replace_groups)! == '$1'
}

fn test_replace_escaped_group_within() {
	assert re_grp.replace('ab', 'c\\$1d', opt_replace_groups)! == 'c$1d'
}

fn test_replace_no_group() {
	assert re_grp.replace('ab', r'$c', opt_replace_groups)! == r'$c'
}

fn test_replace_escape() {
	assert re_grp.replace('ab', '\\', opt_replace_groups)! == '\\'
}

fn test_replace_two_escapes() {
	assert re_grp.replace('ab', '\\\\', opt_replace_groups)! == '\\\\'
}

fn test_replace_disabled_groups() {
	assert re_grp.replace('ab', '$1', opt_none)! == '$1'
}
