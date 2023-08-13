module onig

pub fn (mut r RegEx) split(s string, opt u32) ![]string {
	rg := r.get_region()
	mut parts := []string{}
	mut pos := 0
	mut last := 0
	stop := s.len
	mut end := unsafe { s.str + stop }
	for {
		res := C.onig_search(r.re, s.str, end, unsafe { s.str + pos }, end, rg, u32(opt))
		if res >= 0 {
			if rg.num_regs > 0 {
				pos = unsafe { rg.end[0] }
				parts << s[last..res]
				last = pos
				if pos == stop {
					break
				}
			} else {
				break
			}
		} else {
			if res == C.ONIG_MISMATCH {
				break
			}
			return fail_exec(res)
		}
	}
	if last < stop {
		parts << s[last..stop]
	} else {
		parts << ''
	}
	return parts
}

pub fn (mut r RegEx) split_first(s string, opt u32) ![]string {
	rg := r.get_region()
	mut parts := []string{}
	stop := s.len
	mut end := unsafe { s.str + stop }
	res := C.onig_search(r.re, s.str, end, s.str, end, rg, u32(opt))
	if res >= 0 {
		if rg.num_regs > 0 {
			parts << s[0..res]
			pos := unsafe { rg.end[0] }
			parts << s[pos..stop]
		} else {
			parts << s
		}
	} else if res == C.ONIG_MISMATCH {
		parts << s
	} else {
		return fail_exec(res)
	}
	return parts
}

pub fn (mut r RegEx) chop(s string, opt u32) ![]string {
	rg := r.get_region()
	mut parts := []string{}
	mut pos := 0
	mut last := 0
	stop := s.len
	mut end := unsafe { s.str + stop }
	for {
		res := C.onig_search(r.re, s.str, end, unsafe { s.str + pos }, end, rg, u32(opt))
		if res >= 0 {
			if rg.num_regs > 0 {
				pos = unsafe { rg.end[0] }
				parts << s[last..res]
				parts << s[res..pos]
				last = pos
				if pos == stop {
					break
				}
			} else {
				break
			}
		} else {
			if res == C.ONIG_MISMATCH {
				break
			}
			return fail_exec(res)
		}
	}
	if last < stop {
		parts << s[last..stop]
	} else {
		parts << ''
	}
	return parts
}

pub fn (mut r RegEx) chop_first(s string, opt u32) ![]string {
	rg := r.get_region()
	mut parts := []string{}
	stop := s.len
	mut end := unsafe { s.str + stop }
	res := C.onig_search(r.re, s.str, end, s.str, end, rg, u32(opt))
	if res >= 0 {
		if rg.num_regs > 0 {
			parts << s[0..res]
			pos := unsafe { rg.end[0] }
			parts << s[res..pos]
			parts << s[pos..stop]
		} else {
			parts << s
		}
	} else if res == C.ONIG_MISMATCH {
		parts << s
	} else {
		return fail_exec(res)
	}
	return parts
}
