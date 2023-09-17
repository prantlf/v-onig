# Oniguruma for V

[Oniguruma] is a modern, [fast](bench/README.md) and flexible regular expressions library. It encompasses features from different regular expression implementations that traditionally exist in different languages.

* Works with both ASCII and UTF-8 character encodings.
* Offers various and customisable syntaxes of the regular expression pattern.
* Can search the input string both forwards and backwards.
* A named group with the same name may occur multiple times.

See also the [documentation of the Oniguruma syntax](doc/RE.md) and the [Unicode properties](doc/UNICODE_PROPERTIES.md).

## Synopsis

```v
import prantlf.onig { onig_new }

pattern := r'answer (?<answer>\d+)'
text := 'Is the answer 42?'

re := onig_new(pattern, onig.opt_none)!
defer { re.free() }

assert re.contains(text, onig.opt_none)!
idx := re.index_of(text, onig.opt_none)!
assert idx == 14
start, end := re.index_range(text, onig.opt_none)!
assert start == 14
assert end == 16

m := re.search(text, onig.opt_none)!
assert m.groups.len == 2
assert m.groups[1].start == 14
assert m.groups[1].end == 16
assert m.group_text_by_index(text, 1)? == '42'
assert m.group_text_by_name(text, 'answer')? == '42'

text2 := re.replace(text, 'question known', onig.opt_none)!
assert text2 == 'Is the question known?'
assert !re.contains(text2, onig.opt_none)
```

## Installation

You can install this package either from [VPM] or from GitHub:

```txt
v install prantlf.onig
v install --git https://github.com/prantlf/v-onig
```

## API

The API consists of two parts - basic compilation and execution of a regular expression, corresponding with the [Oniguruma] C API
and convenience functions for typical string checking, searching, splitting and replacing.

## Usage

See also the [semi-documentation of the API](doc/API.md). The following enums, types, constants, functions and methods are exported:

For the syntax of the regular expression patterns, see the [quick reference] or the [exhaustive documentation] from the web site with the [original documentation] for PCRE for C. Especially notable are pages about the [pattern limits] and the [compatibility with PERL5].

### Initialise


    onig_init(encs ...voidptr) !
    onig_end()


### Compile

A regular expression pattern has to be compiled at first:

```v
import prantlf.onig { onig_new, onig_new_utf8, onig_new_custom }
onig_new(pat string, opt u32) !&RegEx       // encoding_ascii and syntax_oniguruma
onig_new_utf8(pat string, opt u32) !&RegEx  // encoding_utf8 and syntax_oniguruma
onig_new_custom(pat string, opt u32, enc voidptr, syntax voidptr) !&RegEx
```

API compatible with PCRE, just using the Oniguruma options. Both synonymous methods share the same functionality:

```v
import prantlf.onig { onig_compile }
onig_compile(source string, options u32) !&RegEx  // encoding_ut8 and syntax_perl_ng
compile(source string, options u32) !&RegEx       // the same as above
```

The following options can be applied. Combine multiple options together with the `|` (binary OR) operator:

    opt_non                 no option
    opt_single_line         '^' -> '\A', '$' -> '\Z'
    opt_multi_line          '.' match with newline
    opt_ignore_case         ambiguity match on
    opt_extend              extended pattern form
    opt_find_longest        find longest match
    opt_find_not_empty      ignore empty match
    opt_negate_single_line  clear single_line which is enabled on posix_basic/posix_extended/perl/perl_ng/python/java

    opt_dont_capture_group  only named group captured.
    opt_capture_group       named and no-named group captured.

    opt_ignore_case_is_ascii  Limit ignore_case((?i)) to a range of ASCII characters
    opt_word_is_ascii         ASCII only word (\w, \p{Word}, [[:word:]])
                                ASCII only word bound (\b)
    opt_digit_is_ascii        ASCII only digit (\d, \p{Digit}, [[:digit:]])
    opt_space_is_ascii        ASCII only space (\s, \p{Space}, [[:space:]])
    opt_posix_is_ascii        ASCII only POSIX properties
                                (includes word, digit, space)
                                (alnum, alpha, blank, cntrl, digit, graph,
                                 lower, print, punct, space, upper, xdigit,
                                 word)
    opt_text_segment_extended_grapheme_cluster  Extended Grapheme Cluster mode
    opt_text_segment_word                       Word mode

