module onig

[noinit]
pub struct MetaCharTable {
mut:
	esc              u32
	anychar          u32
	anytime          u32
	zero_or_one_time u32
	one_or_more_time u32
	anychar_anytime  u32
}

[noinit]
pub struct Syntax {
mut:
	op              u32
	op2             u32
	behavior        u32
	options         u32
	meta_char_table MetaCharTable
}

/* syntax (operators) */
pub const syn_op_variable_meta_characters = 1 << 0

pub const syn_op_dot_anychar = 1 << 1 /* . */
pub const syn_op_asterisk_zero_inf = 1 << 2 /* * */
pub const syn_op_esc_asterisk_zero_inf = 1 << 3

pub const syn_op_plus_one_inf = 1 << 4 /* + */
pub const syn_op_esc_plus_one_inf = 1 << 5

pub const syn_op_qmark_zero_one = 1 << 6 /* ? */
pub const syn_op_esc_qmark_zero_one = 1 << 7

pub const syn_op_brace_interval = 1 << 8 /* {lower,upper} */
pub const syn_op_esc_brace_interval = 1 << 9 /* \{lower,upper\} */
pub const syn_op_vbar_alt = 1 << 10 /* | */
pub const syn_op_esc_vbar_alt = 1 << 11 /* \| */
pub const syn_op_lparen_subexp = 1 << 12 /* (...) */
pub const syn_op_esc_lparen_subexp = 1 << 13 /* \(...\) */
pub const syn_op_esc_az_buf_anchor = 1 << 14 /* \A, \Z, \z */
pub const syn_op_esc_capital_g_begin_anchor = 1 << 15 /* \G */
pub const syn_op_decimal_backref = 1 << 16 /* \num */
pub const syn_op_bracket_cc = 1 << 17 /* [...] */
pub const syn_op_esc_w_word = 1 << 18 /* \w, \W */
pub const syn_op_esc_ltgt_word_begin_end = 1 << 19 /* \<. \> */
pub const syn_op_esc_b_word_bound = 1 << 20 /* \b, \B */
pub const syn_op_esc_s_white_space = 1 << 21 /* \s, \S */
pub const syn_op_esc_d_digit = 1 << 22 /* \d, \D */
pub const syn_op_line_anchor = 1 << 23 /* ^, $ */
pub const syn_op_posix_bracket = 1 << 24 /* [:xxxx:] */
pub const syn_op_qmark_non_greedy = 1 << 25 /* ??,*?,+?,{n,m}? */
pub const syn_op_esc_control_chars = 1 << 26 /* \n,\r,\t,\a ... */
pub const syn_op_esc_c_control = 1 << 27 /* \cx */
pub const syn_op_esc_octal3 = 1 << 28 /* \OOO */
pub const syn_op_esc_x_hex2 = 1 << 29 /* \xHH */
pub const syn_op_esc_x_brace_hex8 = 1 << 30 /* \x{7HHHHHHH} */
pub const syn_op_esc_o_brace_octal = 1 << 31 /* \o{1OOOOOOOOOO} */

