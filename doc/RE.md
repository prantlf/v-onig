# Oniguruma Regular Expression Syntax

## 1. Syntax elements

    \       escape (enable or disable meta character)
    |       alternation
    (...)   group
    [...]   character class

## 2. Characters

    \t           horizontal tab         (0x09)
    \v           vertical tab           (0x0B)
    \n           newline (line feed)    (0x0A)
    \r           carriage return        (0x0D)
    \b           backspace              (0x08)
    \f           form feed              (0x0C)
    \a           bell                   (0x07)
    \e           escape                 (0x1B)
    \nnn         octal char                    (encoded byte value)
    \xHH         hexadecimal char              (encoded byte value)
    \x{7HHHHHHH} (1-8 digits) hexadecimal char (code point value)
    \o{17777777777} (1-11 digits) octal char   (code point value)
    \uHHHH       hexadecimal char              (code point value)
    \cx          control char                  (code point value)
    \C-x         control char                  (code point value)
    \M-x         meta  (x|0x80)                (code point value)
    \M-\C-x      meta control char             (code point value)

    (* \b as backspace is effective in character class only)

### 2.1 Code point sequences

    Hexadecimal code point  (1-8 digits)
    \x{7HHHHHHH 7HHHHHHH ... 7HHHHHHH}

    Octal code point  (1-11 digits)
    \o{17777777777 17777777777 ... 17777777777}

