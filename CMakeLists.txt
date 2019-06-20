cmake_minimum_required(VERSION 3.1.3 FATAL_ERROR)
project(gtest_mpi CXX)

add_library(gtest_mpi INTERFACE)

target_include_directories(gtest_mpi INTERFACE include)

if(NOT (${CMAKE_VERSION} VERSION_LESS "3.8.2"))
  target_compile_features(gtest_mpi INTERFACE cxx_std_11)
endif()
