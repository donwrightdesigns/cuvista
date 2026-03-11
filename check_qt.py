#!/usr/bin/env python3
"""
Helper script to check if Qt6 is available for cuvista build
"""
import subprocess
import sys
import os

def check_qt6():
    """Check if Qt6 is available"""
    try:
        # Try to find Qt6 using pkg-config or cmake
        result = subprocess.run([
            sys.executable, '-m', 'cmake', '-E', 'echo', 'Qt6 check'
        ], capture_output=True, text=True, timeout=10)
        
        # Try to find Qt6 using cmake
        cmake_cmd = [
            sys.executable, '-m', 'cmake', 
            '-D', 'CMAKE_PREFIX_PATH=C:/Qt/6.10.1/msvc2022_64',
            '-P', 'check_qt.cmake'
        ]
        
        # Create a simple cmake script to check Qt6
        qt_check_cmake = """
find_package(Qt6 QUIET COMPONENTS Core Gui Widgets Multimedia MultimediaWidgets)
if(Qt6_FOUND)
    message(STATUS "Qt6 found: ${Qt6_DIR}")
    execute_process(COMMAND ${CMAKE_COMMAND} -E echo "Qt6_FOUND=1" OUTPUT_FILE qt6_found.txt)
else()
    message(STATUS "Qt6 not found")
    execute_process(COMMAND ${CMAKE_COMMAND} -E echo "Qt6_FOUND=0" OUTPUT_FILE qt6_found.txt)
endif()
"""
        
        with open('check_qt.cmake', 'w') as f:
            f.write(qt_check_cmake)
        
        result = subprocess.run(cmake_cmd, capture_output=True, text=True, timeout=30)
        
        if os.path.exists('qt6_found.txt'):
            with open('qt6_found.txt', 'r') as f:
                content = f.read().strip()
                if 'Qt6_FOUND=1' in content:
                    return True
        
        return False
        
    except Exception as e:
        print(f"Qt6 check failed: {e}")
        return False

if __name__ == "__main__":
    if check_qt6():
        sys.exit(0)
    else:
        sys.exit(1)