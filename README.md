# AxionAOSP ROM Build Script

Automated build script for AxionAOSP custom ROM targeting Realme GT Neo 3T (spartan).

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

### First Time Build
```bash
# Default vanilla userdebug build
./build.sh

# First time GMS core build
./build.sh --gms core

# Show all available options
./build.sh --help
```

## ⚡ Skip Sync Options (For Rebuilds)

### Basic Skip Sync
```bash
# Skip source sync (when you already have sources)
./build.sh --skip-sync --gms core

# Skip sync with different variants
./build.sh --skip-sync --gms pico --variant user
./build.sh --skip-sync --vanilla --variant eng
```

### Clean Device Repositories
```bash
# Skip sync + clean device repos (fresh device files)
./build.sh --skip-sync --clean-repos --gms core

# Perfect for when device repos are updated
./build.sh --skip-sync --clean-repos --gms core --variant user
```

### Complete Clean Rebuilds
```bash
# Skip sync + installclean + fresh device repos
./build.sh --skip-sync --clean --clean-repos --gms core

# Production clean build
./build.sh --skip-sync --clean --clean-repos --gms core --variant user --build-type bacon
```

## 📝 Common Build Scenarios

### Daily Development
```bash
# Quick rebuild after code changes
./build.sh --skip-sync --gms core

# Clean rebuild with fresh device repos
./build.sh --skip-sync --clean-repos --gms core
```

### Weekly Clean Build
```bash
# Complete clean build (keep sources, fresh everything else)
./build.sh --skip-sync --clean --clean-repos --gms core --variant user
```

### Production Release
```bash
# Full production build
./build.sh --skip-sync --clean --clean-repos --variant user --gms core --build-type bacon
```

### Testing Builds
```bash
# Fastboot images for testing
./build.sh --skip-sync --build-type fastboot --gms pico

# Engineering build for debugging
./build.sh --skip-sync --variant eng --vanilla --clean-repos
```

## 🔧 Command Reference

```bash
# All available options
./build.sh [OPTIONS]

Options:
  --skip-sync           Skip source sync (saves hours on rebuilds)
  --clean               Clean build directory (runs installclean)
  --clean-repos         Clean and re-clone device repositories
  --gms [pico|core]     Build with GMS (default: core)
  --vanilla             Build vanilla (no GMS)
  --variant <variant>   Build variant: user, userdebug, eng (default: userdebug)
  --build-type <type>   Build type: bacon, fastboot, brunch (default: bacon)
  --help, -h            Show help message

Examples:
  ./build.sh                                    # First time vanilla build
  ./build.sh --gms core                         # First time GMS build
  ./build.sh --skip-sync --gms core             # Quick rebuild
  ./build.sh --skip-sync --clean-repos --gms core     # Fresh device repos
  ./build.sh --skip-sync --clean --clean-repos --gms core --variant user  # Full clean rebuild
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

## 🔧 AxionAOSP Build System

This script uses AxionAOSP's custom build commands instead of standard AOSP:

### Device Configuration (replaces `lunch`)
```bash
# AxionAOSP uses 'axion' command:
axion <device> <variant> [gms <type> | vanilla]

# Examples the script generates:
axion spartan user vanilla          # Vanilla user build
axion spartan userdebug gms core    # GMS core userdebug build  
axion spartan eng gms pico           # GMS pico engineering build
```

### Build Command (replaces `mka`/`m`)
```bash
# AxionAOSP uses 'ax' command:
ax <build_type> -j<jobs> <variant>

# Examples the script generates:
ax -b -j96 user                      # Bacon build, 96 jobs, user variant
ax -fb -j96 userdebug               # Fastboot build, 96 jobs, userdebug
ax -br -j96 eng                     # Brunch build, 96 jobs, engineering
```

## 🏗️ Build Process Flow

1. **Requirements Check**: Verifies tools and disk space
2. **Setup**: Creates build directory (`~/axion`)
3. **Source Sync**: Downloads ROM sources (skipped with `--skip-sync`)
4. **Device Setup**: Clones device repositories (cleaned with `--clean-repos`)
5. **Environment**: Sources `build/envsetup.sh`
6. **Configuration**: Runs `axion` command with proper GMS variant handling
7. **Clean**: Runs `make installclean` (if `--clean` specified)
8. **Build**: Executes `ax` build command with optimal job count

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

## ⚡ Build Optimization Tips

### For Regular Development
```bash
# First build (sync everything)
./build.sh --gms core

# Daily rebuilds (skip sync)
./build.sh --skip-sync --gms core

# When device repos are updated
./build.sh --skip-sync --clean-repos --gms core
```

### For Clean Builds
```bash
# Clean build with existing repos
./build.sh --skip-sync --clean --gms core

# Complete fresh build (repos + build clean)
./build.sh --skip-sync --clean-repos --clean --gms core
```

### For Different Variants
```bash
# Switch from userdebug to user
./build.sh --skip-sync --clean --variant user --gms core

# Switch from vanilla to GMS
./build.sh --skip-sync --clean-repos --gms core
```

## 📊 Build Time Estimates

- **First Build**: 4-8 hours (full sync + build)
- **Skip Sync Build**: 1-3 hours (just device repos + build)
- **Skip Sync + Clean Repos**: 1.5-3.5 hours (fresh device repos + build)
- **Skip Sync + Clean**: 1-3 hours (installclean + build)

## 🔍 Troubleshooting

### Common Issues & Solutions

1. **Out of Space**: Ensure 500GB+ free space
2. **Sync Failures**: Check internet connection, try reducing `SYNC_JOBS`
3. **Build Failures**: Check logs in `out/` directory  
4. **Missing Dependencies**: Run the prerequisite installation commands
5. **"Multiple device names detected"**: Fixed - script now properly handles GMS variants
6. **"No rule to make target 'installclean'"**: Fixed - clean runs after environment setup
7. **Device repo conflicts**: Use `--clean-repos` to get fresh device repositories
```bash
# Check build logs
tail -f ~/axion/out/build.log

# Check specific errors
grep -i error ~/axion/out/build.log
```

### Reset Options
```bash
# Clean device repos only (when device repos are updated)
./build.sh --skip-sync --clean-repos --gms core

# Clean build environment (when switching variants)
./build.sh --skip-sync --clean --gms core

# Both clean options (complete rebuild without source sync)
./build.sh --skip-sync --clean --clean-repos --gms core

# Complete fresh start (nuclear option)
rm -rf ~/axion
./build.sh --gms core
```

### Debug Build Issues
```bash
# Test axion command manually
. build/envsetup.sh
axion spartan userdebug gms core

# Test ax command manually  
ax -b -j4 userdebug

# Check AxionAOSP build system
ax --help
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

- **Device**: Realme GT Neo 3T
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