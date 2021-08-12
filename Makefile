SRC := hello_tb.v
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
	iverilog -Wall -o $@ ${SRC}
