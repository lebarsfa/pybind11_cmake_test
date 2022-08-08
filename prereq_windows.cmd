
set
python -V -V

rem Should depend on Python version...
set CMAKE_GENERATOR="Visual Studio 17" -T v141
set RUNTIME=vc15
if %PYTHON_ARCH%==32 (
	set ARCH=x86
	set CHOCO_FLAGS=--x86
	set CMAKE_PARAMS=-G %CMAKE_GENERATOR% -A Win32
)
if %PYTHON_ARCH%==64 (
	set ARCH=x64
	set CMAKE_PARAMS=-G %CMAKE_GENERATOR% -A x64
)

rem Some packages should work directly both in 32 and 64 bit, otherwise "--force %CHOCO_FLAGS%" should be added to the choco commands...
choco upgrade -y -r --no-progress wget winflexbison patch
choco upgrade -y -r --no-progress eigen --version=3.4.0

git clone -b actions https://github.com/lebarsfa/ibex-lib.git
cd ibex-lib
mkdir build
cd build
if %PYTHON_ARCH%==32 (
	cmake -E env CXXFLAGS=" /wd4267 /wd4244 /wd4305 /wd4996" CFLAGS=" /wd4267 /wd4244 /wd4305 /wd4996" cmake %CMAKE_PARAMS% -D CMAKE_INSTALL_PREFIX="C:\Program Files (x86)" ..
)
if %PYTHON_ARCH%==64 (
	cmake -E env CXXFLAGS=" /wd4267 /wd4244 /wd4305 /wd4996" CFLAGS=" /wd4267 /wd4244 /wd4305 /wd4996" cmake %CMAKE_PARAMS% -D CMAKE_INSTALL_PREFIX="C:\Program Files" ..
)
cmake --build . --config Release --target install
cd ..\..
rd /s /q ibex-lib
