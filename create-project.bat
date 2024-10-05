@echo off

@REM Get the project name from the command line argument
set PROJECT_NAME=%1
if "%PROJECT_NAME%"=="" (
    set PROJECT_NAME=project
)

@REM Get the project type from the command line argument
set PROJECT_TYPE=%2
if "%PROJECT_TYPE%"=="" (
    set PROJECT_TYPE=OFF
) else (
    set PROJECT_TYPE=ON
)

@REM Create directory structure
mkdir .\test
mkdir .\include
mkdir .\include\%PROJECT_NAME%
mkdir .\include\%PROJECT_NAME%\hello
mkdir .\src
mkdir .\src\hello
mkdir .\data

@REM Create a sample hello.h file
(
echo #pragma once
echo.
echo #include ^<string^>
echo.
echo std::string hello^(^);
) > .\include\%PROJECT_NAME%\hello\hello.h

@REM Create a sample hello.cpp file
(
echo #include ^<%PROJECT_NAME%/hello/hello.h^>
echo.
echo std::string hello^(^)
echo {
echo     return "Hello, CMake World!";
echo }
) > .\src\hello\hello.cpp

@REM Create a sample main.cpp file
(
echo #include ^<iostream^>
echo #include ^<%PROJECT_NAME%/hello/hello.h^>
echo.
echo int main^(^)
echo {
echo     std::cout ^<^< hello^(^) ^<^< std::endl;
echo     return 0;
echo }
) > .\src\main.cpp

@REM Create a sample test.cpp file
(
echo #include ^<gtest/gtest.h^>
echo #include ^<%PROJECT_NAME%/hello/hello.h^>
echo.
echo TEST^(HelloTest, SayHello^)
echo {
echo     EXPECT_EQ^(std::string^("Hello, CMake World!"^), hello^(^)^);
echo }
) > .\test\test.cpp

@REM Create the CMakelists.txt file
(
echo cmake_minimum_required^(VERSION 3.27^)
echo.
echo set^(CMAKE_CXX_STANDARD 17^)
echo set^(CMAKE_CXX_STANDARD_REQUIRED True^)
echo.
echo project^(main VERSION 1.0.0 LANGUAGES CXX^)
echo.
echo add_definitions^(-DTEST_DATA_PATH="${CMAKE_SOURCE_DIR}/data"^)
echo.
echo add_subdirectory^(src^)
echo add_subdirectory^(test^)
) > .\CMakelists.txt

