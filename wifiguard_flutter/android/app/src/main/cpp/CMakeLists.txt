cmake_minimum_required(VERSION 3.10)

# Project definition
project(WiFiGuard)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_library(
        native-lib SHARED
        "F:/Programming/project/WiFiGuard/wifiguard_flutter/android/app/src/main/cpp/native-lib.cpp"
)

find_library(log-lib log)

target_link_libraries(
        native-lib
        ${log-lib}
)
