module onig

pub enum ErrorResult {
	// normal = 0
	// value_is_not_set = 1
	// mismatch = -1
	no_support_config = -2
	// abort = -3
}

[noinit]
pub struct CompileError {
	Error
pub:
	msg  string
	code int
}

fn (e CompileError) msg() string {
	return e.msg
}

[noinit]
pub struct ExecuteError {
	Error
pub:
	msg  string
	code int
}

fn (e ExecuteError) msg() string {
	return e.msg
}
