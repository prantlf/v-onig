# Benchmarks

Iterating over a string and appending or not to a new string is faster than searching for a substring and then writing to a string builder or not:

    ❯ ./bench/bench-fix-perl-names.vsh
     SPENT     7.653 ms in fix subject pattern by iterating and appending
     SPENT    11.441 ms in fix subject pattern by searching and writing
     SPENT    17.226 ms in fix version pattern by iterating and appending
     SPENT    24.053 ms in fix version pattern by searching and writing

Oniguruma is significantly faster than the built-in regex, not speaking about the missing support for multiple groups with the same name, backward search and other features:

    ❯ ./bench/bench-regexes.vsh
     SPENT   379.917 ms in regex check
     SPENT   111.575 ms in prantlf.onig check
     SPENT   348.380 ms in regex match
     SPENT   141.854 ms in prantlf.onig match
     SPENT   312.463 ms in regex groups
     SPENT   153.655 ms in prantlf.onig groups
     SPENT   320.144 ms in regex named groups
     SPENT   217.386 ms in prantlf.onig named groups

When only a match of a regex is needed, Oniguruma, PCRE and RE2 are significantly faster than the built-in regex. When the unnamed groups are needed, the times become more similar, with PCRE having an edge. When named groups are needed, the times are quite similar, with Oniguruma having the edge:

    ❯ ./bench/bench-all-regexes.vsh
     SPENT    17.089 ms in regex test
     SPENT    19.302 ms in regex unamed
     SPENT   150.293 ms in regex named
     SPENT    63.697 ms in regex miss
     SPENT     5.374 ms in prantlf.onig test
     SPENT    17.552 ms in prantlf.onig unnamed
     SPENT   103.150 ms in prantlf.onig named
     SPENT    52.215 ms in prantlf.onig miss
     SPENT     5.907 ms in pcre test
     SPENT     5.519 ms in pcre unnamed
         N/A	pcre named
         N/A	pcre miss
     SPENT    12.108 ms in prantlf.pcre2 test
     SPENT    12.759 ms in prantlf.pcre2 unnamed
         N/A	prantlf.pcre2 named
         N/A	prantlf.pcre2 miss
     SPENT     5.141 ms in prantlf.re2 test
     SPENT    19.137 ms in prantlf.re2 unnamed
     SPENT   128.716 ms in prantlf.re2 named
     SPENT    79.792 ms in prantlf.re2 miss