#!/bin/sh
SHORT_OS_NAME="$(uname -s)"
if [ "${SHORT_OS_NAME:0:5}" == "Linux" ]; then
    # Compile with C++11 not C++17 standard - C++17 has error: ISO C++1z does not allow dynamic exception specifications
    export CPPFLAGS="${CPPFLAGS//-std=c++17/-std=c++11}"
    export CXXFLAGS="${CXXFLAGS//-std=c++17/-std=c++11}"
fi

make -j${CPU_COUNT}

install -d ${PREFIX}/lib

# filter libtbb.dylib ( or .so ), libtbbmalloc.dylib ( or .so )
cp `find . -name "libtbb*${SHLIB_EXT}*" | grep release` ${PREFIX}/lib

# fix symlinks
if test `uname` = "Linux"
then
  cd ${PREFIX}/lib
  ln -sf libtbb.so.2 libtbb.so
  ln -sf libtbbmalloc.so.2 libtbbmalloc.so
  ln -sf libtbbmalloc_proxy.so.2 libtbbmalloc_proxy.so
  cd -
fi

# includes
install -d ${PREFIX}/include
cp -r ./include/tbb ${PREFIX}/include

# simple test instead of "make test" to avoid timeout
${CXX} ${RECIPE_DIR}/tbb_example.c -I${PREFIX}/include -L${PREFIX}/lib -ltbb -o tbb_example -Wl,-rpath,$PREFIX/lib
./tbb_example
