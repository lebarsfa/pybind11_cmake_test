#!/bin/bash

export
python -V -V

if [ $AUDITWHEEL_ARCH = "x86_64" ]; then
 echo x86_64
elif [ $AUDITWHEEL_ARCH = "i686" ]; then
 echo i686
elif [ $AUDITWHEEL_ARCH = "aarch64" ]; then
 echo aarch64
fi

yum -y install wget flex bison

wget https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.zip -nv
unzip -q -o eigen-3.4.0.zip
cd eigen-3.4.0
mkdir build
cd build
cmake ..
cmake --build . --config Release --target install
cd ../..
rm -Rf eigen-3.4.0.zip
rm -Rf eigen-3.4.0

git clone -b actions https://github.com/lebarsfa/ibex-lib.git
cd ibex-lib
mkdir build
cd build
if [ $AUDITWHEEL_ARCH = "x86_64" ] || [ $AUDITWHEEL_ARCH = "i686" ]; then
 cmake -E env CXXFLAGS="-fPIC" CFLAGS="-fPIC" cmake ..
else
 cmake -E env CXXFLAGS="-fPIC" CFLAGS="-fPIC" cmake -D INTERVAL_LIB=filib ..
fi
cmake --build . --config Release --target install
cd ../..
rm -Rf ibex-lib
