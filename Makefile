SRC := $(wildcard *.v)
BIN := a.out

.PHONY: test
test: a.out
	./${BIN}

.PHONY: clean
clean:
	rm -f -- ${BIN}

.PHONY: wave
wave:
	/Applications/gtkwave.app/Contents/Resources/bin/gtkwave hello.vcd &

${BIN}: ${SRC}
	iverilog -o $@ ${SRC}
