@echo off
echo.
echo ================================================
echo CUVISTA BUILD SCRIPT
echo ================================================
echo.
echo Prerequisites:
echo 1. Visual Studio 2022 with C++ development tools
echo 2. FFmpeg binaries (download from https://www.ffmpeg.org/download.html)
echo 3. CUDA Toolkit (already installed)
echo 4. Qt6 (optional, for GUI - download from https://www.qt.io/download-qt-installer)
echo.
echo Before running this script:
echo - Set FFMPEG_PATH environment variable to your FFmpeg installation directory
echo   Example: set FFMPEG_PATH=C:\ffmpeg
echo - Open "x64 Native Tools Command Prompt for VS 2022" from Start Menu
echo.
pause

echo.
echo Checking prerequisites...

rem Check if we're in Visual Studio command prompt
where cl >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Please run this script from "x64 Native Tools Command Prompt for VS 2022"
    echo You can find it in Start Menu under Visual Studio 2022 - Tools
    pause
    exit /b 1
)

rem Check if FFMPEG_PATH is set
if "%FFMPEG_PATH%"=="" (
    echo ERROR: FFMPEG_PATH environment variable is not set
    echo Please set it to your FFmpeg installation directory
    echo Example: set FFMPEG_PATH=C:\ffmpeg
    pause
    exit /b 1
)

rem Check if FFmpeg files exist
if not exist "%FFMPEG_PATH%\bin\avcodec.dll" (
    echo ERROR: FFmpeg not found in %FFMPEG_PATH%
    echo Please download FFmpeg from https://www.ffmpeg.org/download.html
    echo and extract to the directory specified by FFMPEG_PATH
    pause
    exit /b 1
)

echo Prerequisites check passed!
echo FFMPEG_PATH: %FFMPEG_PATH%
echo.

echo Creating build directory...
if exist build rmdir /s /q build
mkdir build
cd build

echo.
echo Configuring CMake...

rem Try to find Qt6 automatically, or skip GUI if not found
python -c "import sys; sys.path.append('..'); exec(open('../check_qt.py').read())" >nul 2>&1
if %errorlevel% equ 0 (
    echo Qt6 found, building with GUI support
    set BUILD_GUI=1
) else (
    echo Qt6 not found, building CLI only
    set BUILD_GUI=0
)

rem Configure CMake
python -m cmake .. -DFFMPEG_PATH="%FFMPEG_PATH%" -DBUILD_GUI=%BUILD_GUI% --fresh

if %errorlevel% neq 0 (
    echo ERROR: CMake configuration failed
    echo Please check that all dependencies are installed correctly
    pause
    exit /b 1
)

echo.
echo Building cuvista...
python -m cmake --build . --config Release

if %errorlevel% equ 0 (
    echo.
    echo ================================================
    echo BUILD SUCCESSFUL!
    echo ================================================
    echo.
    echo Executables created:
    echo - CLI version: build\cuvistaCli\Release\cuvista.exe
    echo - GUI version: build\cuvistaGui\Release\cuvistaGui.exe (if Qt6 was found)
    echo.
    echo To install with dependencies:
    echo cd build
    echo python -m cmake --install . --config Release
    echo.
    echo To test the installation:
    echo cd build\install
    echo cuvista.exe -info
    echo.
) else (
    echo.
    echo ERROR: Build failed
    echo Please check the error messages above
    pause
    exit /b 1
)

pause