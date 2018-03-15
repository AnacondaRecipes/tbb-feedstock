
@rem See https://github.com/wjakob/tbb
copy "%RECIPE_DIR%\CMakeLists.txt" .
if errorlevel 1 exit 1
copy "%RECIPE_DIR%\version_string.ver.in" build
if errorlevel 1 exit 1

mkdir buildw && cd buildw

set CMAKE_CONFIG="Release"

@rem Not using %CMAKE_GENERATOR% here intentionally, as it causes CMake to use
@rem C:/Program Files (x86)/Microsoft Visual Studio 9.0/VC/bin/x86_amd64/ml64.exe
@rem instead of C:/Program Files (x86)/Microsoft Visual Studio 9.0/VC/bin/amd64/ml64.exe
@rem and the former chokes on asm files meant for 64 bit code.
cmake -LAH -G"NMake Makefiles"                             ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%"                ^
  -DCMAKE_BUILD_TYPE="%CMAKE_CONFIG%"                      ^
  -DTBB_CI_BUILD=ON                                        ^
  ..
if errorlevel 1 exit 1

cmake --build . --config %CMAKE_CONFIG% --target install
if errorlevel 1 exit 1


ctest -C %CMAKE_CONFIG% --output-on-failure --timeout 500
if errorlevel 1 exit 1

