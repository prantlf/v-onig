module onig

fn test_init_all_encs() {
	onig_init()!
	defer {
		onig_end()
	}
	mut re := onig_new('a(.*)b|[e-f]+', opt_none)!
	re.free()
	re = onig_new_utf8('a(.*)b|[e-f]+', opt_none)!
	re.free()
}

fn test_init_one_enc() {
	onig_init(encoding_ascii)!
	defer {
		onig_end()
	}
	re := onig_new('a(.*)b|[e-f]+', opt_none)!
	re.free()
	// re = onig_new_utf8('a(.*)b|[e-f]+', onig.opt_none)!
	// re.free()
}
