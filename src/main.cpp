#include <pybind11/pybind11.h>

#include <Eigen/Dense>
#include <opencv2/core/core.hpp>
#include <foo/foo.h>
#include <iostream>

#define STRINGIFY(x) #x
#define MACRO_STRINGIFY(x) STRINGIFY(x)

int add(int i, int j) {
	Eigen::MatrixXd m(i, j);
	std::cout << "My first matrix:" << m << std::endl;
	cv::Mat M(2, 2, CV_8UC3, cv::Scalar(0, 0, 255));
	std::cout << "cv::Mat M = " << std::endl << " " << M << std::endl << std::endl;
	foo_print_version();
	return m.rows() + m.cols();
}

namespace py = pybind11;

PYBIND11_MODULE(cmake_example, m) {
    m.doc() = R"pbdoc(
        Pybind11 example plugin
        -----------------------

        .. currentmodule:: cmake_example

        .. autosummary::
           :toctree: _generate

           add
           subtract
    )pbdoc";

    m.def("add", &add, R"pbdoc(
        Add two numbers

        Some other explanation about the add function.
    )pbdoc");

    m.def("subtract", [](int i, int j) { return i - j; }, R"pbdoc(
        Subtract two numbers

        Some other explanation about the subtract function.
    )pbdoc");

#ifdef VERSION_INFO
    m.attr("__version__") = MACRO_STRINGIFY(VERSION_INFO);
#else
    m.attr("__version__") = "dev";
#endif
}
