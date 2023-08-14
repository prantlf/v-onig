#!/usr/bin/env -S v -prod run

import benchmark { start }
import os { read_lines }
import regex { regex_opt }
import prantlf.onig { NoMatch, onig_new }
import pcre { new_regex }
import prantlf.pcre2 { compile }
import prantlf.re2 { Anchor, re2_new }

const repeat_count_version = 10_000

const repeat_count_commit = 100_000

changes := read_lines('CHANGELOG.md')!
version_pat_regex := r'^\s*##\s+(?:(\d+\.\d+\.\d+)|(?:\[(\d+\.\d+\.\d+)\])).+\(([-\d]+)\)\s*$'
version_pat_others := r'^\s*##\s+(?:(\d+\.\d+\.\d+)|\[(\d+\.\d+\.\d+)\]).+\(([-\d]+)\)\s*$'
version_line1 := '## [14.0.3](https://github.com/prantlf/jsonlint/compare/v14.0.2...v14.0.3) (2023-04-27)'
version_line2 := '## 1.0.1 (2011-05-21)'
version_line3 := '### Bug Fixes'
commit_pat_regex := r'^\s*(?P<type>[^:]+)\s*:\s*(?P<description>.+)$'
commit_pat_others := r'^\s*(?<type>[^:]+)\s*:\s*(?<description>.+)$'
commit_line1 := 'feat: Allow to control escaping slashes and unicode characters'
commit_line2 := 'Initial commit'

mut re_regex_version := regex_opt(version_pat_regex)!
if !re_regex_version.matches_string(version_line1) {
	panic('re_regex_version.matches_string(version_line1)')
}
if !re_regex_version.matches_string(version_line2) {
	panic('re_regex_version.matches_string(version_line2)')
}
if re_regex_version.matches_string(version_line3) {
	panic('re_regex_version.matches_string(version_line3)')
}
mut re_regex_commit := regex_opt(commit_pat_regex)!
if !re_regex_commit.matches_string(commit_line1) {
	panic('re_regex_commit.matches_string(commit_line1)')
}
if re_regex_commit.matches_string(commit_line2) {
	panic('re_regex_commit.matches_string(commit_line2)')
}

mut re_onig_version := onig_new(version_pat_others, onig.opt_none)!
if !re_onig_version.matches(version_line1, onig.opt_none)! {
	panic('re_onig_version.matches(version_line1, onig.opt_none)')
}
if !re_onig_version.matches(version_line2, onig.opt_none)! {
	panic('re_onig_version.matches(version_line2, onig.opt_none)')
}
if re_onig_version.matches(version_line3, onig.opt_none)! {
	panic('re_onig_version.matches(version_line3, onig.opt_none)')
}
mut re_onig_commit := onig_new(commit_pat_others, onig.opt_none)!
if !re_onig_commit.matches(commit_line1, onig.opt_none)! {
	panic('re_onig_commit := onig_new(commit_pat_others, onig.opt_none)')
}
if re_onig_commit.matches(commit_line2, onig.opt_none)! {
	panic('re_onig_commit.matches(commit_line2, onig.opt_none)')
}

mut re_pcre_version := new_regex(version_pat_others, 0)!
re_pcre_version.match_str(version_line1, 0, 0)!
re_pcre_version.match_str(version_line2, 0, 0)!
if _ := re_pcre_version.match_str(version_line3, 0, 0) {
	panic('re_pcre_version.match_str(version_line3, 0, 0)')
}
mut re_pcre_commit := new_regex(commit_pat_others, 0)!
re_pcre_commit.match_str(commit_line1, 0, 0)!
if _ := re_pcre_commit.match_str(commit_line2, 0, 0) {
	panic('re_pcre_commit.match_str(commit_line2, 0, 0)')
}

mut re_pcre2_version := compile(version_pat_others)!
if !re_pcre2_version.is_match(version_line1) {
	panic('re_pcre2_version.is_match(version_line1)')
}
if !re_pcre2_version.is_match(version_line2) {
	panic('re_pcre2_version.is_match(version_line2)')
}
if re_pcre2_version.is_match(version_line3) {
	panic('re_pcre2_version.is_match(version_line3)')
}
mut re_pcre2_commit := compile(commit_pat_others)!
if !re_pcre2_commit.is_match(commit_line1) {
	panic('re_pcre2_commit.is_match(commit_line1)')
}
if re_pcre2_commit.is_match(commit_line2) {
	panic('re_pcre2_commit.is_match(commit_line2)')
}