If the compilation fails, an error will be returned:

```v
struct CompileError {
  msg    string  // the error message
  code   int     // the error code
}
```

Don't forget to free the regular expression object when you do not need it any more:

```v
(r &RegEx) free()
defer { re.free() }
```

If the patterns contains named capruring groups using the Python syntax - `(?P<name>...)` - you can replace them with the more standard syntax, as known from Oniguruma, Perl, JavaScript etc. - `(?<name>...)` by these functions:

```v
has_python_names(pat string) bool
fix_python_names(pat string) string
fix_python_names_opt(pat string) ?string
```

### Match

After compiling, the regular expression can be used for matching and searching:

```v
(mut r RegEx) match_str(s string, opt u32) !Match
(mut r RegEx) match_within(s string, at int, end int, opt u32) !Match
(mut r RegEx) match_within_nochk(s string, at int, stop int, opt u32) !Match
```

```v
(mut r RegEx) search(s string, opt u32) !Match
(mut r RegEx) search_within(s string, start int, end int, opt u32) !Match
(mut r RegEx) search_within_nochk(s string, start int, stop int, opt u32) !Match
```

API compatible with PCRE, just using the Oniguruma options:

```v
(mut r RegEx) exec(subject string, options u32) !Match
(mut r RegEx) exec_within(subject string, start int, end int, options u32) !Match
(mut r RegEx) exec_within_nochk(subject string, start int, end int, options u32) !Match
```

See also the [semi-documentation of the API](doc/API.md). The following enums, types, constants, functions and methods are exported:

https://github.com/kkos/oniguruma/blob/master/doc/RE

The following options can be applied. Combine multiple options together with the `|` (binary OR) operator:

    not_bol             Do not regard the beginning of the (str) as the beginning
                        of the line and the beginning of the string
    not_eol             Do not regard the (end) as the end of a line
                        and the end of a string
    not_begin_string    Do not regard the beginning of the (str)
                        as the beginning of a string  (* fail \A)
    not_end_string      Do not regard the (end) as a string endpoint
                        (* fail \z, \Z)
    not_begin_position  Do not regard the (start) as start position of search
                        (* fail \G)

If the execution succeeds, an object with information about the match will be returned:

```v
struct Group {
	start int
	end   int
}

struct Match {
	groups []Group
	names  map[string][]int
}
```

Capturing groups can be obtained by the following methods, which return `none`, if the group number is invalid. The group number `0` (zero) means the whole match:

```v
(m &Match) group_by_index(idx int) ?Group
(m &Match) group_by_name(name string) ?Group
(m &Match) groups_by_name(name string) ?[]Group
(m &Match) group_text_by_index(s string, idx int) ?string
(m &Match) group_text_by_name(s string, name string) ?string
(m &Match) group_texts_by_name(s string, name string) ?[]string
```

If the execution cannot match the pattern, a special error will be returned:

```v
struct NoMatch {}
```

If the execution fails from other reasons, a general error will be returned:

```v
struct ExecuteError {
  msg  string
  code int
}
```

## Others

The API consists of two parts - basic compilation and execution of a regular expression, corresponding with the [Oniguruma] C API described above and convenience functions for typical string checking, searching, splitting and replacing described below.

### Searching

