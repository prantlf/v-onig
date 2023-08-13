module onig

fn test_clone() {
	mut custom := Syntax.clone(syntax_perl)
	assert custom == unsafe { &Syntax(syntax_perl) }
}

fn test_customise() {
	mut custom := Syntax.clone(syntax_perl)
	assert custom == unsafe { &Syntax(syntax_perl) }
	custom.op2 |= syn_op2_qmark_lt_named_group
	re := onig_new_custom('(?<test>.)', opt_none, encoding_ascii, custom)!
	defer {
		re.free()
	}
	assert re.matches('a', opt_none)!
}