mut re_re2_version := re2_new(version_pat_others)!
if !re_re2_version.matches(version_line1, 0, -1, Anchor.unanchored) {
	panic('re_re2_version.matches(version_line1, 0, -1, Anchor.unanchored)')
}
if !re_re2_version.matches(version_line2, 0, -1, Anchor.unanchored) {
	panic('re_re2_version.matches(version_line2, 0, -1, Anchor.unanchored)')
}
if re_re2_version.matches(version_line3, 0, -1, Anchor.unanchored) {
	panic('re_re2_version.matches(version_line3, 0, -1, Anchor.unanchored)')
}
mut re_re2_commit := re2_new(commit_pat_regex)!
if !re_re2_commit.matches(commit_line1, 0, -1, Anchor.unanchored) {
	panic('re_re2_commit.matches(commit_line1, 0, -1, Anchor.unanchored)')
}
if re_re2_commit.matches(commit_line2, 0, -1, Anchor.unanchored) {
	panic('re_re2_commit.matches(commit_line2, 0, -1, Anchor.unanchored)')
}

mut b := start()

for _ in 0 .. repeat_count_version {
	for line in changes {
		re_regex_version.matches_string(line)
	}
}
b.measure('regex test')

for _ in 0 .. repeat_count_version {
	for line in changes {
		if re_regex_version.matches_string(line) {
			re_regex_version.get_group_list()
		}
	}
}
b.measure('regex unamed')

for _ in 0 .. repeat_count_commit {
	re_regex_commit.matches_string(commit_line1)
	re_regex_commit.get_group_list()
	re_regex_commit.get_group_by_name(commit_line1, 'type')
	re_regex_commit.get_group_by_name(commit_line1, 'description')
}
b.measure('regex named')

for _ in 0 .. repeat_count_commit {
	re_regex_commit.matches_string(commit_line2)
}
b.measure('regex miss')

for _ in 0 .. repeat_count_version {
	for line in changes {
		re_onig_version.matches(line, onig.opt_none)!
	}
}
b.measure('prantlf.onig test')

for _ in 0 .. repeat_count_version {
	for line in changes {
		re_onig_version.match_str(line, onig.opt_none) or {
			if err !is NoMatch {
				panic(err)
			}
		}
	}
}
b.measure('prantlf.onig unnamed')

for _ in 0 .. repeat_count_commit {
	re_onig_commit.match_str(commit_line1, onig.opt_none)!
}
b.measure('prantlf.onig named')

for _ in 0 .. repeat_count_commit {
	re_onig_commit.match_str(commit_line2, onig.opt_none) or {
		if err !is NoMatch {
			panic(err)
		}
	}
}
b.measure('prantlf.onig miss')

for _ in 0 .. repeat_count_version {
	for line in changes {
		re_pcre_version.match_str(line, 0, 0) or {}
	}
}
b.measure('pcre test')

for _ in 0 .. repeat_count_version {
	for line in changes {
		re_pcre_version.match_str(line, 0, 0) or {}
	}
}
b.measure('pcre unnamed')

println('    N/A\tpcre named')
println('    N/A\tpcre miss')

for _ in 0 .. repeat_count_version {
	for line in changes {
		re_pcre2_version.is_match(line)
	}
}
b.measure('prantlf.pcre2 test')

for _ in 0 .. repeat_count_version {
	for line in changes {
		re_pcre2_version.find_one(line)
	}
}
b.measure('prantlf.pcre2 unnamed')

println('    N/A\tprantlf.pcre2 named')
println('    N/A\tprantlf.pcre2 miss')

for _ in 0 .. repeat_count_version {
	for line in changes {
		re_re2_version.matches(line, 0, -1, Anchor.unanchored)
	}
}
b.measure('prantlf.re2 test')

for _ in 0 .. repeat_count_version {
	for line in changes {
		re_re2_version.match_str(line, 0, -1, Anchor.unanchored)
	}
}
b.measure('prantlf.re2 unnamed')

for _ in 0 .. repeat_count_commit {
	re_re2_commit.match_str(commit_line1, 0, -1, Anchor.unanchored)
	re_re2_commit.group_by_name('test')
}
b.measure('prantlf.re2 named')

for _ in 0 .. repeat_count_commit {
	re_re2_commit.match_str(commit_line2, 0, -1, Anchor.unanchored)
}
b.measure('prantlf.re2 miss')
