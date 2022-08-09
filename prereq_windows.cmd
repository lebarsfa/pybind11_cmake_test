
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
choco upgrade -y -r --no-progress wget
choco upgrade -y -r --no-progress eigen --version=3.4.0
choco install -y -r --no-progress chocolatey-core.extension
wget https://www.ensta-bretagne.fr/packages/choco/libopencv-dev.4.5.4.nupkg --no-check-certificate -nv
choco source add -n=current-directory -s .
choco install -y -r --no-progress -m -f --ignore-dependencies --ignore-checksum libopencv-dev --version=4.5.4 --params "'/url:https://github.com/lebarsfa/Packages/releases/download/libopencv-dev.4.5.4.20220805/libopencv-dev.4.5.4_%ARCH%_%RUNTIME%_lib_Release.exe'"
del /f /q libopencv-dev.4.5.4.nupkg

git clone https://github.com/pablospe/cmake-example-library.git
cd cmake-example-library
mkdir build
cd build
if %PYTHON_ARCH%==32 (
	cmake %CMAKE_PARAMS% -D CMAKE_INSTALL_PREFIX="C:\Program Files (x86)" ..
)
if %PYTHON_ARCH%==64 (
	cmake %CMAKE_PARAMS% -D CMAKE_INSTALL_PREFIX="C:\Program Files" ..
)
cmake --build . --config Release --target install
cd ..\..
rd /s /q cmake-example-library