```v
(mut r RegEx) search_all(s string, opt u32) ![]Match
(mut r RegEx) search_all_within(s string, start int, end int, opt u32) ![]Match
(mut r RegEx) search_all_within_nochk(s string, start int, stop int, opt u32) ![]Match

(r &RegEx) matches(s string, opt u32) !bool
(r &RegEx) matches_within(s string, at int, end int, opt u32) !bool
(r &RegEx) matches_within_nochk(s string, at int, stop int, opt u32) !bool

(r &RegEx) contains(s string, opt u32) !bool
(r &RegEx) contains_within(s string, at int, end int, opt u32) !bool
(r &RegEx) contains_within_nochk(s string, at int, stop int, opt u32) !bool

(r &RegEx) starts_with(s string, opt u32) !bool
(r &RegEx) starts_with_within(s string, at int, end int, opt u32) !bool
(r &RegEx) starts_with_within_nochk(s string, at int, stop int, opt u32) !bool

(r &RegEx) index_of(s string, option u32) !int
(r &RegEx) index_of_within(s string, start int, end int, opt u32) !int
(r &RegEx) index_of_within_nochk(s string, start int, stop int, opt u32) !int

(mut r RegEx) index_range(s string, opt u32) !(int, int)
(mut r RegEx) index_range_within(s string, start int, end int, opt u32) !(int, int)
(mut r RegEx) index_range_within_nochk(s string, start int, stop int, opt u32) !(int, int)

(r &RegEx) last_index_of(s string, option u32) !int
(r &RegEx) last_index_of_within(s string, start int, end int, opt u32) !int
(r &RegEx) last_index_of_within_nochk(s string, start int, stop int, opt u32) !int

(mut r RegEx) last_index_range(s string, opt u32) !(int, int)
(mut r RegEx) last_index_range_within(s string, start int, end int, opt u32) !(int, int)
(mut r RegEx) last_index_range_within_nochk(s string, start int, stop int, opt u32) !(int, int)

(mut r RegEx) ends_with(s string, opt u32) !bool
(mut r RegEx) ends_with_within(s string, from int, to int, opt u32) !bool
(mut r RegEx) ends_with_within_nochk(s string, from int, to int, opt u32) !bool

(mut r RegEx) count_of(s string, opt u32) !int
(mut r RegEx) count_of_within(s string, start int, end int, opt u32) !int
(mut r RegEx) count_of_within_nochk(s string, start int, stop int, opt u32) !int
```

### Replace

Replace either all occurrences or only the first one matching the pattern of the regular expression:

```v
(mut r RegEx) replace(s string, with string, opt u32) !string
(mut r RegEx) replace_first(s string, with string, opt u32) !string
```

If the regular expression doesn't match the pattern, a special error will be returned:

```v
struct NoMatch {}
```

If the regular expression matches, but the replacement string is the same as the found string, so the replacing wouldn't change anything, a special error will be returned:

```v
struct NoReplace {}
```

### Split

Split the input string by the regular expression and return the remaining parts in a string array:

```v
(mut r RegEx) split(s string, opt u32) ![]string
(mut r RegEx) split_first(s string, opt u32) ![]string
```

Split the input string by the regular expression and return all parts, both remaining and splitting, in a string array:

```v
(mut r RegEx) chop(s string, opt u32) ![]string
(mut r RegEx) chop_first(s string, opt u32) ![]string
```

## Encodings

Support for the following encodings has been included:

    ASCII, UTF-8

by the following constants usable with `onig_new_custom`:

    encoding_ascii
    encoding_utf8

The encoding used by `onig_new` is ASCII and by `onig_new_utf8` is UTF-8.

The following encodings haven't been included in the initial version of this wrapper library, but it'd be easy to do if requested:

    UTF-16BE, UTF-16LE, UTF-32BE, UTF-32LE,
    EUC-JP, EUC-TW, EUC-KR, EUC-CN,
    Shift_JIS, Big5, GB18030, KOI8-R, CP1251,
    ISO-8859-1, ISO-8859-2, ISO-8859-3, ISO-8859-4, ISO-8859-5,
    ISO-8859-6, ISO-8859-7, ISO-8859-8, ISO-8859-9, ISO-8859-10,
    ISO-8859-11, ISO-8859-13, ISO-8859-14, ISO-8859-15, ISO-8859-16

## Syntaxes

Predefined or customised syntaxes can be specified when calling `onig_new_custom`. The syntax used by `onig_new` and `onig_new_utf8` is Oniguruma. The following syntaxes are available by constants:

    syntax_asis
    syntax_posix_basic
    syntax_posix_extended
    syntax_emacs
    syntax_grep
    syntax_gnu
    syntax_java
    syntax_perl
    syntax_perl_ng
    syntax_ruby
    syntax_python
    syntax_oniguruma

An existing syntax can be cloned by the following method and customised by the constants usable in the types below:

```v
Syntax.clone(orig voidptr) &Syntax
```

