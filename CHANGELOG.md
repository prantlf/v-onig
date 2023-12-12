# Changes

## [0.3.2](https://github.com/prantlf/v-onig/compare/v0.3.1...v0.3.2) (2023-12-12)

### Bug Fixes

* Use flags to force static linking instead of config define ([0da2c22](https://github.com/prantlf/v-onig/commit/0da2c22f19cdde9d809455ee65d261da9465e870))

## [0.3.1](https://github.com/prantlf/v-onig/compare/v0.3.0...v0.3.1) (2023-12-11)

### Bug Fixes

* Adapt for V langage changes ([b50b6ed](https://github.com/prantlf/v-onig/commit/b50b6ed53796dcf5fcc912ac4fae5d000b32a5a9))

## [0.3.0](https://github.com/prantlf/v-onig/compare/v0.2.1...v0.3.0) (2023-10-15)

### Features

* Upgrade oniguruma to 6.9.9 ([aaddfba](https://github.com/prantlf/v-onig/commit/aaddfba83526524193a297c773250ef77693b884))

## [0.2.1](https://github.com/prantlf/v-onig/compare/v0.2.0...v0.2.1) (2023-09-17)

### Bug Fixes

* Support build on windows ([237e660](https://github.com/prantlf/v-onig/commit/237e660cda56da80c1fb2d8a8ab1e6c3e28cfc0c))

## [0.2.0](https://github.com/prantlf/v-onig/compare/v0.1.1...v0.2.0) (2023-09-09)

### Features

* Add PCRE-compatible functions ([d4ebbbc](https://github.com/prantlf/v-onig/commit/d4ebbbccbef4ee8a87fded20fb6dde5b5440bbcb))

## [0.1.1](https://github.com/prantlf/v-onig/compare/v0.1.0...v0.1.1) (2023-08-17)

### Bug Fixes

* Do not pass opt_replace_groups to onig_search ([6f7c286](https://github.com/prantlf/v-onig/commit/6f7c286e3aedc36defefaf80dd5ad8de08929fa7))

## [0.1.0](https://github.com/prantlf/v-onig/compare/v0.0.2...v0.1.0) (2023-08-17)

### Features

* Return NoMatch or NoReplace if replace methods did not do anything ([70fe789](https://github.com/prantlf/v-onig/commit/70fe7899b2c3624200283a113e5e5e6973147953))

### BREAKING CHANGES

If you expected that `replace` and `replace_first`
always returned a string, either the same one or a new one
with some parts replaced, you will need to modify your code. You
will need to check if the returned error is NoMatch or NoReplace
and use the original string in that case:
```go
if new_string := re.replace(old_string, with, onig.opt_none) {
  // use new_string
} else {
  if err is NoMatch || err is NoReplace {
    // use old_string
  } else {
    return err
  }
}
```

## [0.0.2](https://github.com/prantlf/v-onig/compare/v0.0.1...v0.0.2) (2023-08-16)

### Bug Fixes

* Avoid including the internbal header ([43f30fc](https://github.com/prantlf/v-onig/commit/43f30fca6caf189982b06030040aa7ade5550682))

## 0.0.1 (2023-08-15)

Initial release.
