#!/usr/bin/env -S v -prod run

import benchmark { start }
import strings { new_builder }

const repeat_count = 100_000

const name_opening = '(?P<'

[direct_array_access]
fn fix_python_names_append(pat string) string {
	mut name := pat.index(name_opening) or { return pat }

	mut from := &u8(pat.str)
	end := unsafe { from + pat.len }

	mut mem := unsafe { malloc_noscan(pat.len + 1) }
	mut to := &u8(mem)

	if name > 0 {
		unsafe {
			vmemcpy(to, from, name)
			to += name
			from += name
		}
	}

	mut prev := `\0`
	for from < end {
		cur := *from
		unsafe {
			if cur == `(` && prev != `\\` {
				if from + 4 < end {
					if from[1] == `?` && from[2] == `P` && from[3] == `<` {
						*to = cur
						to[1] = `?`
						to[2] = `<`
						to += 3
						from += 4
						prev = `<`
					} else {
						*to = cur
						to++
						from++
						prev = cur
					}
				} else {
					break
				}
			} else {
				*to = cur
				to++
				from++
				prev = cur
			}
		}
	}

	for from < end {
		unsafe {
			*to = *from
			from++
			to++
		}
	}
	unsafe {
		*to = 0
	}
	return unsafe { tos(mem, to - mem) }
}

fn fix_python_names_search(pat string) string {
	mut name := pat.index(name_opening) or { return pat }

	mut builder := new_builder(pat.len)
	start := &u8(pat.str)
	mut last := 0
	for {
		if name == 0 || pat[name - 1] != `\\` {
			if last < name {
				unsafe { builder.write_ptr(start + last, name - last + 2) }
			} else {
				builder.write_u8(`(`)
				builder.write_u8(`?`)
			}
			name += 3
			last = name
		}

		name = pat.index_after(name_opening, name + 1)
		if name < 0 {
			if last < pat.len {
				unsafe { builder.write_ptr(start + last, pat.len - last) }
			}
			break
		}
	}

	return builder.str()
}

const subject_pat = r'^\s*(?P<description>.+)$'

const subject_pat_fixed = r'^\s*(?<description>.+)$'

const version_pat = r'^\s*(?P<heading>#+)\s+(?:(?P<version>\d+\.\d+\.\d+)|(?:\[(?P<version>\d+\.\d+\.\d+)\])).+\([-\d]+\)\s*$'

const version_pat_fixed = r'^\s*(?<heading>#+)\s+(?:(?<version>\d+\.\d+\.\d+)|(?:\[(?<version>\d+\.\d+\.\d+)\])).+\([-\d]+\)\s*$'

if fix_python_names_append(subject_pat)? != subject_pat_fixed {
	panic('append')
}
if fix_python_names_search(subject_pat)? != subject_pat_fixed {
	panic('search')
}

if fix_python_names_append(version_pat)? != version_pat_fixed {
	panic('append')
}
if fix_python_names_search(version_pat)? != version_pat_fixed {
	panic('search')
}

mut b := start()

for _ in 0 .. repeat_count {
	fix_python_names_append(subject_pat)
}
b.measure('fix subject pat by iterating and appending')

for _ in 0 .. repeat_count {
	fix_python_names_search(subject_pat)
}
b.measure('fix subject pat by searching and writing')

for _ in 0 .. repeat_count {
	fix_python_names_append(version_pat)
}
b.measure('fix version pat by iterating and appending')

for _ in 0 .. repeat_count {
	fix_python_names_search(version_pat)
}
b.measure('fix version pat by searching and writing')
