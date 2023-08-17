module onig

import strings { Builder, new_builder }
import prantlf.strutil { compare_str_within_nochk }

pub fn (mut r RegEx) replace(s string, with string, opt u32) !string {
	repl_grps := opt & opt_replace_groups != 0
	search_opt := opt & ~opt_replace_groups
	rg := r.get_region()
	mut builder := unsafe { &Builder(nil) }
	mut replaced := false
	mut pos := 0
	mut last := 0
	stop := s.len
	end := unsafe { s.str + stop }
	for {
		res := C.onig_search(r.re, s.str, end, unsafe { s.str + pos }, end, rg, u32(search_opt))
		if res >= 0 {
			if rg.num_regs > 0 {
				if isnil(builder) {
					mut b := new_builder(s.len + with.len)
					builder = &b
				}
				start_r := builder.len
				pos = unsafe { rg.end[0] }
				unsafe { builder.write_ptr(s.str + last, res - last) }
				if repl_grps {
					replace_with(mut builder, s, with, rg)
					if !replaced {
						rep := unsafe { tos(&u8(builder.data) + start_r, builder.len - start_r) }
						if unsafe { compare_str_within_nochk(rep, s, res, pos) } != 0 {
							replaced = true
						}
					}
				} else {
					if !replaced && unsafe { compare_str_within_nochk(with, s, res, pos) } != 0 {
						replaced = true
					}
					builder.write_string(with)
				}
				last = pos
				if pos == stop {
					break
				}
			} else {
				break
			}
		} else {
			if res == C.ONIG_MISMATCH {
				if pos == 0 {
					return NoMatch{}
				}
				break
			}
			return fail_exec(res)
		}
	}
	if !replaced {
		return NoReplace{}
	}
	if last < stop {
		unsafe { builder.write_ptr(s.str + last, stop - last) }
	}
	return builder.str()
}

pub fn (mut r RegEx) replace_first(s string, with string, opt u32) !string {
	repl_grps := opt & opt_replace_groups != 0
	search_opt := opt & ~opt_replace_groups
	rg := r.get_region()
	stop := s.len
	mut end := unsafe { s.str + stop }
	res := C.onig_search(r.re, s.str, end, s.str, end, rg, u32(search_opt))
	if res >= 0 {
		if rg.num_regs > 0 {
			mut builder := new_builder(s.len + with.len)
			unsafe { builder.write_ptr(s.str, res) }
			pos := unsafe { rg.end[0] }
			if repl_grps {
				start_r := builder.len
				replace_with(mut builder, s, with, rg)
				rep := unsafe { tos(&u8(builder.data) + start_r, builder.len - start_r) }
				if unsafe { compare_str_within_nochk(rep, s, res, pos) } == 0 {
					return NoReplace{}
				}
			} else {
				if unsafe { compare_str_within_nochk(with, s, res, pos) } == 0 {
					return NoReplace{}
				}
				builder.write_string(with)
			}
			len := stop - pos
			if len > 0 {
				unsafe { builder.write_ptr(s.str + pos, len) }
			}
			return builder.str()
		}
		return NoMatch{}
	}
	if res == C.ONIG_MISMATCH {
		return NoMatch{}
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
