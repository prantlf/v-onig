module onig

fn test_compile() {
	err := CompileError{
		msg: 'failed'
		code: int(ErrorResult.no_support_config)
	}
	assert err.msg() == 'failed'
}

fn test_execute() {
	err := ExecuteError{
		msg: 'failed'
		code: int(ErrorResult.no_support_config)
	}
	assert err.msg() == 'failed'
}