```v
struct MetaCharTable {
  esc              u32
  anychar          u32
  anytime          u32
  zero_or_one_time u32
  one_or_more_time u32
  anychar_anytime  u32
}

struct Syntax {
  op              u32
  op2             u32
  behavior        u32
  options         u32
  meta_char_table MetaCharTable
}
```

    syn_op_variable_meta_characters
    syn_op_dot_anychar
    syn_op_asterisk_zero_inf
    syn_op_esc_asterisk_zero_inf
    syn_op_plus_one_inf
    syn_op_esc_plus_one_inf
    syn_op_qmark_zero_one
    syn_op_esc_qmark_zero_one
    syn_op_brace_interval
    syn_op_esc_brace_interval
    syn_op_vbar_alt
    syn_op_esc_vbar_alt
    syn_op_lparen_subexp
    syn_op_esc_lparen_subexp
    syn_op_esc_az_buf_anchor
    syn_op_esc_capital_g_begin_anchor
    syn_op_decimal_backref
    syn_op_bracket_cc
    syn_op_esc_w_word
    syn_op_esc_ltgt_word_begin_end
    syn_op_esc_b_word_bound
    syn_op_esc_s_white_space
    syn_op_esc_d_digit
    syn_op_line_anchor
    syn_op_posix_bracket
    syn_op_qmark_non_greedy
    syn_op_esc_control_chars
    syn_op_esc_c_control
    syn_op_esc_octal3
    syn_op_esc_x_hex2
    syn_op_esc_x_brace_hex8
    syn_op_esc_o_brace_octal

    syn_op2_esc_capital_q_quote
    syn_op2_qmark_group_effect
    syn_op2_option_perl
    syn_op2_option_ruby
    syn_op2_plus_possessive_repeat
    syn_op2_plus_possessive_interval
    syn_op2_cclass_set_op
    syn_op2_qmark_lt_named_group
    syn_op2_esc_k_named_backref
    syn_op2_esc_g_subexp_call
    syn_op2_atmark_capture_history
    syn_op2_esc_capital_c_bar_control
    syn_op2_esc_capital_m_bar_meta
    syn_op2_esc_v_vtab
    syn_op2_esc_u_hex4
    syn_op2_esc_gnu_buf_anchor
    syn_op2_esc_p_brace_char_property
    syn_op2_esc_p_brace_circumflex_not
    syn_op2_esc_h_xdigit
    syn_op2_ineffective_escape
    syn_op2_qmark_lparen_if_else
    syn_op2_esc_capital_k_keep
    syn_op2_esc_capital_r_general_newline
    syn_op2_esc_capital_n_o_super_dot
    syn_op2_qmark_tilde_absent_group
    syn_op2_esc_x_y_grapheme_cluster
    syn_op2_esc_x_y_text_segment
    syn_op2_qmark_perl_subexp_call
    syn_op2_qmark_brace_callout_contents
    syn_op2_asterisk_callout_name
    syn_op2_option_oniguruma
    syn_op2_qmark_capital_p_name

    syn_context_indep_anchors
    syn_context_indep_repeat_ops
    syn_context_invalid_repeat_ops
    syn_allow_unmatched_close_subexp
    syn_allow_invalid_interval
    syn_allow_interval_low_abbrev
    syn_strict_check_backref
    syn_different_len_alt_look_behind
    syn_capture_only_named_group
    syn_allow_multiplex_definition_name
    syn_fixed_interval_is_greedy_only
    syn_isolated_option_continue_branch
    syn_variable_len_look_behind
    syn_python
    syn_whole_options
    syn_not_newline_in_negative_cc
    syn_backslash_escape_in_cc
    syn_allow_empty_range_in_cc
    syn_allow_double_range_op_in_cc
    syn_allow_invalid_code_end_of_range_in_cc
    syn_warn_cc_op_not_escaped
    syn_warn_redundant_nested_repeat

    meta_char_escape
    meta_char_anychar
    meta_char_anytime
    meta_char_zero_or_one_time
    meta_char_one_or_more_time
    meta_char_anychar_anytime
    ineffective_meta_char

## Contributing

In lieu of a formal styleguide, take care to maintain the existing coding style. Lint and test your code.

## License

Copyright (c) 2023 Ferdinand Prantl

Licensed under the MIT license.

[VPM]: https://vpm.vlang.io/packages/prantlf.onig
[Oniguruma]: https://github.com/kkos/oniguruma
