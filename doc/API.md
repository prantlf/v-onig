# Oniguruma API

## onig_init(encodings ...voidptr) !

Initialize library.

You do not have to call it explicitly. If not called explicitly, it will be called from within `onig_new()` implicitly.

## onig_end()

The use of this library is finished.

It is not allowed to use regex objects which created
before `onig_end()` call.

## onig_new(pattern string, option u32, encoding voidptr, syntax voidptr) !RegEx

Create a regex object.

* `pattern` - regex pattern string
* `option` - compile time options

```
non                 no option
single_line         '^' -> '\A', '$' -> '\Z'
multi_line          '.' match with newline
ignore_case         ambiguity match on
extend              extended pattern form
find_longest        find longest match
find_not_empty      ignore empty match
negate_single_line  clear single_line which is enabled on posix_basic/posix_extended/perl/perl_ng/python/java

dont_capture_group  only named group captured.
capture_group       named and no-named group captured.

ignore_case_is_ascii  Limit ignore_case((?i)) to a range of ASCII characters
word_is_ascii         ASCII only word (\w, \p{Word}, [[:word:]])
                        ASCII only word bound (\b)
digit_is_ascii        ASCII only digit (\d, \p{Digit}, [[:digit:]])
space_is_ascii        ASCII only space (\s, \p{Space}, [[:space:]])
posix_is_ascii        ASCII only POSIX properties
                        (includes word, digit, space)
                        (alnum, alpha, blank, cntrl, digit, graph,
                         lower, print, punct, space, upper, xdigit,
                         word)
text_segment_extended_grapheme_cluster  Extended Grapheme Cluster mode
text_segment_word                       Word mode
```

The `find_longest` option doesn't work properly during backward search of `onig_search()`.

* `encoding`: character encoding

```
encoding_ascii         ASCII
encoding_utf8          UTF-8
```

* `syntax`: address of pattern syntax definition

```
syntax_asis              plain text
syntax_posix_basic       POSIX Basic RE
syntax_posix_extended    POSIX Extended RE
syntax_emacs             Emacs
syntax_grep              grep
syntax_gnu               GNU regex
syntax_java              Java (Sun java.util.regex)
syntax_perl              Perl
syntax_perl_ng           Perl + named group
syntax_python            Python
syntax_oniguruma         Oniguruma
```

## (RegEx) free()

Free memory used by regex object.

## (RegEx) search(str string, start int, end int, option u32) !Match

Search string and return search result.

* `str` - target string
* `start` - search start position in the target string
* `end` - search end position in the target string (`-1` means the end of the string)
  - in forward search  (start <= searched string < end)
  - in backward search (end <= searched string <= start)
* `option` - search time option

```
not_bol             Do not regard the beginning of the (str) as the beginning of the line and the beginning of the string
not_eol             Do not regard the (end) as the end of a line and the end of a string
not_begin_string    Do not regard the beginning of the (str) as the beginning of a string  (* fail \A)
not_end_string      Do not regard the (end) as a string endpoint  (* fail \z, \Z)
not_begin_position  Do not regard the (start) as start position of search  (* fail \G)
```

## (RegEx) match_str(str string, start int, end int, option u32) !Match

Match string and return match result.

* `str` - target string
* `start` - search start position in the target string
* `end` - search end position in the target string (`-1` means the end of the string)
* `option` - search time option

```
not_bol             Do not regard the beginning of the (str) as the beginning of the line and the beginning of the string
not_eol             Do not regard the (end) as the end of a line and the end of a string
not_begin_string    Do not regard the beginning of the (str) as the beginning of a string  (* fail \A)
not_end_string      Do not regard the (end) as a string endpoint  (* fail \z, \Z)
not_begin_position  Do not regard the (start) as start position of search  (* fail \G)
```

## (RegEx) matches(str string, start int, end int, option u32) !bool

Match string and return if matches.

* `str` - target string
* `start` - search start position in the target string
* `end` - search end position in the target string (`-1` means the end of the string)
* `option` - search time option

```
not_bol             Do not regard the beginning of the (str) as the beginning of the line and the beginning of the string
not_eol             Do not regard the (end) as the end of a line and the end of a string
not_begin_string    Do not regard the beginning of the (str) as the beginning of a string  (* fail \A)
not_end_string      Do not regard the (end) as a string endpoint  (* fail \z, \Z)
not_begin_position  Do not regard the (start) as start position of search  (* fail \G)
```

<!-- ## (RegEx) group_texts_by_name(name string) ?[]int

Return the group number list for the name.
Named subexp is defined by (?<name>....).

* `name` - group name

## (RegEx) number_of_names() int

Return the number of names defined in the pattern.
Multiple definitions of one name is counted as one.

## (RegEx) number_of_captures() int

Return the number of capture group in the pattern. -->