pub const syn_op2_esc_capital_q_quote = 1 << 0 /* \Q...\E */
pub const syn_op2_qmark_group_effect = 1 << 1 /* (?...) */
pub const syn_op2_option_perl = 1 << 2 /* (?imsx),(?-imsx) */
pub const syn_op2_option_ruby = 1 << 3 /* (?imx), (?-imx) */
pub const syn_op2_plus_possessive_repeat = 1 << 4 /* ?+,*+,++ */
pub const syn_op2_plus_possessive_interval = 1 << 5 /* {n,m}+ */
pub const syn_op2_cclass_set_op = 1 << 6 /* [...&&..[..]..] */
pub const syn_op2_qmark_lt_named_group = 1 << 7 /* (?<name>...) */
pub const syn_op2_esc_k_named_backref = 1 << 8 /* \k<name> */
pub const syn_op2_esc_g_subexp_call = 1 << 9 /* \g<name>, \g<n> */
pub const syn_op2_atmark_capture_history = 1 << 10 /* (?@..),(?@<x>..) */
pub const syn_op2_esc_capital_c_bar_control = 1 << 11 /* \C-x */
pub const syn_op2_esc_capital_m_bar_meta = 1 << 12 /* \M-x */
pub const syn_op2_esc_v_vtab = 1 << 13 /* \v as VTAB */
pub const syn_op2_esc_u_hex4 = 1 << 14 /* \uHHHH */
pub const syn_op2_esc_gnu_buf_anchor = 1 << 15 /* \`, \' */
pub const syn_op2_esc_p_brace_char_property = 1 << 16 /* \p{...}, \P{...} */
pub const syn_op2_esc_p_brace_circumflex_not = 1 << 17 /* \p{^..}, \P{^..} */
/* pub const syn_op2_char_property_prefix_is = 1 << 18 */
pub const syn_op2_esc_h_xdigit = 1 << 19 /* \h, \H */
pub const syn_op2_ineffective_escape = 1 << 20 /* \ */
pub const syn_op2_qmark_lparen_if_else = 1 << 21 /* (?(n)) (?(...)...|...) */
pub const syn_op2_esc_capital_k_keep = 1 << 22 /* \K */
pub const syn_op2_esc_capital_r_general_newline = 1 << 23 /* \R \r\n else [\x0a-\x0d] */
pub const syn_op2_esc_capital_n_o_super_dot = 1 << 24 /* \N (?-m:.), \O (?m:.) */
pub const syn_op2_qmark_tilde_absent_group = 1 << 25 /* (?~...) */
pub const syn_op2_esc_x_y_grapheme_cluster = 1 << 26 /* obsoleted: use next */
pub const syn_op2_esc_x_y_text_segment = 1 << 26 /* \X \y \Y */
pub const syn_op2_qmark_perl_subexp_call = 1 << 27 /* (?R), (?&name)... */
pub const syn_op2_qmark_brace_callout_contents = 1 << 28 /* (?{...}) (?{{...}}) */
pub const syn_op2_asterisk_callout_name = 1 << 29 /* (*name) (*name{a,..}) */
pub const syn_op2_option_oniguruma = 1 << 30 /* (?imxWDSPy) */
pub const syn_op2_qmark_capital_p_name = 1 << 31 /* (?P<name>...) (?P=name) */

/* syntax (behavior) */
pub const syn_context_indep_anchors = 1 << 31 /* not implemented */
pub const syn_context_indep_repeat_ops = 1 << 0 /* ?, *, +, {n,m} */
pub const syn_context_invalid_repeat_ops = 1 << 1 /* error or ignore */
pub const syn_allow_unmatched_close_subexp = 1 << 2 /* ...)... */
pub const syn_allow_invalid_interval = 1 << 3 /* {??? */
pub const syn_allow_interval_low_abbrev = 1 << 4 /* {,n} => {0,n} */
pub const syn_strict_check_backref = 1 << 5 /* /(\1)/,/\1()/ .. */
pub const syn_different_len_alt_look_behind = 1 << 6 /* (?<=a|bc) */
pub const syn_capture_only_named_group = 1 << 7 /* see doc/RE */
pub const syn_allow_multiplex_definition_name = 1 << 8 /* (?<x>)(?<x>) */
pub const syn_fixed_interval_is_greedy_only = 1 << 9 /* a{n}?=(?:a{n})? */
pub const syn_isolated_option_continue_branch = 1 << 10 /* ..(?i)...|... */
pub const syn_variable_len_look_behind = 1 << 11 /* (?<=a+|..) */
pub const syn_python = 1 << 12 /* \UHHHHHHHH */
pub const syn_whole_options = 1 << 13 /* (?Ie) */

/* syntax (behavior) in char class [...] */
pub const syn_not_newline_in_negative_cc = 1 << 20 /* [^...] */
pub const syn_backslash_escape_in_cc = 1 << 21 /* [..\w..] etc.. */
pub const syn_allow_empty_range_in_cc = 1 << 22

pub const syn_allow_double_range_op_in_cc = 1 << 23 /* [0-9-a]=[0-9\-a] */
pub const syn_allow_invalid_code_end_of_range_in_cc = 1 << 26

/* syntax (behavior) warning */
pub const syn_warn_cc_op_not_escaped = 1 << 24 /* [,-,] */
pub const syn_warn_redundant_nested_repeat = 1 << 25 /* (?:a*)+ */

/* meta character specifiers (onig_set_meta_char()) */
pub const meta_char_escape = 0

pub const meta_char_anychar = 1

pub const meta_char_anytime = 2

pub const meta_char_zero_or_one_time = 3

pub const meta_char_one_or_more_time = 4

pub const meta_char_anychar_anytime = 5

pub const ineffective_meta_char = 0

pub fn Syntax.clone(orig voidptr) &Syntax {
	syntax := &Syntax{}
	C.onig_copy_syntax(voidptr(syntax), orig)
	return syntax
}
