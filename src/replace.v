module onig

import strings { Builder, new_builder }

pub fn (mut r RegEx) replace(s string, with string, opt u32) !string {
	repl_grps := opt & opt_replace_groups != 0
	rg := r.get_region()
	mut builder := new_builder(s.len + with.len)
	mut pos := 0
	mut last := 0
	stop := s.len
	end := unsafe { s.str + stop }
	for {
		res := C.onig_search(r.re, s.str, end, unsafe { s.str + pos }, end, rg, u32(opt))
		if res >= 0 {
			if rg.num_regs > 0 {
				unsafe { builder.write_ptr(s.str + last, res - last) }
				if repl_grps {
					replace_with(mut builder, s, with, rg)
				} else {
					builder.write_string(with)
				}
				pos = unsafe { rg.end[0] }
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
		unsafe { builder.write_ptr(s.str + last, stop - last) }
	}
	return builder.str()
}

pub fn (mut r RegEx) replace_first(s string, with string, opt u32) !string {
	repl_grps := opt & opt_replace_groups != 0
	rg := r.get_region()
	mut builder := new_builder(s.len + with.len)
	stop := s.len
	mut end := unsafe { s.str + stop }
	res := C.onig_search(r.re, s.str, end, s.str, end, rg, u32(opt))
	if res >= 0 {
		if rg.num_regs > 0 {
			unsafe { builder.write_ptr(s.str, res) }
			if repl_grps {
				replace_with(mut builder, s, with, rg)
			} else {
				builder.write_string(with)
			}
			pos := unsafe { rg.end[0] }
			len := stop - pos
			if len > 0 {
				unsafe { builder.write_ptr(s.str + pos, len) }
			}
			return builder.str()
		}
		return s
	}
	if res == C.ONIG_MISMATCH {
		return s
	}
	return fail_exec(res)
}

[direct_array_access]
fn replace_with(mut builder Builder, s string, with string, rg &C.OnigRegion) {
	mut from := with.index_u8(`$`)
	if from < 0 {
		builder.write_string(with)
		return
	}

	mut prev := if from > 0 {
		if with[from - 1] != `\\` {
			unsafe { builder.write_ptr(with.str, from) }
			`\0`
		} else {
			if from - 1 > 0 {
				unsafe { builder.write_ptr(with.str, from - 1) }
			}
			`\\`
		}
	} else {
		`\0`
	}

	for from < with.len {
		cur := with[from]
		if prev == `\\` {
			builder.write_u8(cur)
			from++
			prev = `\0`
		} else if cur == `$` && prev != `\\` {
			if from + 1 < with.len {
				digit := with[from + 1]
				if digit >= `0` && digit <= `9` {
					idx := digit - `0`
					if idx < rg.num_regs {
						unsafe {
							start := rg.beg[idx]
							stop := rg.end[idx]
							builder.write_ptr(s.str + start, stop - start)
						}
					}
				} else {
					builder.write_u8(`$`)
					builder.write_u8(digit)
				}
				from += 2
				prev = `\0`
			} else {
				break
			}
		} else if cur == `\\` {
			from++
			prev = cur
		} else {
			builder.write_u8(cur)
			from++
			prev = cur
		}
	}

	if from < with.len {
		unsafe { builder.write_ptr(with.str + from, with.len - from) }
	}
}
