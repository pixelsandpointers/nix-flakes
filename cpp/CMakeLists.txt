cmake_minimum_required(VERSION 3.24)
project(
  project
  VERSION 0.0.1
  DESCRIPTION "DESCRIPTION"
  LANGUAGES CXX C)

# Only set the cxx_standard if it is not set by someone else
if (NOT DEFINED CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 23)
  # strongly encouraged to enable this globally to avoid conflicts between
  # -Wpedantic being enabled and -std=c++20 and -std=gnu++20 for example
  # when compiling with PCH enabled
  set(CMAKE_CXX_EXTENSIONS OFF)
endif()

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# Required to make Nix pick up the stdlib for the LSP.
if(CMAKE_EXPORT_COMPILE_COMMANDS)
  set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES 
      ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES})
endif()

add_executable(${CMAKE_PROJECT_NAME})
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE ./include)
target_compile_features(${CMAKE_PROJECT_NAME} INTERFACE cxx_std_${CMAKE_CXX_STANDARD})
