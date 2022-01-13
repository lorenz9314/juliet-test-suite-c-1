TARGET=Juliet1.3

# Bins
MAKE=make
CPP=clang++-3.8
CFLAGS=-g
LFLAGS=-lpthread

# Support files
SUPPORT_PATH=testcasesupport/
INCLUDES=$(SUPPORT_PATH)
SUPPORT_C=$(addprefix $(SUPPORT_PATH),io.c std_thread.c)
SUPPORT_CPP=$(addprefix $(SUPPORT_PATH),main_linux.cpp)

# Remain compatibility
SUPPORT_SRCS = $(SUPPORT_C)
SUPPORT_SRCS += $(SUPPORT_CPP)
SUPPORT_OBJS = $(addsuffix .p,$(SUPPORT_SRCS))

SUPPORT_OBJS_C=$(SUPPORT_C:.c=.o)
SUPPORT_OBJS_CPP=$(SUPPORT_CPP:.cpp=.o)

# Partial files
MAKE_FILES=$(wildcard testcases/*/s*/Makefile) $(wildcard testcases/*/Makefile)
PARTIALS=$(patsubst %Makefile,%partial,$(MAKE_FILES))
INDIVIDUALS=$(patsubst %Makefile,%individuals,$(MAKE_FILES))

support: $(SUPPORT_OBJS_C) $(SUPPORT_OBJS_CPP)

$(TARGET): $(PARTIALS) $(SUPPORT_OBJS)
	$(CPP) $(CFLAGS) -I $(INCLUDES) -o $@ $(addsuffix .o,$(PARTIALS)) $(SUPPORT_OBJS) $(LFLAGS)

$(PARTIALS): 
	$(MAKE) -C $(dir $@) $(notdir $@).o

individuals: $(INDIVIDUALS)

$(INDIVIDUALS):
	$(MAKE) -C $(dir $@) $(notdir $@)

$(SUPPORT_OBJS): $(SUPPORT_SRCS)
	$(CPP) $(CFLAGS) -c -I $(INCLUDES) -o $@ $(@:.o=) $(LFLAGS)

$(SUPPORT_OBJS_C): $(SUPPORT_C)
	$(CPP) $(CFLAGS) $(LFLAGS) -c -I $(INCLUDES) -o $@ $(@:.o=.c)

$(SUPPORT_OBJS_CPP): $(SUPPORT_CPP)
	$(CPP) $(CFLAGS) $(LFLAGS) -c -I $(INCLUDES) -o $@ $(@:.o=.cpp)

.PHONY: clean

clean:
	git clean -xfd
