# CUVISTA Installation Guide

This guide will help you build and install cuvista for CUDA-powered video stabilization on Windows.

## Prerequisites

### Required Dependencies

1. **Visual Studio 2022**
   - Download from: https://visualstudio.microsoft.com/downloads/
   - During installation, select "Desktop development with C++" workload
   - This includes MSVC compiler, Windows SDK, and necessary tools

2. **CUDA Toolkit** ✅ (Already installed)
   - You have CUDA 13.1 installed, which is compatible

3. **FFmpeg**
   - Download from: https://www.ffmpeg.org/download.html
   - Choose "Windows builds from gyan.dev" → "shared" version
   - Extract to a directory like `C:\ffmpeg`

4. **CMake** ✅ (Already installed via pip)
   - Version 4.2.3 is installed and working

### Optional Dependencies

5. **Qt6** (for GUI version)
   - Download from: https://www.qt.io/download-qt-installer
   - Install at least Qt6.10.1 for MSVC2022 64-bit
   - Install Qt Multimedia component

## Installation Steps

### Step 1: Set up FFmpeg

1. Download and extract FFmpeg to `C:\ffmpeg` (or your preferred location)
2. Set the environment variable:
   ```cmd
   set FFMPEG_PATH=C:\ffmpeg
   ```
   Or add it permanently to your system environment variables.

### Step 2: Open Visual Studio Command Prompt

1. Open Start Menu
2. Search for "x64 Native Tools Command Prompt for VS 2022"
3. Run it as Administrator

### Step 3: Build cuvista

1. Navigate to your cuvista directory:
   ```cmd
   cd L:\DEV_projects\cuvista
   ```

2. Run the build script:
   ```cmd
   build_cuvista.bat
   ```

   Or build manually:
   ```cmd
   # Create build directory
   mkdir build
   cd build
   
   # Configure with CMake (with Qt6 if available)
   python -m cmake .. -DFFMPEG_PATH="C:\ffmpeg" -DBUILD_GUI=1 --fresh
   
   # Build
   python -m cmake --build . --config Release
   
   # Install (optional, copies dependencies)
   python -m cmake --install . --config Release
   ```

### Step 4: Test Installation

After successful build:

```cmd
cd build\install
cuvista.exe -info
```

This should show available CUDA devices and test the installation.

## Usage

### Command Line Interface (CLI)
```cmd
cuvista.exe -i input.mp4 -o output.mp4
```

### GUI Version (if Qt6 was installed)
```cmd
cuvistaGui.exe
```

## Troubleshooting

### Common Issues

1. **"cl is not recognized"**
   - Make sure you're running from "x64 Native Tools Command Prompt for VS 2022"

2. **FFmpeg not found**
   - Verify FFMPEG_PATH points to correct directory
   - Check that `bin\avcodec.dll` exists in the FFmpeg directory

3. **Qt6 not found**
   - GUI will be skipped automatically
   - Install Qt6 from https://www.qt.io/download-qt-installer
   - Set CMAKE_PREFIX_PATH to Qt installation directory

4. **CUDA not detected**
   - Verify CUDA 13.1 is installed (you have it)
   - Check that CUDA_PATH environment variable is set

### Build Options

You can customize the build with these CMake options:

- `-DBUILD_CUDA=1` - Enable CUDA (default: auto-detect)
- `-DBUILD_GUI=1` - Enable GUI (requires Qt6)
- `-DCMAKE_PREFIX_PATH=path` - Set Qt6 path if not in default location

## Alternative: Pre-built Binaries

If building from source proves difficult, you can:

1. Download pre-built binaries from GitHub releases:
   https://github.com/RainerMtb/cuvista/releases

2. Or install from Microsoft Store:
   https://apps.microsoft.com/detail/9njq1qxk96w7

## Support

For issues or questions:
- GitHub Issues: https://github.com/RainerMtb/cuvista/issues
- Documentation: https://rainermtb.github.io/cuvista