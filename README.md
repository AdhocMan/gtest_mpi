# GTest MPI
This project provides an extension to the Google Test framework, to allow testing of MPI enabled applications. 
The implementation includes a custom listener, with which all test failure messages are collected on the root process and the output includes the rank index for each failure.


## Requirements
- GoogleTest version 1.12.0 and later
- MPI
- Compiler with C++ 14 support.

## Limitations
- Each test must include a guard macro, which enables exchange of test results
- All ranks must execute all tests in the same order. Within a test, the executed assertions may differ. If a test should run only on a subset of ranks, the excluded ranks must enter the test, but may exit immediately.
- Logging features of Google Test are not supported

## Example
```
#include <mpi.h>

#include "gtest/gtest.h"
#include "gtest_mpi/gtest_mpi.hpp"

int main(int argc, char* argv[]) {
  // Initialize MPI before any call to gtest_mpi
  int provided;
  MPI_Init_thread(&argc, &argv, MPI_THREAD_FUNNELED, &provided);

  // Initialize including registering custom listener. Will call InitGoogleTest internally.
  gtest_mpi::InitGoogleTestMPI(&argc, argv);

  auto status = RUN_ALL_TESTS();

  MPI_Finalize();

  return status;
}
```

```
#include "gtest/gtest.h"
#include "gtest_mpi/gtest_mpi.hpp"

TEST(TestSuiteName, TestName) {
  // Guard must be present in each test
  GTEST_MPI_GUARD

  // Generate failure message
  EXPECT_DOUBLE_EQ(1.0, 2.0);
}
```
