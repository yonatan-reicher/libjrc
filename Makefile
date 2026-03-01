# --- Project Settings ---------------------------------------------------------
NAME         := jrc
VERSION      := 0.0.1

# Directories
SRC_DIR      := src
# We put the header along with the source files
INC_DIR      := src
OBJ_DIR      := obj
LIB_DIR      := lib
PREFIX       ?= /usr/local
INSTALL_LIB  := $(PREFIX)/lib
INSTALL_INC  := $(PREFIX)/include/$(NAME)

# Output
TARGET       := $(LIB_DIR)/lib$(NAME).a

# --- Toolchain ----------------------------------------------------------------
CC           := gcc
AR           := ar
ARFLAGS      := rcs
CFLAGS       := -Wall -Wextra -Wpedantic -std=c11 -O3 -I$(INC_DIR)
DBGFLAGS     := -g -O0 -DDEBUG

# --- Sources & Objects --------------------------------------------------------
SRCS         := $(wildcard $(SRC_DIR)/*.c)
OBJS         := $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRCS))

# --- Targets ------------------------------------------------------------------
.PHONY: all debug clean install uninstall help

all: $(TARGET)

## Build the static library
$(TARGET): $(OBJS) | $(LIB_DIR)
	$(AR) $(ARFLAGS) $@ $^
	@echo "Built static library: $@"

## Compile each source file into an object file
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

## Debug build (no optimisation, with symbols)
debug: CFLAGS += $(DBGFLAGS)
debug: clean $(TARGET)

## Create output directories if they don't exist
$(OBJ_DIR) $(LIB_DIR):
	mkdir -p $@

# --- Install & Uninstall ------------------------------------------------------
install: all
	install -d $(INSTALL_LIB) $(INSTALL_INC)
	install -m 0644 $(TARGET) $(INSTALL_LIB)/
	install -m 0644 $(INC_DIR)/*.h $(INSTALL_INC)/
	@echo "Installed to $(PREFIX)"

uninstall:
	$(RM) $(INSTALL_LIB)/lib$(NAME).a
	$(RM) -r $(INSTALL_INC)
	@echo "Uninstalled from $(PREFIX)"

# --- Utility ------------------------------------------------------------------
clean:
	$(RM) -r $(OBJ_DIR) $(LIB_DIR)
	@echo "Cleaned build artifacts"

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "  all       Build the static library (default)"
	@echo "  debug     Build with debug symbols and no optimisation"
	@echo "  install   Install library and headers to PREFIX (default: /usr/local)"
	@echo "  uninstall Remove installed files"
	@echo "  clean     Remove all build artifacts"
	@echo "  help      Show this message"
