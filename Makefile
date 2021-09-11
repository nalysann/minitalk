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

SERVER_SRC_BONUS := server_bonus.c

SERVER_OBJ_BONUS := $(SERVER_SRC_BONUS:.c=.o)
SERVER_DEP_BONUS := $(SERVER_SRC_BONUS:.c=.d)

CLIENT_SRC_BONUS := client_bonus.c

CLIENT_OBJ_BONUS := $(CLIENT_SRC_BONUS:.c=.o)
CLIENT_DEP_BONUS := $(CLIENT_SRC_BONUS:.c=.d)

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

SERVER_BONUS := $(addprefix $(OBJ_DIR)/, $(SERVER))
SERVER_OBJ_BONUS := $(addprefix $(OBJ_DIR)/, $(SERVER_OBJ_BONUS))
SERVER_DEP_BONUS := $(addprefix $(OBJ_DIR)/, $(SERVER_DEP_BONUS))

CLIENT_BONUS := $(addprefix $(OBJ_DIR)/, $(CLIENT))
CLIENT_OBJ_BONUS := $(addprefix $(OBJ_DIR)/, $(CLIENT_OBJ_BONUS))
CLIENT_DEP_BONUS := $(addprefix $(OBJ_DIR)/, $(CLIENT_DEP_BONUS))

# **************************************************************************** #

CC := clang

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

bonus:
	@printf "$(CYAN)>>> Making $(FT_DIR) <<<\n$(RESET)"
	@$(MAKE) -C $(FT_DIR)
	@printf "$(CYAN)>>> Making $(SERVER) <<<\n$(RESET)"
	@$(MAKE) $(SERVER_BONUS)
	@cp $(SERVER_BONUS) $(SERVER)
	@printf "$(CYAN)>>> Making $(CLIENT) <<<\n$(RESET)"
	@$(MAKE) $(CLIENT_BONUS)
	@cp $(CLIENT_BONUS) $(CLIENT)

$(FT_DIR)/$(FT):
	@$(MAKE) -C $(FT_DIR)

$(SERVER): $(SERVER_OBJ) $(FT_DIR)/$(FT)
	@printf "$(GREEN)"
	$(CC) $(SERVER_OBJ) -o $@ $(LDFLAGS) $(LDLIBS)
	@printf "$(RESET)"

$(CLIENT): $(CLIENT_OBJ) $(FT_DIR)/$(FT)
	@printf "$(GREEN)"
	$(CC) $(CLIENT_OBJ) -o $@ $(LDFLAGS) $(LDLIBS)
	@printf "$(RESET)"

$(SERVER_BONUS): $(SERVER_OBJ_BONUS) $(FT_DIR)/$(FT)
	@printf "$(GREEN)"
	$(CC) $(SERVER_OBJ_BONUS) -o $@ $(LDFLAGS) $(LDLIBS)
	@printf "$(RESET)"

$(CLIENT_BONUS): $(CLIENT_OBJ_BONUS) $(FT_DIR)/$(FT)
	@printf "$(GREEN)"
	$(CC) $(CLIENT_OBJ_BONUS) -o $@ $(LDFLAGS) $(LDLIBS)
	@printf "$(RESET)"

$(OBJ_DIR):
	@mkdir -p $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	@printf "$(MAGENTA)"
	$(CC) $(CFLAGS) -c $< -o $@
	@printf "$(RESET)"

-include $(SERVER_DEP)
-include $(CLIENT_DEP)

-include $(SERVER_DEP_BONUS)
-include $(CLIENT_DEP_BONUS)

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
