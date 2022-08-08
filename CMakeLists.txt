cmake_minimum_required(VERSION 3.4...3.18)
project(cmake_example)

find_package(Eigen3 REQUIRED NO_MODULE)
message(STATUS "Found Eigen3 version ${Eigen3_VERSION}")

find_package(Foo REQUIRED)
message(STATUS "Found Foo version ${Foo_VERSION}")

add_subdirectory(pybind11)
pybind11_add_module(cmake_example src/main.cpp)

target_include_directories(cmake_example PRIVATE ${EIGEN3_INCLUDE_DIRS})

# EXAMPLE_VERSION_INFO is defined by setup.py and passed into the C++ code as a
# define (VERSION_INFO) here.
target_compile_definitions(cmake_example
                           PRIVATE VERSION_INFO=${EXAMPLE_VERSION_INFO} ${EIGEN3_DEFINITIONS})

target_link_libraries(cmake_example PRIVATE Foo::foo)
