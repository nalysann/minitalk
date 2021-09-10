cmake_minimum_required(VERSION 3.20)
project(minitalk C)

set(CMAKE_C_STANDARD 11)

include_directories(include)
include_directories(libft/include)

add_subdirectory(libft)

add_executable(server
        include/minitalk.h
        src/server.c)

target_link_libraries(server ft)

add_executable(client
        include/minitalk.h
        src/client.c)

target_link_libraries(client ft)
