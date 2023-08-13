module onig

import prantlf.strutil { check_bounds_incl }

[inline]
pub fn (r &RegEx) matches(s string, opt u32) !bool {
	return unsafe { r.matches_within_nochk(s, 0, s.len, opt)! }
}

pub fn (r &RegEx) matches_within(s string, at int, end int, opt u32) !bool {
	stop := check_bounds_incl(s, at, end)
	if stop < 0 {
		return false
	}
	return unsafe { r.matches_within_nochk(s, at, stop, opt)! }
}

[unsafe]
pub fn (r &RegEx) matches_within_nochk(s string, at int, stop int, opt u32) !bool {
	if at == stop {
		return false
	}
	res := C.onig_match(r.re, s.str, unsafe { s.str + stop }, unsafe { s.str + at }, 0,
		u32(opt))
	if res >= 0 {
		return res == stop - at
	} else if res == C.ONIG_MISMATCH {
		return false
	}
	return fail_exec(res)
}

[inline]
pub fn (r &RegEx) contains(s string, opt u32) !bool {
	return unsafe { r.contains_within_nochk(s, 0, s.len, opt)! }
}

pub fn (r &RegEx) contains_within(s string, start int, end int, opt u32) !bool {
	stop := check_bounds_incl(s, start, end)
	if stop < 0 {
		return false
	}
	return unsafe { r.contains_within_nochk(s, start, stop, opt)! }
}

[unsafe]
pub fn (r &RegEx) contains_within_nochk(s string, start int, stop int, opt u32) !bool {
	if start == stop {
		return false
	}
	res := C.onig_search(r.re, s.str, unsafe { s.str + stop }, unsafe { s.str + start },
		unsafe { s.str + stop }, 0, u32(opt))
	if res >= 0 {
		return true
	} else if res == C.ONIG_MISMATCH {
		return false
	}
	return fail_exec(res)
}

[inline]
pub fn (r &RegEx) starts_with(s string, opt u32) !bool {
	return unsafe { r.starts_with_within_nochk(s, 0, s.len, opt)! }
}

pub fn (r &RegEx) starts_with_within(s string, at int, end int, opt u32) !bool {
	stop := check_bounds_incl(s, at, end)
	if stop < 0 {
		return false
	}
	return unsafe { r.starts_with_within_nochk(s, at, stop, opt)! }
}

[unsafe]
pub fn (r &RegEx) starts_with_within_nochk(s string, at int, stop int, opt u32) !bool {
	if at == stop {
		return false
	}
	res := C.onig_match(r.re, s.str, unsafe { s.str + stop }, unsafe { s.str + at }, 0,
		u32(opt))
	if res >= 0 {
		return true
	} else if res == C.ONIG_MISMATCH {
		return false
	}
	return fail_exec(res)
}

[inline]
pub fn (r &RegEx) index_of(s string, option u32) !int {
	return unsafe { r.index_of_within_nochk(s, 0, s.len, option)! }
}

pub fn (r &RegEx) index_of_within(s string, start int, end int, opt u32) !int {
	stop := check_bounds_incl(s, start, end)
	if stop < 0 {
		return -1
	}
	return unsafe { r.index_of_within_nochk(s, start, stop, opt)! }
}

[unsafe]
pub fn (r &RegEx) index_of_within_nochk(s string, start int, stop int, opt u32) !int {
	if start == stop {
		return -1
	}
	res := C.onig_search(r.re, s.str, unsafe { s.str + stop }, unsafe { s.str + start },
		unsafe { s.str + stop }, 0, u32(opt))
	if res >= 0 {
		return res
	} else if res == C.ONIG_MISMATCH {
		return -1
	}
	return fail_exec(res)
}

[inline]
pub fn (mut r RegEx) index_range(s string, opt u32) !(int, int) {
	unsafe {
		return r.index_range_within_nochk(s, 0, s.len, opt)!
	}
}

pub fn (mut r RegEx) index_range_within(s string, start int, end int, opt u32) !(int, int) {
	stop := check_bounds_incl(s, start, end)
	if stop < 0 {
		return -1, -1
	}
	unsafe {
		return r.index_range_within_nochk(s, start, stop, opt)!
	}
}

