ERLC ?= erlc
ERL ?= erl
EBIN := ebin
SRC := $(wildcard src/*.erl)

.PHONY: all compile test demo clean

all: test

compile:
	mkdir -p $(EBIN)
	$(ERLC) -Wall +debug_info -o $(EBIN) $(SRC)
	cp src/context_runtime.app.src $(EBIN)/context_runtime.app

test: compile
	$(ERL) -pa $(EBIN) -noshell -eval 'case ctx_tests:run() of ok -> halt(0); _ -> halt(1) end.'

demo: compile
	$(ERL) -pa $(EBIN) -noshell -eval 'ctx_demo:run(), halt(0).'

clean:
	rm -rf $(EBIN) _demo_state
