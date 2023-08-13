module onig

fn test_new_success() {
	re := onig_new('a(.*)b|[e-f]+', opt_none)!
	re.free()
}

fn test_new_failure() {
	re := onig_new('a(.*)b|[e-f', opt_none) or {
		assert err.msg() == 'premature end of char-class'
		return
	}
	re.free()
	assert false
}

fn test_new_opt() {
	re := onig_new('a', opt_ignore_case | opt_extend)!
	defer {
		re.free()
	}
	assert re.matches('A', opt_none)!
}
