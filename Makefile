SERVER := server
CLIENT := client

# **************************************************************************** #

SRC_DIR := src

SERVER_SRC := server.c

SERVER_OBJ := $(SERVER_SRC:.c=.o)
SERVER_DEP := $(SERVER_SRC:.c=.d)

CLIENT_SRC := client.c

CLIENT_OBJ := $(CLIENT_SRC:.c=.o)
CLIENT_DEP := $(CLIENT_SRC:.c=.d)

# **************************************************************************** #

FT_DIR := libft
FT := libft.a

# **************************************************************************** #

INC_DIRS := include \
            $(FT_DIR)/include \

# **************************************************************************** #

OBJ_DIR := obj

SERVER_OBJ := $(addprefix $(OBJ_DIR)/, $(SERVER_OBJ))
SERVER_DEP := $(addprefix $(OBJ_DIR)/, $(SERVER_DEP))

CLIENT_OBJ := $(addprefix $(OBJ_DIR)/, $(CLIENT_OBJ))
CLIENT_DEP := $(addprefix $(OBJ_DIR)/, $(CLIENT_DEP))

# **************************************************************************** #

UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S), Darwin)
    CC := clang
endif

ifeq ($(UNAME_S), Linux)
    CC := gcc
endif

# **************************************************************************** #

CFLAGS += -Wall -Wextra -Werror \
          $(addprefix -I , $(INC_DIRS)) \
          -MMD \
          -O2 -march=native -ftree-vectorize -pipe

LDFLAGS += -L $(FT_DIR)

LDLIBS += -lft

# **************************************************************************** #

RESET   := \033[0;0m
RED     := \033[0;31m
GREEN   := \033[0;32m
YELLOW  := \033[0;33m
BLUE    := \033[0;34m
MAGENTA := \033[0;35m
CYAN    := \033[0;36m
WHITE   := \033[0;37m

# **************************************************************************** #

.PHONY: all bonus clean fclean re

# **************************************************************************** #

all:
	@printf "$(CYAN)>>> Making $(FT_DIR) <<<\n$(RESET)"
	@$(MAKE) -C $(FT_DIR)
	@printf "$(CYAN)>>> Making $(SERVER) <<<\n$(RESET)"
	@$(MAKE) $(SERVER)
	@printf "$(CYAN)>>> Making $(CLIENT) <<<\n$(RESET)"
	@$(MAKE) $(CLIENT)

bonus: all

$(FT_DIR)/$(FT):
	@$(MAKE) -C $(FT_DIR)

$(SERVER): $(SERVER_OBJ) $(FT_DIR)/$(FT)
	@printf "$(GREEN)"
	$(CC) $(LDFLAGS) $(LDLIBS) $(SERVER_OBJ) -o $@
	@printf "$(RESET)"

$(CLIENT): $(CLIENT_OBJ) $(FT_DIR)/$(FT)
	@printf "$(GREEN)"
	$(CC) $(LDFLAGS) $(LDLIBS) $(CLIENT_OBJ) -o $@
	@printf "$(RESET)"

$(OBJ_DIR):
	@mkdir -p $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	@printf "$(MAGENTA)"
	$(CC) $(CFLAGS) -c $< -o $@
	@printf "$(RESET)"

-include $(SERVER_DEP)
-include $(CLIENT_DEP)

clean:
	@printf "$(CYAN)>>> Cleaning $(FT_DIR) <<<\n$(RESET)"
	@$(MAKE) -C $(FT_DIR) clean
	@printf "$(CYAN)>>> Cleaning $(SERVER) and $(CLIENT) <<<\n$(RESET)"
	@printf "$(RED)"
	rm -rf $(OBJ_DIR)
	@printf "$(RESET)"

fclean: clean
	@printf "$(CYAN)>>> Purging $(FT_DIR) <<<\n$(RESET)"
	@$(MAKE) -C $(FT_DIR) fclean
	@printf "$(CYAN)>>> Purging $(SERVER) and $(CLIENT) <<<\n$(RESET)"
	@printf "$(RED)"
	rm -f $(SERVER) $(CLIENT)
	@printf "$(RESET)"

re: fclean all
