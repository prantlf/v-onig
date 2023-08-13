#!/usr/bin/env -S v -prod run

import benchmark { start }
import regex { regex_opt }
import prantlf.onig { NoMatch, onig_new }

const repeat_count = 100_000

const plain_pat_regex = r'^\s*#+\s+(?:\d+\.\d+\.\d+)|(?:\[(\d+\.\d+\.\d+)\]).+\([-\d]+\)\s*$'

const plain_pat_onig = r'^\s*#+\s+(?:\d+\.\d+\.\d+|\[\d+\.\d+\.\d+\]).+\([-\d]+\)\s*$'

const groups_pat_regex = r'^\s*(#+)\s+(\d+\.\d+\.\d+)|(?:\[(\d+\.\d+\.\d+)\]).+\([-\d]+\)\s*$'

const groups_pat_onig = r'^\s*(#+)\s+(?:(\d+\.\d+\.\d+)|\[(\d+\.\d+\.\d+)\]).+\([-\d]+\)\s*$'

const names_pat_regex = r'^\s*(?P<heading>#+)\s+(?P<version>\d+\.\d+\.\d+)|(?:\[(?P<version>\d+\.\d+\.\d+)\]).+\([-\d]+\)\s*$'

const names_pat_onig = r'^\s*(?<heading>#+)\s+(?:(?<version>\d+\.\d+\.\d+)|\[(?<version>\d+\.\d+\.\d+)\]).+\([-\d]+\)\s*$'

const title_line = '# Changes'

const version_line1 = '## [14.0.3](https://github.com/prantlf/jsonlint/compare/v14.0.2...v14.0.3) (2023-04-27)'

const version_line2 = '## 1.0.1 (2011-05-21)'

re := regex_opt(plain_pat_regex)!
mut re_onig := onig_new(plain_pat_onig, onig.opt_none)!

re_groups := regex_opt(groups_pat_regex)!
mut re_groups_onig := onig_new(groups_pat_onig, onig.opt_none)!

re_names := regex_opt(names_pat_regex)!
mut re_names_onig := onig_new(names_pat_onig, onig.opt_none)!

if re.matches_string(title_line) {
	panic('re.matches_string(title_line)')
}
if re_groups.matches_string(title_line) {
	panic('re_groups.matches_string(title_line)')
}
if re_names.matches_string(title_line) {
	panic('re_names.matches_string(title_line)')
}
if !re.matches_string(version_line1) {
	panic('re.matches_string(version_line1)')
}
if !re_groups.matches_string(version_line1) {
	panic('re_groups.matches_string(version_line1)')
}
if !re_names.matches_string(version_line1) {
	panic('re_names.matches_string(version_line1)')
}
if !re.matches_string(version_line2) {
	panic('re.matches_string(version_line2)')
}
if !re_groups.matches_string(version_line2) {
	panic('re_groups.matches_string(version_line2)')
}
if !re_names.matches_string(version_line2) {
	panic('re_names.matches_string(version_line2)')
}

if re_onig.matches(title_line, onig.opt_none)! {
	panic('re_onig.matches(title_line)')
}
if re_groups_onig.matches(title_line, onig.opt_none)! {
	panic('re_groups_onig.matches(title_line)')
}
if re_names_onig.matches(title_line, onig.opt_none)! {
	panic('re_names_onig.matches(title_line)')
}
if !re_onig.matches(version_line1, onig.opt_none)! {
	panic('re_onig.matches(version_line1)')
}
if !re_groups_onig.matches(version_line1, onig.opt_none)! {
	panic('re_groups_onig.matches(version_line1)')
}
if !re_names_onig.matches(version_line1, onig.opt_none)! {
	panic('re_names_onig.matches(version_line1)')
}
if !re_onig.matches(version_line2, onig.opt_none)! {
	panic('re_onig.matches(version_line2)')
}
if !re_groups_onig.matches(version_line2, onig.opt_none)! {
	panic('re_groups_onig.matches(version_line2)')
}
if !re_names_onig.matches(version_line2, onig.opt_none)! {
	panic('re_names_onig.matches(version_line2)')
}

mut b := start()

for _ in 0 .. repeat_count {
	re.matches_string(title_line)
	re.matches_string(version_line1)
	re.matches_string(version_line2)
}
b.measure('regex check')

for _ in 0 .. repeat_count {
	re_onig.matches(title_line, onig.opt_none)!
	re_onig.matches(version_line1, onig.opt_none)!
	re_onig.matches(version_line2, onig.opt_none)!
}
b.measure('pranltf.onig check')

for _ in 0 .. repeat_count {
	re.match_string(title_line)
	re.match_string(version_line1)
	re.match_string(version_line2)
}
b.measure('regex match')

for _ in 0 .. repeat_count {
	re_onig.match_str(title_line, onig.opt_none) or {
		if err !is NoMatch {
			panic(err)
		}
	}
	re_onig.match_str(version_line1, onig.opt_none)!
	re_onig.match_str(version_line2, onig.opt_none)!
}
b.measure('pranltf.onig match')

for _ in 0 .. repeat_count {
	re_groups.match_string(title_line)
	re_groups.get_group_list()
	re_groups.match_string(version_line1)
	re_groups.get_group_list()
	re_groups.match_string(version_line2)
	re_groups.get_group_list()
}
b.measure('regex groups')

for _ in 0 .. repeat_count {
	re_groups_onig.match_str(title_line, onig.opt_none) or {
		if err !is NoMatch {
			panic(err)
		}
	}
	re_groups_onig.match_str(version_line1, onig.opt_none)!
	re_groups_onig.match_str(version_line2, onig.opt_none)!
}
b.measure('pranltf.onig groups')

for _ in 0 .. repeat_count {
	re_names.match_string(title_line)
	re_names.get_group_bounds_by_name('heading')
	re_names.get_group_bounds_by_name('version')
	re_names.match_string(version_line1)
	re_names.get_group_bounds_by_name('heading')
	re_names.get_group_bounds_by_name('version')
	re_names.match_string(version_line2)
	re_names.get_group_bounds_by_name('heading')
	re_names.get_group_bounds_by_name('version')
}
b.measure('regex named groups')

for _ in 0 .. repeat_count {
	re_names_onig.match_str(title_line, onig.opt_none) or {
		if err !is NoMatch {
			panic(err)
		}
	}
	re_names_onig.match_str(version_line1, onig.opt_none)!
	re_names_onig.match_str(version_line2, onig.opt_none)!
}
b.measure('pranltf.onig named groups')