## 3. Character types

    .        any character (except newline)

    \w       word character

            Not Unicode:
              alphanumeric, "_" and multibyte char.

            Unicode:
              General_Category -- (Letter|Mark|Number|Connector_Punctuation)

    \W       non-word char

    \s       whitespace char

            Not Unicode:
              \t, \n, \v, \f, \r, \x20

            Unicode case:
              U+0009, U+000A, U+000B, U+000C, U+000D, U+0085(NEL),
              General_Category -- Line_Separator
                                -- Paragraph_Separator
                                -- Space_Separator

    \S       non-whitespace char

    \d       decimal digit char

            Unicode: General_Category -- Decimal_Number

    \D       non-decimal-digit char

    \h       hexadecimal digit char   [0-9a-fA-F]

    \H       non-hexdigit char

    \R       general newline  (* can't be used in character-class)
            "\r\n" or \n,\v,\f,\r  (* but doesn't backtrack from \r\n to \r)

            Unicode case:
              "\r\n" or \n,\v,\f,\r or U+0085, U+2028, U+2029

    \N       negative newline  (?-m:.)

    \O       true anychar      (?m:.)    (* original function)

    \X       Text Segment    \X === (?>\O(?:\Y\O)*)

            The meaning of this operator changes depending on the setting of
            the option (?y{..}).

            \X doesn't check whether matching start position is boundary or not.
            Please write as \y\X if you want to ensure it.

            [Extended Grapheme Cluster mode] (default)
              Unicode case:
                See [Unicode Standard Annex #29: http://unicode.org/reports/tr29/]

              Not Unicode case:  \X === (?>\r\n|\O)

            [Word mode]
              Currently, this mode is supported in Unicode only.
              See [Unicode Standard Annex #29: http://unicode.org/reports/tr29/]

### Character Property

    * \p{property-name}
    * \p{^property-name}    (negative)
    * \P{property-name}     (negative)

#### property-name

+ works on all encodings

```
Alnum, Alpha, Blank, Cntrl, Digit, Graph, Lower,
Print, Punct, Space, Upper, XDigit, Word, ASCII
```

+ works on UTF8

See [UNICODE properties](UNICODE_PROPERTIES.md).

## 4. Quantifier

### greedy

    ?       1 or 0 times
    *       0 or more times
    +       1 or more times
    {n,m}   (n <= m)  at least n but no more than m times
    {n,}    at least n times
    {,n}    at least 0 but no more than n times ({0,n})
    {n}     n times

### reluctant

    ??      0 or 1 times
    *?      0 or more times
    +?      1 or more times
    {n,m}?  (n <= m)  at least n but not more than m times
    {n,}?   at least n times
    {,n}?   at least 0 but not more than n times (== {0,n}?)

    {n}?    is reluctant operator in syntax_java and syntax_perl only
            (In that case, it doesn't make sense to write so.)
            In default syntax, /a{n}?/ === /(?:a{n})?/

### possessive (greedy and does not backtrack once match)

    ?+      1 or 0 times
    *+      0 or more times
    ++      1 or more times
    {n,m}   (n > m)  at least m but not more than n times

    {n,m}+, {n,}+, {n}+  are possessive operators in syntax_java and
                         syntax_perl only

    ex. /a*+/ === /(?>a*)/

## 5. Anchors

    ^       beginning of the line
    $       end of the line
    \b      word boundary
    \B      non-word boundary

    \A      beginning of string
    \Z      end of string, or before newline at the end
    \z      end of string
    \G      where the current search attempt begins
    \K      keep (keep start position of the result string)


    \y      Text Segment boundary
    \Y      Text Segment non-boundary

            The meaning of these operators(\y, \Y) changes depending on the setting
            of the option (?y{..}).

            [Extended Grapheme Cluster mode] (default)
              Unicode case:
                See [Unicode Standard Annex #29: http://unicode.org/reports/tr29/]

              Not Unicode:
                All positions except between \r and \n.

            [Word mode]
              Currently, this mode is supported in Unicode only.
              See [Unicode Standard Annex #29: http://unicode.org/reports/tr29/]

## 6. Character class

    ^...    negative class (lowest precedence)
    x-y     range from x to y
    [...]   set (character class in character class)
    ..&&..  intersection (low precedence, only higher than ^)

      ex. [a-w&&[^c-g]z] ==> ([a-w] AND ([^c-g] OR z)) ==> [abh-w]

    * If you want to use '[', '-', or ']' as a normal character
      in character class, you should escape them with '\'.

    POSIX bracket ([:xxxxx:], negate [:^xxxxx:])

### Not Unicode Case

    alnum    alphabet or digit char
    alpha    alphabet
    ascii    code value: [0 - 127]
    blank    \t, \x20
    cntrl
    digit    0-9
    graph    include all of multibyte encoded characters
    lower
    print    include all of multibyte encoded characters
    punct
    space    \t, \n, \v, \f, \r, \x20
    upper
    xdigit   0-9, a-f, A-F
    word     alphanumeric, "_" and multibyte characters

### Unicode Case

    alnum    Letter | Mark | Decimal_Number
    alpha    Letter | Mark
    ascii    0000 - 007F
    blank    Space_Separator | 0009
    cntrl    Control | Format | Unassigned | Private_Use | Surrogate
    digit    Decimal_Number
    graph    [[:^space:]] && ^Control && ^Unassigned && ^Surrogate
    lower    Lowercase_Letter
    print    [[:graph:]] | [[:space:]]
    punct    Connector_Punctuation | Dash_Punctuation | Close_Punctuation |
              Final_Punctuation | Initial_Punctuation | Other_Punctuation |
              Open_Punctuation
    space    Space_Separator | Line_Separator | Paragraph_Separator |
              U+0009 | U+000A | U+000B | U+000C | U+000D | U+0085
    upper    Uppercase_Letter
    xdigit   U+0030 - U+0039 | U+0041 - U+0046 | U+0061 - U+0066
              (0-9, a-f, A-F)
    word     Letter | Mark | Decimal_Number | Connector_Punctuation

## 7. Extended groups

    (?#...)            comment

    (?imxWDSPy-imxWDSP:subexp)  option on/off for subexp

                           i: ignore case
                           m: multi-line (dot (.) also matches newline)
                           x: extended form
                           W: ASCII only word (\w, \p{Word}, [[:word:]])
                              ASCII only word bound (\b)
                           D: ASCII only digit (\d, \p{Digit}, [[:digit:]])
                           S: ASCII only space (\s, \p{Space}, [[:space:]])
                           P: ASCII only POSIX properties (includes W,D,S)
                              (alnum, alpha, blank, cntrl, digit, graph,
                               lower, print, punct, space, upper, xdigit, word)

                           y{?}: Text Segment mode
                              This option changes the meaning of \X, \y, \Y.
                              Currently, this option is supported in Unicode only.

                              y{g}: Extended Grapheme Cluster mode (default)
                              y{w}: Word mode
                              See [Unicode Standard Annex #29]

    (?imxWDSPy-imxWDSP)  isolated option

                      * It makes a group to the next ')' or end of the pattern.
                        /ab(?i)c|def|gh/ == /ab(?i:c|def|gh)/

    (?:subexp)         non-capturing group
    (subexp)           capturing group

    (?=subexp)         look-ahead
    (?!subexp)         negative look-ahead

    (?<=subexp)        look-behind
    (?<!subexp)        negative look-behind

                     * Cannot use Absent stopper (?~|expr) and Range clear
                       (?~|) operators in look-behind and negative look-behind.

                     * In look-behind and negative look-behind, support for
                       ignore-case option is limited. Only supports conversion
                       between single characters. (Does not support conversion
                       of multiple characters in Unicode)

    (?>subexp)         atomic group
                       no backtracks in subexp.

    (?<name>subexp), (?'name'subexp)
                      define named group
                      (Each character of the name must be a word character.)

                      Not only a name but a number is assigned like a capturing
                      group.

                      Assigning the same name to two or more subexps is allowed.


## 8. Backreferences

When we say "backreference a group," it actually means, "re-match the same
text matched by the subexp in that group."

    \n  \k<n>     \k'n'     (n >= 1) backreference the nth group in the regexp
        \k<name>  \k'name'  backreference a group with the specified name

When backreferencing with a name that is assigned to more than one groups,
the last group with the name is checked first, if not matched then the
previous one with the name, and so on, until there is a match.

* Backreference by number is forbidden if any named group is defined and
  opt_capture_group is not set.

## 9. Captured group

Behavior of an unnamed group (...) changes with the following conditions.
(But named group is not changed.)

    case 1. /.../     (named group is not used, no option)

      (...) is treated as a capturing group.

    case 2. /.../g    (named group is not used, 'g' option)

      (...) is treated as a non-capturing group (?:...).

    case 3. /..(?<name>..)../   (named group is used, no option)

      (...) is treated as a non-capturing group.
      numbered-backref/call is not allowed.

    case 4. /..(?<name>..)../G  (named group is used, 'G' option)

      (...) is treated as a capturing group.
      numbered-backref/call is allowed.

    where
      g: opt_dont_capture_group
      G: opt_capture_group

## Apendix

### A-1. Syntax-dependent options

    + syntax_oniguruma
      (?m): dot (.) also matches newline

    + syntax_perl and syntax_java
      (?s): dot (.) also matches newline
      (?m): ^ matches after newline, $ matches before newline

### A-2. Original extensions

    + hexadecimal digit char type     \h, \H
    + true anychar                    \O
    + text segment boundary           \y, \Y
    + backreference validity checker  (?(...))
    + named group                     (?<name>...), (?'name'...)
    + named backref                   \k<name>
    + absent expression               (?~|...|...)
    + absent stopper                  (?~|...)

### A-3. Missing features compared with perl 5.8.0

    + \N{name}
    + \l,\u,\L,\U,\C
    + (??{code})
    * \Q...\E
      This is effective on ONIG_SYNTAX_PERL and ONIG_SYNTAX_JAVA.

### A-4. Differences with Japanized GNU regex(version 0.12) of Ruby 1.8

    + add character property (\p{property}, \P{property})
    + add hexadecimal digit char type (\h, \H)
    + add look-behind
      (?<=fixed-width-pattern), (?<!fixed-width-pattern)
    + add possessive quantifier. ?+, *+, ++
    + add operations in character class. [], &&
      ('[' must be escaped as an usual char in character class.)
    + add named group and subexp call.
    + octal or hexadecimal number sequence can be treated as
      a multibyte code char in character class if multibyte encoding
      is specified.
      (ex. [\xa1\xa2], [\xa1\xa7-\xa4\xa1])
    + allow the range of single byte char and multibyte char in character
      class.
      ex. /[a-<<any EUC-JP character>>]/ in EUC-JP encoding.
    + effect range of isolated option is to next ')'.
      ex. (?:(?i)a|b) is interpreted as (?:(?i:a|b)), not (?:(?i:a)|b).
    + isolated option is not transparent to previous pattern.
      ex. a(?i)* is a syntax error pattern.
    + allowed unpaired left brace as a normal character.
      ex. /{/, /({)/, /a{2,3/ etc...
    + negative POSIX bracket [:^xxxx:] is supported.
    + POSIX bracket [:ascii:] is added.
    + repeat of look-ahead is not allowed.
      ex. /(?=a)*/, /(?!b){5}/
    + Ignore case option is effective to escape sequence.
      ex. /\x61/i =~ "A"
    + In the range quantifier, the number of the minimum is optional.
      /a{,n}/ == /a{0,n}/
      The omission of both minimum and maximum values is not allowed.
      /a{,}/
    + /{n}?/ is not a reluctant quantifier.
      /a{n}?/ == /(?:a{n})?/
    + invalid back reference is checked and raises error.
      /\1/, /(a)\2/
    + Zero-width match in an infinite loop stops the repeat,
      then changes of the capture group status are checked as stop condition.
      /(?:()|())*\1\2/ =~ ""
      /(?:\1a|())*/ =~ "a"
