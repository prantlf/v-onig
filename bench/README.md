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
     SPENT    84.612 ms in regex test
     SPENT    86.953 ms in regex unamed
     SPENT   119.182 ms in regex named
     SPENT    56.510 ms in regex miss
     SPENT    43.324 ms in prantlf.onig test
     SPENT    59.620 ms in prantlf.onig unnamed
     SPENT   102.476 ms in prantlf.onig named
     SPENT    31.473 ms in prantlf.onig miss
     SPENT    36.142 ms in prantlf.pcre test
     SPENT    45.399 ms in prantlf.pcre unnamed
     SPENT    42.996 ms in prantlf.pcre named
     SPENT     7.313 ms in prantlf.pcre miss
     SPENT    51.888 ms in prantlf.pcre2 test
     SPENT   116.189 ms in prantlf.pcre2 unnamed
     SPENT   254.120 ms in prantlf.pcre2 named
     SPENT    19.303 ms in prantlf.pcre2 miss
     SPENT    26.558 ms in prantlf.re2 test
     SPENT   133.159 ms in prantlf.re2 unnamed
     SPENT   126.388 ms in prantlf.re2 named
     SPENT    76.110 ms in prantlf.re2 miss
