module onig

pub fn onig_init(encs ...voidptr) ! {
	mut use_encs := []voidptr{cap: 2}
	if encs.len > 0 {
		for enc in encs {
			use_encs << enc
		}
	} else {
		use_encs << encoding_ascii
		use_encs << encoding_utf8
	}
	res := C.onig_initialize(use_encs.data, use_encs.len)
	if res != C.ONIG_NORMAL {
		return error('initialisation failed: ${res}')
	}
}

pub fn onig_end() {
	C.onig_end()
}
