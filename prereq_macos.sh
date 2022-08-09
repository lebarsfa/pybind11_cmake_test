#!/bin/bash

export
python -V -V

# No support for universal apps...

if [ $_PYTHON_HOST_PLATFORM = "macosx-10.9-x86_64" ]; then
 brew install eigen
 brew install opencv
fi
if [ $_PYTHON_HOST_PLATFORM = "macosx-11.0-arm64" ]; then
 # https://github.com/Homebrew/discussions/discussions/2843#discussioncomment-2243610
 mkdir -p ~/arm-target/bin
 mkdir -p ~/arm-target/brew-cache
 export PATH="$HOME/arm-target/bin:$PATH"

 cd ~/arm-target
 mkdir arm-homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C arm-homebrew
 ln -s ~/arm-target/arm-homebrew/bin/brew ~/arm-target/bin/arm-brew

 export HOMEBREW_CACHE=~/arm-target/brew-cache
 export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1
 # List desired packages dependencies and install them, except pkg-config, cmake, etc. which should stay native
 arm-brew fetch --deps --bottle-tag=arm64_big_sur eigen opencv |\
  grep -E "(Downloaded to:|Already downloaded:)" |\
  grep -v pkg-config | grep -v cmake | grep -v git | awk '{ print $3 }' |\
  xargs -n 1 arm-brew install --ignore-dependencies --force-bottle
fi
cd ~

git clone https://github.com/pablospe/cmake-example-library.git
cd cmake-example-library
mkdir build
cd build
if [ $_PYTHON_HOST_PLATFORM = "macosx-10.9-x86_64" ]; then
 cmake -E env CXXFLAGS="-fPIC" CFLAGS="-fPIC" cmake ..
fi
if [ $_PYTHON_HOST_PLATFORM = "macosx-11.0-arm64" ]; then
 cmake -E env CXXFLAGS="-fPIC" CFLAGS="-fPIC" cmake -D CMAKE_SYSTEM_NAME=Darwin -D CMAKE_OSX_ARCHITECTURES=arm64 -D CMAKE_INSTALL_PREFIX=~/arm-target ..
fi
cmake --build . --config Release --target install
cd ../..
rm -Rf cmake-example-library
