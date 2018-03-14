
@rem See https://github.com/wjakob/tbb
cp "%RECIPE_DIR%\CMakeLists.txt" .
if errorlevel 1 exit 1
cp "%RECIPE_DIR%\version_string.ver.in" build
if errorlevel 1 exit 1

mkdir buildw && cd buildw

set CMAKE_CONFIG="Release"

cmake -LAH -G"%CMAKE_GENERATOR%"                             ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%"                ^
  -DCMAKE_BUILD_TYPE="%CMAKE_CONFIG%"                      ^
  -DTBB_CI_BUILD=ON                                        ^
  ..
if errorlevel 1 exit 1

cmake --build . --config %CMAKE_CONFIG% --target install
if errorlevel 1 exit 1


ctest -C %CMAKE_CONFIG% --output-on-failure --timeout 500
if errorlevel 1 exit 1

