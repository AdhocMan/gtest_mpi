include(CMakeFindDependencyMacro)

find_dependency(MPI COMPONENTS CXX)
find_dependency(GTest CONFIG)

if(NOT DEFINED gtest_mpi_FOUND OR gtest_mpi_FOUND)
	# add version of package
	include("${CMAKE_CURRENT_LIST_DIR}/gtest_mpi-version.cmake")

	# add library target
	include("${CMAKE_CURRENT_LIST_DIR}/gtest_mpi-targets.cmake")
endif()
