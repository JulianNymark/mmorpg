export GOPATH := $(CURDIR)/go
DEPS_SHORT := lib/pq
DEPS := $(addprefix github.com/, $(DEPS_SHORT))
PROGRAM := server

all: server

$(PROGRAM): $(DEPS)
	go build -o $@

$(DEPS): go/src/$(DEPS)

go/src/%:
	go get -d $*

clean:
	$(RM)

.PHONY: all clean $(DEPS)
