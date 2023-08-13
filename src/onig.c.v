module onig

#flag -I @VROOT/libonig
#flag @VROOT/libonig/regparse.o
#flag @VROOT/libonig/regcomp.o
#flag @VROOT/libonig/regexec.o
#flag @VROOT/libonig/regenc.o
#flag @VROOT/libonig/regerror.o
#flag @VROOT/libonig/regsyntax.o
#flag @VROOT/libonig/regtrav.o
#flag @VROOT/libonig/st.o
#flag @VROOT/libonig/unicode.o
#flag @VROOT/libonig/unicode_unfold_key.o
#flag @VROOT/libonig/unicode_fold1_key.o
#flag @VROOT/libonig/unicode_fold2_key.o
#flag @VROOT/libonig/unicode_fold3_key.o
#flag @VROOT/libonig/ascii.o
#flag @VROOT/libonig/utf8.o
#include "oniguruma.h"
#include "regint.h"

[typedef]
struct C.OnigRegion {
	allocated    int
	num_regs     int
	beg          &int     = unsafe { nil }
	end          &int     = unsafe { nil }
	history_root &voidptr = unsafe { nil }
}

[typedef]
struct C.OnigErrorInfo {
	enc     voidptr
	par     &u8 = unsafe { nil }
	par_end &u8 = unsafe { nil }
}

[typedef]
struct C.OnigEncoding {
	mbc_enc_len                voidptr
	name                       &u8 = unsafe { nil }
	max_enc_len                int
	min_enc_len                int
	is_mbc_newline             voidptr
	mbc_to_code                voidptr
	code_to_mbclen             voidptr
	code_to_mbc                voidptr
	mbc_case_fold              voidptr
	apply_all_case_fold        voidptr
	get_case_fold_codes_by_str voidptr
	property_name_to_ctype     voidptr
	is_code_ctype              voidptr
	get_ctype_code_range       voidptr
	left_adjust_char_head      voidptr
	is_allowed_reverse_match   voidptr
	init                       voidptr
	is_initialized             voidptr
	is_valid_mbc_string        voidptr
	flag                       u32
	sb_range                   u32
	index                      int
}

[typedef]
struct C.OnigMetaCharTable {
	esc              u32
	anychar          u32
	anytime          u32
	zero_or_one_time u32
	one_or_more_time u32
	anychar_anytime  u32
}

[typedef]
struct C.OnigSyntax {
	op              u32
	op2             u32
	behavior        u32
	options         u32
	meta_char_table C.OnigMetaCharTable
}

[typedef]
struct C.RepeatRange {
	lower int
	upper int
}

[typedef]
struct C.RegexExt {
	pat     &u8 = unsafe { nil }
	pat_end &u8 = unsafe { nil }
	// tag_table          voidptr
	// callout_num        int
	// callout_list_alloc int
	// callout_list       voidptr
}

[typedef]
struct C.OnigRegex {
	ops             voidptr
	ocs             &int = unsafe { nil }
	ops_curr        voidptr
	ops_used        u32
	ops_alloc       u32
	string_pool     &u8 = unsafe { nil }
	string_pool_end &u8 = unsafe { nil }

	num_mem            int
	num_repeat         int
	num_empty_check    int
	num_call           int
	capture_history    u32
	push_mem_start     u32
	push_mem_end       u32
	stack_pop_level    int
	repeat_range_alloc int
	repeat_range       &C.RepeatRange = unsafe { nil }

	enc            &C.OnigEncoding = unsafe { nil }
	options        u32
	syntax         &C.OnigSyntax = unsafe { nil }
	case_fold_flag u32
	name_table     voidptr

	optimize      int
	threshold_len int
	anchor        int
	anc_dist_min  u32
	anc_dist_max  u32
	sub_anchor    int
	exact         &u8 = unsafe { nil }
	exact_end     &u8 = unsafe { nil }
	// map           u8          [C.CHAR_MAP_SIZE]
	map_offset int
	dist_min   u32
	dist_max   u32
	extp       &C.RegexExt = unsafe { nil }
}

type NameCallback = fn (name &u8, end &u8, grp_num_cnt int, grp_nums &int, re &C.OnigRegex, arg voidptr) int

fn C.onig_initialize(encs &&C.OnigEncoding, encs_cnt int) int

fn C.onig_is_initialized() int

fn C.onig_end() int

fn C.onig_copy_syntax(to &C.OnigSyntax, from &C.OnigSyntax)

fn C.onig_new(re &&C.OnigRegex, pat &u8, pat_end &u8, opt u32, enc &C.OnigEncoding, syntax &C.OnigSyntax, einfo &C.OnigErrorInfo) int

fn C.onig_search(re &C.OnigRegex, s &u8, end &u8, start &u8, range &u8, rg &C.OnigRegion, opt u32) int

fn C.onig_match(re &C.OnigRegex, s &u8, end &u8, at &u8, rg &C.OnigRegion, opt u32) int

// fn C.onig_number_of_captures(re &C.OnigRegex) int

fn C.onig_number_of_names(re &C.OnigRegex) int

// fn C.onig_name_to_group_numbers(re &C.OnigRegex, name &u8, name_end &u8, num_list &&int) int

fn C.onig_foreach_name(re &C.OnigRegex, name_cbk NameCallback, arg voidptr) int

fn C.onig_free(re &C.OnigRegex)

fn C.onig_region_new() &C.OnigRegion

fn C.onig_region_free(r &C.OnigRegion, free_self int)

fn C.onig_region_clear(r &C.OnigRegion)

fn C.onig_error_code_to_str(s &u8, err_code int, ...voidptr) int

// pub fn (r &RegEx) number_of_captures() int {
// 	return C.onig_number_of_captures(r.re)
// }

// pub fn (r &RegEx) number_of_names() int {
// 	return C.onig_number_of_names(r.re)
// }

// pub fn (r &RegEx) groups_indexes_by_name(name string) ?[]int {
// 	grps := unsafe { &int(nil) }
// 	cnt := C.onig_name_to_group_numbers(r.re, name.str, unsafe { name.str + name.len },
// 		&grps)
// 	return if cnt > 0 {
// 		[]int{len: cnt, init: unsafe { grps[index] }}
// 	} else if cnt == 0 {
// 		[]int{}
// 	} else {
// 		none
// 	}
// }