@REM Create src CMakelists.txt file
(
echo cmake_minimum_required^(VERSION 3.27^)
echo.
echo set^(CMAKE_CXX_STANDARD 17^)
echo set^(CMAKE_CXX_STANDARD_REQUIRED True^)
echo.
echo project^(%PROJECT_NAME% VERSION 1.0.0 LANGUAGES CXX^)
echo.
echo set^(SOURCE^)
echo set^(SOURCE_DIR "hello"^)
echo.
echo foreach^(dir ${SOURCE_DIR}^)
echo   file^(GLOB SRC CONFIGURE_DEPENDS ${dir}/*.cpp^)
echo   file^(GLOB INC CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/include/${PROJECT_NAME}/${dir}/*.h^)
echo.
echo   source_group^(${dir} FILES ${SRC} ${INC}^)
echo   set^(SOURCE ${SOURCE} ${SRC} ${INC}^)
echo endforeach^(^)
echo.
echo add_executable^(${PROJECT_NAME} main.cpp ${SOURCE}^)
echo.
echo target_include_directories^(${PROJECT_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/include^)
echo.
echo set_target_properties^(${PROJECT_NAME} PROPERTIES WIN32_EXECUTABLE %PROJECT_TYPE%^)
echo.
echo set^(BINARY_DIR ${PROJECT_BINARY_DIR}^)
echo.
echo set^(OUTPUT_DIR
echo     "$<$<CONFIG:Debug>:"
echo     "${BINARY_DIR}/Debug"
echo     ">"
echo     "$<$<CONFIG:Release>:"
echo     "${BINARY_DIR}/Release"
echo     ">"
echo     "$<$<CONFIG:RelWithDebInfo>:"
echo     "${BINARY_DIR}/RelWithDebInfo"
echo     ">"^)
echo string^(REPLACE ";" " " OUTPUT_DIR ${OUTPUT_DIR}^)
echo.
echo # file^(GLOB DEPS_DLL CONFIGURE_DEPENDS *.dll^)
echo.
echo # add_custom_command^(
echo #   TARGET ${PROJECT_NAME}
echo #   POST_BUILD
echo #   COMMAND ${CMAKE_COMMAND} -E copy ${DEPS_DLL} ${OUTPUT_DIR}^)
) > .\src\CMakelists.txt

@REM Create test CMakelists.txt file
(
echo cmake_minimum_required^(VERSION 3.27^)
echo.
echo set^(CMAKE_CXX_STANDARD 17^)
echo set^(CMAKE_CXX_STANDARD_REQUIRED ON^)
echo.
echo project^(test_%PROJECT_NAME% VERSION 1.0.0 LANGUAGES CXX^)
echo.
echo add_definitions^(-DGTEST_LINKED_AS_SHARED_LIBRARY^)
echo.
echo enable_testing^(^)
echo.
echo file^(GLOB_RECURSE TEST_SRC CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/test/*.cpp^)
echo source_group^(test FILES ${TEST_SRC}^)
echo.
echo set^(SOURCE^)
echo set^(SOURCE_DIR "hello"^)
echo.
echo foreach^(dir ${SOURCE_DIR}^)
echo   file^(GLOB SRC CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/src/${dir}/*.cpp^)
echo   file^(GLOB INC CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/include/${PROJECT_NAME}/${dir}/*.h^)
echo.
echo   set^(SOURCE ${SOURCE} ${SRC} ${INC}^)
echo endforeach^(^)
echo.
echo add_executable^(${PROJECT_NAME} ${SOURCE} ${TEST_SRC}^)
echo.
echo target_include_directories^(${PROJECT_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/include^)
echo.
echo find_package^(GTest REQUIRED PATHS "D:/lib/googletest-1.14.0/lib/cmake/GTest"^)
echo.
echo target_link_libraries^(${PROJECT_NAME} GTest::gtest_main^)
echo.
echo add_test^(NAME ${PROJECT_NAME} COMMAND $^<TARGET_FILE:${PROJECT_NAME}^>^)
echo.
echo set^(BINARY_DIR ${PROJECT_BINARY_DIR}^)
echo.
echo set^(OUTPUT_DEB_DIR "${BINARY_DIR}/Debug"^)
echo set^(OUTPUT_REL_DIR "${BINARY_DIR}/Release"^)
echo.
echo file^(MAKE_DIRECTORY ${OUTPUT_DEB_DIR}^)
echo file^(MAKE_DIRECTORY ${OUTPUT_REL_DIR}^)
echo.
echo file^(GLOB DEPS_DEB_DLLS "D:/lib/googletest-1.14.0/bind/*.dll"^)
echo file^(GLOB DEPS_REL_DLLS "D:/lib/googletest-1.14.0/bin/*.dll"^)
echo.
echo add_custom_command^(
echo   TARGET ${PROJECT_NAME}
echo   POST_BUILD
echo   COMMAND ${CMAKE_COMMAND} -E copy ${DEPS_DEB_DLLS} ${OUTPUT_DEB_DIR}
echo   COMMAND ${CMAKE_COMMAND} -E copy ${DEPS_REL_DLLS} ${OUTPUT_REL_DIR}^)
) > .\test\CMakelists.txt

@REM Create a sample README.md file
(
echo # %PROJECT_NAME%
echo.
echo This is a sample project created using the create-project.bat script.
echo.
echo ## Building
echo To build the project, run the build.bat script with the desired configuration ^(Debug or Release^) as an argument.
echo.
echo ## Running
echo To run the project, run the run.bat script with the desired configuration ^(Debug or Release^) as an argument.
echo.
echo ## Cleaning
echo To clean the project, run the clean.bat script.
echo.
echo ## Dependencies
echo This project has no dependencies.
echo.
echo ## License
echo This project is licensed under the MIT license.
) > .\README.md

@REM Create a sample .gitignore file
(
echo # Ignore build directory
echo build/
) > .\.gitignore

@REM Create a sample .clang-format file
call clang-format.exe -style=microsoft -dump-config > .\.clang-format

@REM Create a sample LICENSE file
(
echo MIT License
echo.
echo Copyright ^(c^) 2024 Yifan Xing
echo.
echo Permission is hereby granted, free of charge, to any person obtaining a copy
echo of this software and associated documentation files ^(the "Software"^), to deal
echo in the Software without restriction, including without limitation the rights
echo to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
echo copies of the Software, and to permit persons to whom the Software is
echo furnished to do so, subject to the following conditions:
echo.
echo The above copyright notice and this permission notice shall be included in all
echo copies or substantial portions of the Software.
echo.
echo THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
echo IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
echo FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
echo AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
echo LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
echo OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
echo SOFTWARE.
) > .\LICENSE

echo "Project %PROJECT_NAME% has been set up with a basic directory structure and CMake config."