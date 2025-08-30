# AxionAOSP ROM Build Script

Automated build script for AxionAOSP custom ROM targeting Realme GT Master Edition (spartan).

## 🚀 Quick Start

### Download and Run (One Command)
```bash
curl -fsSL https://raw.githubusercontent.com/bijoyv9/build-script/main/build.sh | bash
```

### Download Script Only
```bash
curl -fsSL https://raw.githubusercontent.com/bijoyv9/build-script/main/build.sh -o build.sh
chmod +x build.sh
```

## 📋 Prerequisites

- Ubuntu/Debian Linux system
- Minimum 500GB free disk space
- 16GB+ RAM recommended
- Fast internet connection
- Git, repo tool, Python3, make, gcc installed

### Install Required Tools
```bash
# Install repo tool
mkdir -p ~/.bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
chmod a+rx ~/.bin/repo

# Add to PATH (add to ~/.bashrc)
export PATH="${HOME}/.bin:${PATH}"

# Install dependencies
sudo apt update
sudo apt install git-core gnupg flex bison build-essential zip curl zlib1g-dev libc6-dev-i386 libncurses5 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig python3
```

## 🛠️ Usage

### Basic Usage
```bash
# Default vanilla userdebug build
./build.sh

# Show help
./build.sh --help
```

### Build Variants

#### GMS Builds
```bash
# GMS Core build (recommended)
./build.sh --gms core

# GMS Pico build (minimal Google services)
./build.sh --gms pico

# GMS without specifying variant (defaults to core)
./build.sh --gms
```

#### Vanilla Build
```bash
# Vanilla build (no Google services) - default
./build.sh --vanilla
```

### Build Types
```bash
# Bacon build (full ROM) - default
./build.sh --build-type bacon

# Fastboot images only
./build.sh --build-type fastboot

# Brunch build
./build.sh --build-type brunch
```

### Build Variants
```bash
# User variant (production)
./build.sh --variant user

# Engineering variant (debug)
./build.sh --variant eng

# Userdebug variant (default)
./build.sh --variant userdebug
```

### Advanced Options
```bash
# Skip source sync (for rebuilds)
./build.sh --skip-sync --gms core

# Clean build
./build.sh --clean --gms pico

# Combined options
./build.sh --gms core --variant user --build-type bacon --clean
```

## 📁 What Gets Built

The script automatically handles:

1. **Source Sync**: Downloads AxionAOSP source code
2. **Device Repositories**:
   - Device tree (realme spartan)
   - Vendor blobs
   - Hardware/oplus
   - Kernel (phoeniX-AOSP)
   - Camera blobs
   - Signing keys
3. **Build Process**: Uses AxionAOSP's custom build system

## 🏗️ Build Process

1. **Requirements Check**: Verifies tools and disk space
2. **Setup**: Creates build directory (`~/axion`)
3. **Source Sync**: Downloads ROM sources (if not skipped)
4. **Device Setup**: Clones all device-specific repositories
5. **Configuration**: Sets up build environment with `axion` command
6. **Clean**: Runs `make installclean`
7. **Build**: Executes `ax` build command with optimal job count

## 📂 Directory Structure

```
~/axion/                              # Build directory
├── .repo/                           # Repo metadata
├── device/realme/spartan/           # Device tree
├── vendor/realme/spartan/           # Vendor blobs
├── vendor/lineage-priv/             # Signing keys
├── vendor/oplus/camera/             # Camera blobs
├── hardware/oplus/                  # Hardware abstraction
├── kernel/realme/sm8250/            # Kernel source
└── out/target/product/spartan/      # Build output
```

## 🔧 Configuration

Edit the script variables at the top to customize:

```bash
DEVICE="spartan"                     # Target device
BUILD_DIR="$HOME/axion"              # Build directory
SYNC_JOBS="24"                       # Parallel sync jobs
BUILD_VARIANT="userdebug"            # Default build variant
GMS_VARIANT="vanilla"                # Default GMS variant
BUILD_TYPE="-b"                      # Default build type
```

## 📊 Build Time Estimates

- **First Build**: 4-8 hours (depending on hardware)
- **Incremental Build**: 30 minutes - 2 hours
- **Clean Build**: 2-4 hours

## 🔍 Troubleshooting

### Common Issues

1. **Out of Space**: Ensure 500GB+ free space
2. **Sync Failures**: Check internet connection, try reducing `SYNC_JOBS`
3. **Build Failures**: Check logs in `out/` directory
4. **Missing Dependencies**: Run the prerequisite installation commands

### Build Logs
```bash
# Check build logs
tail -f ~/axion/out/build.log

# Check specific errors
grep -i error ~/axion/out/build.log
```

### Reset Build
```bash
# Clean and restart
./build.sh --clean

# Complete fresh start
rm -rf ~/axion
./build.sh
```

## 📝 Examples

### Complete First Build
```bash
# Download and run vanilla build
curl -fsSL https://raw.githubusercontent.com/bijoyv9/build-script/main/build.sh | bash
```

### GMS Core Build
```bash
./build.sh --gms core
```

### Quick Rebuild
```bash
./build.sh --skip-sync --gms core
```

### Production Build
```bash
./build.sh --variant user --gms core --clean
```

## 🎯 Target Device

- **Device**: Realme GT Master Edition
- **Codename**: spartan
- **Platform**: SM8250 (Snapdragon 870)
- **ROM**: AxionAOSP (LineageOS 23.0 based)

## 📞 Support

For issues related to:
- **Script**: Check the script logs and error messages
- **AxionAOSP**: Visit AxionAOSP community channels
- **Device**: Check device-specific forums

---

**Happy Building! 🚀**
