module onig

import prantlf.strutil { check_bounds_strict }

@[noinit]
pub struct Group {
pub:
	start int
	end   int
}

@[noinit]
pub struct Match {
pub:
	groups []Group
	names  map[string][]int
}

pub const (
	opt_not_bol            = 1 << 9
	opt_not_eol            = 1 << 10
	// opt_posix_region             = 1 << 11
	// opt_check_validity_of_string = 1 << 12
	opt_not_begin_string   = 1 << 22
	opt_not_end_string     = 1 << 23
	opt_not_begin_position = 1 << 24
	// opt_callback_each_match = 1 << 25
	opt_match_whole_string = 1 << 26
	opt_replace_groups     = 1 << 30
)

@[inline]
pub fn (mut r RegEx) match_str(s string, opt u32) !Match {
	return unsafe { r.match_within_nochk(s, 0, s.len, opt)! }
}

pub fn (mut r RegEx) match_within(s string, at int, end int, opt u32) !Match {
	stop := check_bounds_strict(s, at, end)!
	return unsafe { r.match_within_nochk(s, at, stop, opt)! }
}

@[unsafe]
pub fn (mut r RegEx) match_within_nochk(s string, at int, stop int, opt u32) !Match {
	if at == stop {
		return NoMatch{}
	}
	rg := r.get_region()
	res := C.onig_match(r.re, s.str, unsafe { s.str + stop }, unsafe { s.str + at }, rg,
		u32(opt))
	if res >= 0 {
		return r.create_match()
	} else {
		if res == C.ONIG_MISMATCH {
			return NoMatch{}
		}
	}
	return fail_exec(res)
}

@[inline]
pub fn (mut r RegEx) search(s string, opt u32) !Match {
	return unsafe { r.search_within_nochk(s, 0, s.len, opt)! }
}

pub fn (mut r RegEx) search_within(s string, start int, end int, opt u32) !Match {
	stop := check_bounds_strict(s, start, end)!
	return unsafe { r.search_within_nochk(s, start, stop, opt)! }
}

@[unsafe]
pub fn (mut r RegEx) search_within_nochk(s string, start int, stop int, opt u32) !Match {
	if start == stop {
		return NoMatch{}
	}
	rg := r.get_region()
	res := C.onig_search(r.re, s.str, unsafe { s.str + stop }, unsafe { s.str + start },
		unsafe { s.str + stop }, rg, u32(opt))
	if res >= 0 {
		return r.create_match()
	} else {
		if res == C.ONIG_MISMATCH {
			return NoMatch{}
		}
	}
	return fail_exec(res)
}

@[inline]
pub fn (mut r RegEx) exec(subject string, options u32) !Match {
	return r.search(subject, options)!
}

pub fn (mut r RegEx) exec_within(subject string, start int, end int, options u32) !Match {
	return r.search_within(subject, start, end, options)!
}

@[unsafe]
pub fn (mut r RegEx) exec_within_nochk(subject string, start int, end int, options u32) !Match {
	return unsafe { r.search_within_nochk(subject, start, end, options)! }
}

@[inline]
pub fn (mut r RegEx) search_all(s string, opt u32) ![]Match {
	return unsafe { r.search_all_within_nochk(s, 0, s.len, opt)! }
}

pub fn (mut r RegEx) search_all_within(s string, start int, end int, opt u32) ![]Match {
	stop := check_bounds_strict(s, start, end)!
	return unsafe { r.search_all_within_nochk(s, start, stop, opt)! }
}

@[unsafe]
pub fn (mut r RegEx) search_all_within_nochk(s string, start int, end int, opt u32) ![]Match {
	if start == end {
		return NoMatch{}
	}
	rg := r.get_region()
	mut matches := []Match{}
	mut pos := start
	mut stop := unsafe { s.str + end }
	for {
		res := C.onig_search(r.re, s.str, stop, unsafe { s.str + pos }, stop, rg, u32(opt))
		if res >= 0 {
			m := r.create_match()
			matches << m
			pos = m.groups[0].end
			if pos == end {
				break
			}
		} else {
			if res == C.ONIG_MISMATCH {
				break
			}
			return fail_exec(res)
		}
	}
	if matches.len > 0 {
		return matches
	}
	return NoMatch{}
}

pub fn (m &Match) group_by_index(idx int) ?Group {
	if idx >= 0 && idx < m.groups.len {
		grp := m.groups[idx]
		if grp.start >= 0 {
			return grp
		}
	}
	return none
}

pub fn (m &Match) group_by_name(name string) ?Group {
	idxs := m.names[name]
	for idx in idxs {
		grp := m.groups[idx]
		if grp.start >= 0 {
			return grp
		}
	}
	return none
}

pub fn (m &Match) groups_by_name(name string) ?[]Group {
	idxs := m.names[name]
	if idxs.len > 0 {
		mut grps := []Group{cap: idxs.len}
		for idx in idxs {
			grp := m.groups[idx]
			if grp.start >= 0 {
				grps << grp
			}
		}
		if grps.len > 0 {
			return grps
		}
	}
	return none
}

pub fn (m &Match) group_text_by_index(s string, idx int) ?string {
	if idx >= 0 && idx < m.groups.len {
		grp := m.groups[idx]
		if grp.start >= 0 {
			return s[grp.start..grp.end]
		}
	}
	return none
}

pub fn (m &Match) group_text_by_name(s string, name string) ?string {
	idxs := m.names[name]
	for idx in idxs {
		grp := m.groups[idx]
		if grp.start >= 0 {
			return s[grp.start..grp.end]
		}
	}
	return none
}

pub fn (m &Match) group_texts_by_name(s string, name string) ?[]string {
	idxs := m.names[name]
	if idxs.len > 0 {
		mut grps := []string{cap: idxs.len}
		for idx in idxs {
			grp := m.groups[idx]
			if grp.start >= 0 {
				grps << s[grp.start..grp.end]
			}
		}
		if grps.len > 0 {
			return grps
		}
	}
	return none
}

struct NameData {
	rg &C.OnigRegion
mut:
	names map[string][]int
}

fn search_all_names(name_start &u8, name_end &u8, grp_num_cnt int, grp_nums &int, re &C.OnigRegex, arg voidptr) int {
	mut data := unsafe { &NameData(arg) }
	name := unsafe { tos(name_start, name_end - name_start) }
	mut grp_idxs := []int{cap: grp_num_cnt}
	for i in 0 .. grp_num_cnt {
		grp_idxs << unsafe { grp_nums[i] }
	}
	data.names[name] = grp_idxs
	return 0
}

fn (r &RegEx) create_match() Match {
	rg := r.rg
	mut grps := []Group{cap: rg.num_regs}
	for i in 0 .. rg.num_regs {
		grps << Group{
			start: unsafe { rg.beg[i] }
			end: unsafe { rg.end[i] }
		}
	}
	mut names := map[string][]int{}
	name_cnt := C.onig_number_of_names(r.re)
	if name_cnt > 0 {
		mut name_data := NameData{
			rg: unsafe { rg }
			names: map[string][]int{}
		}
		C.onig_foreach_name(r.re, &search_all_names, &name_data)
		names = name_data.names.move()
	}
	return Match{
		groups: grps
		names: names
	}
}

fn fail_exec(res int) ExecuteError {
	buf := []u8{len: C.ONIG_MAX_ERROR_MESSAGE_LEN}
	len := C.onig_error_code_to_str(buf.data, res)
	msg := unsafe { (&u8(buf.data)).vstring_with_len(len) }
	return ExecuteError{
		msg: msg.clone()
		code: int(res)
	}
}
