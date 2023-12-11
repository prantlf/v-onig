all: check test

check:
	v fmt -w .
	v vet .

test:
	v -enable-globals -use-os-system-to-run test .

clean:
	rm -rf src/*_test src/*.dSYM
