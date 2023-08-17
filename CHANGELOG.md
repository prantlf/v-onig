# Changes

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
