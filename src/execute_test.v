module onig

fn test_match_matched() {
	mut re := onig_new('a(.*)b', opt_none)!
	defer {
		re.free()
	}
	m := re.match_str('affffffffb', opt_none)!
	// assert re.number_of_captures() == 1
	assert m.groups.len == 2
	assert m.groups[0].start == 0
	assert m.groups[0].end == 10
	assert m.groups[1].start == 1
	assert m.groups[1].end == 9
	assert m.names.len == 0
}

fn test_match_matched_ext() {
	mut re := onig_new('a(.*)b', opt_none)!
	defer {
		re.free()
	}
	m := re.match_within('zzzzaffffffffb', 4, -1, opt_none)!
	// assert re.number_of_captures() == 1
	assert m.groups.len == 2
	assert m.groups[0].start == 4
	assert m.groups[0].end == 14
	assert m.groups[1].start == 5
	assert m.groups[1].end == 13
	assert m.names.len == 0
}

fn test_match_not_matched() {
	mut re := onig_new('a(.*)b', opt_none)!
	defer {
		re.free()
	}
	re.match_str('zzzzffffffffb', opt_none) or {
		assert err is NoMatch
		return
	}
	assert false
}

fn test_match_named() {
	mut re := onig_new('a(?<test>.*)b', opt_none)!
	defer {
		re.free()
	}
	m := re.match_str('affffffffb', opt_none)!
	// assert re.number_of_captures() == 1
	assert m.groups.len == 2
	assert m.groups[0].start == 0
	assert m.groups[0].end == 10
	assert m.groups[1].start == 1
	assert m.groups[1].end == 9
	// assert re.number_of_names() == 1
	// groups := re.group_texts_by_name('test')?
	assert m.names.len == 1
	grps := m.names['test']
	assert grps.len == 1
	assert grps[0] == 1
	assert m.names.len == 1
}

fn test_match_two_named() {
	mut re := onig_new('a(?<test>.*)b(?<test>.*)', opt_none)!
	defer {
		re.free()
	}
	m := re.match_str('affffffffbc', opt_none)!
	// assert re.number_of_captures() == 2
	assert m.groups.len == 3
	assert m.groups[0].start == 0
	assert m.groups[0].end == 11
	assert m.groups[1].start == 1
	assert m.groups[1].end == 9
	assert m.groups[2].start == 10
	assert m.groups[2].end == 11
	// assert re.number_of_names() == 1
	// groups := re.group_texts_by_name('test')?
	assert m.names.len == 1
	grps := m.names['test']
	assert grps.len == 2
	assert grps[0] == 1
	assert grps[1] == 2
}

fn test_search_found() {
	mut re := onig_new('a(.*)b|[e-f]+', opt_none)!
	defer {
		re.free()
	}
	m := re.search('zzzzaffffffffb', opt_none)!
	assert m.groups.len == 2
	assert m.groups[0].start == 4
	assert m.groups[0].end == 14
	assert m.groups[1].start == 5
	assert m.groups[1].end == 13
}

fn test_search_not_found() {
	mut re := onig_new('a(.*)b', opt_none)!
	defer {
		re.free()
	}
	re.search('zzzzffffffffb', opt_none) or {
		assert err is NoMatch
		return
	}
	assert false
}

fn test_search_all_found() {
	mut re := onig_new('a', opt_none)!
	defer {
		re.free()
	}
	m := re.search_all('aa', opt_none)!
	assert m.len == 2
	assert m[0].groups.len == 1
	assert m[0].groups[0].start == 0
	assert m[0].groups[0].end == 1
	assert m[1].groups.len == 1
	assert m[1].groups[0].start == 1
	assert m[1].groups[0].end == 2
}

fn test_search_all_not_found() {
	mut re := onig_new('a', opt_none)!
	defer {
		re.free()
	}
	re.search_all('b', opt_none) or {
		assert err is NoMatch
		return
	}
	assert false
}

fn test_group_by_index() {
	mut re := onig_new('a(.*)b(.*)', opt_none)!
	defer {
		re.free()
	}
	s := 'affffffffbc'
	m := re.match_str(s, opt_none)!
	assert m.group_by_index(0)? == Group{
		start: 0
		end:   11
	}
	assert m.group_by_index(1)? == Group{
		start: 1
		end:   9
	}
	assert m.group_by_index(2)? == Group{
		start: 10
		end:   11
	}
	m.group_by_index(3) or { return }
	assert false
}

fn test_group_text_by_index() {
	mut re := onig_new('a(.*)b(.*)', opt_none)!
	defer {
		re.free()
	}
	s := 'affffffffbc'
	m := re.match_str(s, opt_none)!
	assert m.group_text_by_index(s, 0)? == 'affffffffbc'
	assert m.group_text_by_index(s, 1)? == 'ffffffff'
	assert m.group_text_by_index(s, 2)? == 'c'
	m.group_text_by_index(s, 3) or { return }
	assert false
}

fn test_group_text_by_name_both() {
	mut re := onig_new('a(?<test>.*)b(?<test>.*)', opt_none)!
	defer {
		re.free()
	}
	s := 'affffffffbc'
	m := re.match_str(s, opt_none)!
	if g := m.group_by_name('test') {
		assert g == Group{
			start: 1
			end:   9
		}
	} else {
		assert false
	}
	if g := m.group_by_name('dummy') {
		assert false
	}
	assert m.group_text_by_name(s, 'test')? == 'ffffffff'
	if _ := m.group_text_by_name(s, 'dummy') {
		assert false
	}
	if g := m.groups_by_name('test') {
		assert g == [
			Group{
				start: 1
				end:   9
			},
			Group{
				start: 10
				end:   11
			},
		]
	} else {
		assert false
	}
	if g := m.groups_by_name('dummy') {
		assert false
	}
	assert m.group_texts_by_name(s, 'test')? == ['ffffffff', 'c']
	if _ := m.group_texts_by_name(s, 'dummy') {
		assert false
	}
}

fn test_group_text_by_name_either() {
	mut re := onig_new('a(?<test>.*)|b(?<test>.*)', opt_none)!
	defer {
		re.free()
	}
	s := 'affffffffbc'
	m := re.search(s, opt_none)!
	if g := m.group_by_name('test') {
		assert g == Group{
			start: 1
			end:   11
		}
	} else {
		assert false
	}
	if g := m.group_by_name('dummy') {
		assert false
	}
	assert m.group_text_by_name(s, 'test')? == 'ffffffffbc'
	if _ := m.group_text_by_name(s, 'dummy') {
		assert false
	}
	if g := m.groups_by_name('test') {
		assert g == [
			Group{
				start: 1
				end:   11
			},
		]
	} else {
		assert false
	}
	if g := m.groups_by_name('dummy') {
		assert false
	}
	assert m.group_texts_by_name(s, 'test')? == ['ffffffffbc']
	if _ := m.group_texts_by_name(s, 'dummy') {
		assert false
	}
}
