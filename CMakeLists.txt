cmake_minimum_required(VERSION 3.12 FATAL_ERROR)
project(gtest_mpi LANGUAGES CXX VERSION 2.0.0)

include(GNUInstallDirs)

option(GTEST_MPI_EXTERNAL_GTEST "Look for installed GTest" ON)
option(GTEST_MPI_EXTERNAL_MPI "Look for installed MPI" ON)

if(GTEST_MPI_EXTERNAL_MPI)
  find_package(MPI MODULE COMPONENTS CXX REQUIRED)
endif()

if(GTEST_MPI_EXTERNAL_GTEST)
  find_package(GTest CONFIG REQUIRED)
endif()

add_library(gtest_mpi src/gtest_mpi.cpp)
target_compile_features(gtest_mpi PUBLIC cxx_std_14)
target_link_libraries(gtest_mpi PUBLIC MPI::MPI_CXX GTest::gtest)
target_include_directories(gtest_mpi PUBLIC $<INSTALL_INTERFACE:include>) # for install(EXPORT ...)
target_include_directories(gtest_mpi PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>) # for export(...)


set_property(TARGET gtest_mpi PROPERTY VERSION ${CMAKE_PROJECT_VERSION})
set_property(TARGET gtest_mpi PROPERTY SOVERSION ${CMAKE_PROJECT_VERSION_MAJOR})

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
	"${PROJECT_BINARY_DIR}/gtest_mpi-version.cmake"
	COMPATIBILITY AnyNewerVersion
)

export(TARGETS gtest_mpi NAMESPACE gtest_mpi:: FILE ${PROJECT_BINARY_DIR}/gtest_mpi-targets.cmake)
configure_file(${PROJECT_SOURCE_DIR}/cmake/gtest_mpi-config.cmake
	"${PROJECT_BINARY_DIR}/gtest_mpi-config.cmake"
	@ONLY
)

install(TARGETS gtest_mpi DESTINATION ${CMAKE_INSTALL_LIBDIR} EXPORT gtest_mpi-targets)
install(DIRECTORY ${PROJECT_SOURCE_DIR}/include/gtest_mpi DESTINATION ${CMAKE_INSTALL_INCLUDEDIR} FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp")
install(EXPORT gtest_mpi-targets NAMESPACE gtest_mpi:: DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/gtest_mpi FILE gtest_mpi-targets.cmake)
install(
  FILES
    "${PROJECT_BINARY_DIR}/gtest_mpi-config.cmake"
    "${PROJECT_BINARY_DIR}/gtest_mpi-version.cmake"
  DESTINATION
      ${CMAKE_INSTALL_LIBDIR}/cmake/gtest_mpi
)

add_library(gtest_mpi::gtest_mpi ALIAS gtest_mpi)
