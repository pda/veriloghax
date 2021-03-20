SRC := $(wildcard *.v)
BIN := a.out

.PHONY: test
test: a.out
	./${BIN}

.PHONY: clean
clean:
	rm -f -- ${BIN}

${BIN}: ${SRC}
	iverilog -o $@ ${SRC}
