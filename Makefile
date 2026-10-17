# Компилятор и флаги
CXX      := g++
CXXFLAGS := -std=c++26 -Wall -Wextra -Iinclude -MMD -MP

# Директории (в Makefile используем прямые слеши — make их понимает,
# а команды cmd получают уже преобразованные пути через $(subst))
SRC_DIR   := src
BUILD_DIR := build
TARGET    := $(BUILD_DIR)/app.exe

# Автоматический поиск всех .cpp в src/
SRCS := $(wildcard $(SRC_DIR)/*.cpp)
OBJS := $(patsubst $(SRC_DIR)/%.cpp, $(BUILD_DIR)/%.o, $(SRCS))
DEPS := $(OBJS:.o=.d)

# Утилита для создания каталога, совместимая с cmd
# $(call MKDIR_DIR,путь) -> "if not exist "путь" mkdir "путь""
define MKDIR_DIR
@if not exist "$(subst /,\,$(1))" mkdir "$(subst /,\,$(1))"
endef

# Основная цель
all: $(TARGET)

# Линковка
$(TARGET): $(OBJS)
	$(call MKDIR_DIR,$(BUILD_DIR))
	$(CXX) $(OBJS) -o $@

# Компиляция каждого .cpp в .o внутри build/
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(call MKDIR_DIR,$(BUILD_DIR))
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Очистка
clean:
	@if exist "$(subst /,\,$(BUILD_DIR))" rmdir /S /Q "$(subst /,\,$(BUILD_DIR))"

# Подключение сгенерированных .d файлов
-include $(DEPS)

.PHONY: all clean
