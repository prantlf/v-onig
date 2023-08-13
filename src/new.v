module onig

[heap; noinit]
pub struct RegEx {
	re &C.OnigRegex = unsafe { nil }
mut:
	rg &C.OnigRegion = unsafe { nil }
}

/* options */
pub const opt_none = 0

pub const opt_ignore_case = 1

pub const opt_extend = 1 << 1

pub const opt_multi_line = 1 << 2

pub const opt_single_line = 1 << 3

pub const opt_find_longest = 1 << 4

pub const opt_find_not_empty = 1 << 5

pub const opt_negate_single_line = 1 << 6

pub const opt_dont_capture_group = 1 << 7

pub const opt_capture_group = 1 << 8

pub const opt_ignore_case_is_ascii = 1 << 15

pub const opt_word_is_ascii = 1 << 16

pub const opt_digit_is_ascii = 1 << 17

pub const opt_space_is_ascii = 1 << 18

pub const opt_posix_is_ascii = 1 << 19

pub const opt_text_segment_extended_grapheme_cluster = 1 << 20

pub const opt_text_segment_word = 1 << 21

/* encodings */
pub const encoding_ascii = voidptr(&C.OnigEncodingASCII)

pub const encoding_utf8 = voidptr(&C.OnigEncodingUTF8)

// pub const encoding_iso_8859_1 = voidptr(&C.OnigEncodingISO_8859_1)
// pub const encoding_iso_8859_2 = voidptr(&C.OnigEncodingISO_8859_2)
// pub const encoding_iso_8859_3 = voidptr(&C.OnigEncodingISO_8859_3)
// pub const encoding_iso_8859_4 = voidptr(&C.OnigEncodingISO_8859_4)
// pub const encoding_iso_8859_5 = voidptr(&C.OnigEncodingISO_8859_5)
// pub const encoding_iso_8859_6 = voidptr(&C.OnigEncodingISO_8859_6)
// pub const encoding_iso_8859_7 = voidptr(&C.OnigEncodingISO_8859_7)
// pub const encoding_iso_8859_8 = voidptr(&C.OnigEncodingISO_8859_8)
// pub const encoding_iso_8859_9 = voidptr(&C.OnigEncodingISO_8859_9)
// pub const encoding_iso_8859_10 = voidptr(&C.OnigEncodingISO_8859_10)
// pub const encoding_iso_8859_11 = voidptr(&C.OnigEncodingISO_8859_11)
// pub const encoding_iso_8859_13 = voidptr(&C.OnigEncodingISO_8859_13)
// pub const encoding_iso_8859_14 = voidptr(&C.OnigEncodingISO_8859_14)
// pub const encoding_iso_8859_15 = voidptr(&C.OnigEncodingISO_8859_15)
// pub const encoding_iso_8859_16 = voidptr(&C.OnigEncodingISO_8859_16)
// pub const encoding_utf16_be = voidptr(&C.OnigEncodingUTF16_BE)
// pub const encoding_utf16_le = voidptr(&C.OnigEncodingUTF16_LE)
// pub const encoding_utf32_be = voidptr(&C.OnigEncodingUTF32_BE)
// pub const encoding_utf32_le = voidptr(&C.OnigEncodingUTF32_LE)
// pub const encoding_euc_jp = voidptr(&C.OnigEncodingEUC_JP)
// pub const encoding_euc_tw = voidptr(&C.OnigEncodingEUC_TW)
// pub const encoding_euc_kr = voidptr(&C.OnigEncodingEUC_KR)
// pub const encoding_euc_cn = voidptr(&C.OnigEncodingEUC_CN)
// pub const encoding_sjis = voidptr(&C.OnigEncodingSJIS)
// pub const encoding_koi8 = voidptr(&C.OnigEncodingKOI8)
// pub const encoding_koi8_r = voidptr(&C.OnigEncodingKOI8_R)
// pub const encoding_cp1251 = voidptr(&C.OnigEncodingCP1251)
// pub const encoding_big5 = voidptr(&C.OnigEncodingBIG5)
// pub const encoding_gb18030 = voidptr(&C.OnigEncodingGB18030)

/* syntaxes */
pub const syntax_asis = voidptr(&C.OnigSyntaxASIS)

pub const syntax_posix_basic = voidptr(&C.OnigSyntaxPosixBasic)

pub const syntax_posix_extended = voidptr(&C.OnigSyntaxPosixExtended)

pub const syntax_emacs = voidptr(&C.OnigSyntaxEmacs)

pub const syntax_grep = voidptr(&C.OnigSyntaxGrep)

pub const syntax_gnu = voidptr(&C.OnigSyntaxGnuRegex)

pub const syntax_java = voidptr(&C.OnigSyntaxJava)

pub const syntax_perl = voidptr(&C.OnigSyntaxPerl)

pub const syntax_perl_ng = voidptr(&C.OnigSyntaxPerl_NG)

pub const syntax_ruby = voidptr(&C.OnigSyntaxRuby)

pub const syntax_python = voidptr(&C.OnigSyntaxPython)

pub const syntax_oniguruma = voidptr(&C.OnigSyntaxOniguruma)

pub fn onig_new(pat string, opt u32) !&RegEx {
	return onig_new_custom(pat, opt, onig.encoding_ascii, onig.syntax_oniguruma)!
}

pub fn onig_new_utf8(pat string, opt u32) !&RegEx {
	return onig_new_custom(pat, opt, onig.encoding_utf8, onig.syntax_oniguruma)!
}

pub fn onig_new_custom(pat string, opt u32, enc voidptr, syntax voidptr) !&RegEx {
	if C.onig_is_initialized() == 0 {
		onig_init()!
	}
	re := &C.OnigRegex(unsafe { nil })
	einfo := C.OnigErrorInfo{}
	res := C.onig_new(&re, pat.str, unsafe { pat.str + pat.len }, u32(opt), enc, syntax,
		&einfo)
	if res != C.ONIG_NORMAL {
		return fail_new(res, einfo)
	}
	return &RegEx{
		re: re
	}
}

pub fn (r &RegEx) free() {
	if !isnil(r.rg) {
		C.onig_region_free(r.rg, 1)
	}
	C.onig_free(r.re)
}

fn (mut r RegEx) get_region() &C.OnigRegion {
	if isnil(r.rg) {
		r.rg = C.onig_region_new()
	} else {
		C.onig_region_clear(r.rg)
	}
	return r.rg
}

fn fail_new(res int, einfo &C.OnigErrorInfo) CompileError {
	buf := []u8{len: C.ONIG_MAX_ERROR_MESSAGE_LEN}
	len := C.onig_error_code_to_str(buf.data, res, einfo)
	msg := unsafe { (&u8(buf.data)).vstring_with_len(len) }
	return CompileError{
		msg: msg.clone()
	}
}
