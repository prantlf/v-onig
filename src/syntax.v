module onig

@[noinit]
pub struct MetaCharTable {
mut:
	esc              u32
	anychar          u32
	anytime          u32
	zero_or_one_time u32
	one_or_more_time u32
	anychar_anytime  u32
}

@[noinit]
pub struct Syntax {
mut:
	op              u32
	op2             u32
	behavior        u32
	options         u32
	meta_char_table MetaCharTable
}

// syntax (operators)
pub const syn_op_variable_meta_characters = 1 << 0

pub const (
	syn_op_dot_anychar           = 1 << 1 // .
	syn_op_asterisk_zero_inf     = 1 << 2 // *
	syn_op_esc_asterisk_zero_inf = 1 << 3
)

pub const (
	syn_op_plus_one_inf     = 1 << 4 // +
	syn_op_esc_plus_one_inf = 1 << 5
)

pub const (
	syn_op_qmark_zero_one     = 1 << 6 // ?
	syn_op_esc_qmark_zero_one = 1 << 7
)

pub const (
	syn_op_brace_interval             = 1 << 8 // {lower,upper}
	syn_op_esc_brace_interval         = 1 << 9 // \{lower,upper\}
	syn_op_vbar_alt                   = 1 << 10 // |
	syn_op_esc_vbar_alt               = 1 << 11 // \|
	syn_op_lparen_subexp              = 1 << 12 // (...)
	syn_op_esc_lparen_subexp          = 1 << 13 // \(...\)
	syn_op_esc_az_buf_anchor          = 1 << 14 // \A, \Z, \z
	syn_op_esc_capital_g_begin_anchor = 1 << 15 // \G
	syn_op_decimal_backref            = 1 << 16 // \num
	syn_op_bracket_cc                 = 1 << 17 // [...]
	syn_op_esc_w_word                 = 1 << 18 // \w, \W
	syn_op_esc_ltgt_word_begin_end    = 1 << 19 // \<. \>
	syn_op_esc_b_word_bound           = 1 << 20 // \b, \B
	syn_op_esc_s_white_space          = 1 << 21 // \s, \S
	syn_op_esc_d_digit                = 1 << 22 // \d, \D
	syn_op_line_anchor                = 1 << 23 // ^, $
	syn_op_posix_bracket              = 1 << 24 // [:xxxx:]
	syn_op_qmark_non_greedy           = 1 << 25 // ??,*?,+?,{n,m}?
	syn_op_esc_control_chars          = 1 << 26 // \n,\r,\t,\a ...
	syn_op_esc_c_control              = 1 << 27 // \cx
	syn_op_esc_octal3                 = 1 << 28 // \OOO
	syn_op_esc_x_hex2                 = 1 << 29 // \xHH
	syn_op_esc_x_brace_hex8           = 1 << 30 // \x{7HHHHHHH}
	syn_op_esc_o_brace_octal          = 1 << 31 // \o{1OOOOOOOOOO}
)