[unsafe]
pub fn (mut r RegEx) index_range_within_nochk(s string, start int, stop int, opt u32) !(int, int) {
	if start == stop {
		return -1, -1
	}
	rg := r.get_region()
	res := C.onig_search(r.re, s.str, unsafe { s.str + stop }, unsafe { s.str + start },
		unsafe { s.str + stop }, rg, u32(opt))
	if res >= 0 {
		return if rg.num_regs > 0 {
			res, unsafe { rg.end[0] }
		} else {
			-1, -1
		}
	} else if res == C.ONIG_MISMATCH {
		return -1, -1
	}
	return fail_exec(res)
}

[inline]
pub fn (r &RegEx) last_index_of(s string, option u32) !int {
	return unsafe { r.last_index_of_within_nochk(s, 0, s.len, option)! }
}

pub fn (r &RegEx) last_index_of_within(s string, start int, end int, opt u32) !int {
	stop := check_bounds_incl(s, start, end)
	if stop < 0 {
		return -1
	}
	return unsafe { r.last_index_of_within_nochk(s, start, stop, opt)! }
}

[unsafe]
pub fn (r &RegEx) last_index_of_within_nochk(s string, start int, stop int, opt u32) !int {
	if start == stop {
		return -1
	}
	res := C.onig_search(r.re, s.str, unsafe { s.str + stop }, unsafe { s.str + stop },
		unsafe { s.str + start }, 0, u32(opt))
	if res >= 0 {
		return res
	} else if res == C.ONIG_MISMATCH {
		return -1
	}
	return fail_exec(res)
}

[inline]
pub fn (mut r RegEx) last_index_range(s string, opt u32) !(int, int) {
	unsafe {
		return r.last_index_range_within_nochk(s, 0, s.len, opt)!
	}
}

pub fn (mut r RegEx) last_index_range_within(s string, start int, end int, opt u32) !(int, int) {
	stop := check_bounds_incl(s, start, end)
	if stop < 0 {
		return -1, -1
	}
	unsafe {
		return r.last_index_range_within_nochk(s, start, stop, opt)!
	}
}

[unsafe]
pub fn (mut r RegEx) last_index_range_within_nochk(s string, start int, stop int, opt u32) !(int, int) {
	if start == stop {
		return -1, -1
	}
	rg := r.get_region()
	res := C.onig_search(r.re, s.str, unsafe { s.str + stop }, unsafe { s.str + stop },
		unsafe { s.str + start }, rg, u32(opt))
	if res >= 0 {
		return if rg.num_regs > 0 {
			res, unsafe { rg.end[0] }
		} else {
			-1, -1
		}
	} else if res == C.ONIG_MISMATCH {
		return -1, -1
	}
	return fail_exec(res)
}

[inline]
pub fn (mut r RegEx) ends_with(s string, opt u32) !bool {
	return unsafe { r.ends_with_within_nochk(s, 0, s.len, opt)! }
}

pub fn (mut r RegEx) ends_with_within(s string, start int, end int, opt u32) !bool {
	stop := check_bounds_incl(s, start, end)
	if stop < 0 {
		return false
	}
	return unsafe { r.ends_with_within_nochk(s, start, stop, opt)! }
}

[unsafe]
pub fn (mut r RegEx) ends_with_within_nochk(s string, start int, end int, opt u32) !bool {
	if start == end {
		return false
	}
	rg := r.get_region()
	res := C.onig_search(r.re, s.str, unsafe { s.str + end }, unsafe { s.str + start },
		unsafe { s.str + end }, rg, u32(opt))
	if res >= 0 {
		return rg.num_regs > 0 && unsafe { rg.end[0] } == end
	} else if res == C.ONIG_MISMATCH {
		return false
	}
	return fail_exec(res)
}

[inline]
pub fn (mut r RegEx) count_of(s string, option u32) !int {
	return unsafe { r.count_of_within_nochk(s, 0, s.len, option)! }
}

pub fn (mut r RegEx) count_of_within(s string, start int, end int, opt u32) !int {
	stop := check_bounds_incl(s, start, end)
	if stop < 0 {
		return 0
	}
	return unsafe { r.count_of_within_nochk(s, start, stop, opt)! }
}

[unsafe]
pub fn (mut r RegEx) count_of_within_nochk(s string, start int, end int, opt u32) !int {
	if start == end {
		return 0
	}
	rg := r.get_region()
	mut cnt := 0
	mut pos := start
	mut stop := unsafe { s.str + end }
	for {
		res := C.onig_search(r.re, s.str, stop, unsafe { s.str + pos }, stop, rg, u32(opt))
		if res >= 0 {
			cnt++
			if rg.num_regs > 0 {
				pos = unsafe { rg.end[0] }
				if pos == end {
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
	return cnt
}
