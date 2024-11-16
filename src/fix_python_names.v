module onig

const name_opening = '(?P<'

pub fn has_python_names(pat string) bool {
	return if _ := pat.index(name_opening) {
		true
	} else {
		false
	}
}

pub fn fix_python_names(pat string) string {
	return fix_python_names_opt(pat) or { pat }
}

@[direct_array_access]
pub fn fix_python_names_opt(pat string) ?string {
	mut name := pat.index(name_opening) or { return none }

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