pub const (
	syn_op2_esc_capital_q_quote           = 1 << 0 // \Q...\E
	syn_op2_qmark_group_effect            = 1 << 1 // (?...)
	syn_op2_option_perl                   = 1 << 2 // (?imsx),(?-imsx)
	syn_op2_option_ruby                   = 1 << 3 // (?imx), (?-imx)
	syn_op2_plus_possessive_repeat        = 1 << 4 // ?+,*+,++
	syn_op2_plus_possessive_interval      = 1 << 5 // {n,m}+
	syn_op2_cclass_set_op                 = 1 << 6 // [...&&..[..]..]
	syn_op2_qmark_lt_named_group          = 1 << 7 // (?<name>...)
	syn_op2_esc_k_named_backref           = 1 << 8 // \k<name>
	syn_op2_esc_g_subexp_call             = 1 << 9 // \g<name>, \g<n>
	syn_op2_atmark_capture_history        = 1 << 10 // (?@..),(?@<x>..)
	syn_op2_esc_capital_c_bar_control     = 1 << 11 // \C-x
	syn_op2_esc_capital_m_bar_meta        = 1 << 12 // \M-x
	syn_op2_esc_v_vtab                    = 1 << 13 // \v as VTAB
	syn_op2_esc_u_hex4                    = 1 << 14 // \uHHHH
	syn_op2_esc_gnu_buf_anchor            = 1 << 15 // \`, \'
	syn_op2_esc_p_brace_char_property     = 1 << 16 // \p{...}, \P{...}
	syn_op2_esc_p_brace_circumflex_not    = 1 << 17 // \p{^..}, \P{^..}
	// syn_op2_char_property_prefix_is = 1 << 18
	syn_op2_esc_h_xdigit                  = 1 << 19 // \h, \H
	syn_op2_ineffective_escape            = 1 << 20 // \
	syn_op2_qmark_lparen_if_else          = 1 << 21 // (?(n)) (?(...)...|...)
	syn_op2_esc_capital_k_keep            = 1 << 22 // \K
	syn_op2_esc_capital_r_general_newline = 1 << 23 // \R \r\n else [\x0a-\x0d]
	syn_op2_esc_capital_n_o_super_dot     = 1 << 24 // \N (?-m:.), \O (?m:.)
	syn_op2_qmark_tilde_absent_group      = 1 << 25 // (?~...)
	syn_op2_esc_x_y_grapheme_cluster      = 1 << 26 // obsoleted: use next
	syn_op2_esc_x_y_text_segment          = 1 << 26 // \X \y \Y
	syn_op2_qmark_perl_subexp_call        = 1 << 27 // (?R), (?&name)...
	syn_op2_qmark_brace_callout_contents  = 1 << 28 // (?{...}) (?{{...}})
	syn_op2_asterisk_callout_name         = 1 << 29 // (*name) (*name{a,..})
	syn_op2_option_oniguruma              = 1 << 30 // (?imxWDSPy)
	syn_op2_qmark_capital_p_name          = 1 << 31 // (?P<name>...) (?P=name)
)

// syntax (behavior)
pub const (
	syn_context_indep_anchors           = 1 << 31 // not implemented
	syn_context_indep_repeat_ops        = 1 << 0 // ?, *, +, {n,m}
	syn_context_invalid_repeat_ops      = 1 << 1 // error or ignore
	syn_allow_unmatched_close_subexp    = 1 << 2 // ...)...
	syn_allow_invalid_interval          = 1 << 3 // {???
	syn_allow_interval_low_abbrev       = 1 << 4 // {,n} => {0,n}
	syn_strict_check_backref            = 1 << 5 // /(\1)/,/\1()/ ..
	syn_different_len_alt_look_behind   = 1 << 6 // (?<=a|bc)
	syn_capture_only_named_group        = 1 << 7 // see doc/RE
	syn_allow_multiplex_definition_name = 1 << 8 // (?<x>)(?<x>)
	syn_fixed_interval_is_greedy_only   = 1 << 9 // a{n}?=(?:a{n})?
	syn_isolated_option_continue_branch = 1 << 10 // ..(?i)...|...
	syn_variable_len_look_behind        = 1 << 11 // (?<=a+|..)
	syn_python                          = 1 << 12 // \UHHHHHHHH
	syn_whole_options                   = 1 << 13 // (?Ie)
	syn_bre_anchor_at_edge_of_subexp    = 1 << 14 // \(^abc$\)
)

// syntax (behavior) in char class [...]
pub const (
	syn_not_newline_in_negative_cc = 1 << 20 // [^...]
	syn_backslash_escape_in_cc     = 1 << 21 // [..\w..] etc..
	syn_allow_empty_range_in_cc    = 1 << 22
)

pub const (
	syn_allow_double_range_op_in_cc           = 1 << 23 // [0-9-a]=[0-9\-a]
	syn_allow_invalid_code_end_of_range_in_cc = 1 << 26
)

// syntax (behavior) warning
pub const (
	syn_warn_cc_op_not_escaped       = 1 << 24 // [,-,]
	syn_warn_redundant_nested_repeat = 1 << 25 // (?:a*)+
)

// meta character specifiers (onig_set_meta_char())
pub const (
	meta_char_escape           = 0
	meta_char_anychar          = 1
	meta_char_anytime          = 2
	meta_char_zero_or_one_time = 3
	meta_char_one_or_more_time = 4
	meta_char_anychar_anytime  = 5
	ineffective_meta_char      = 0
)

pub fn Syntax.clone(orig voidptr) &Syntax {
	syntax := &Syntax{}
	C.onig_copy_syntax(voidptr(syntax), orig)
	return syntax
}
