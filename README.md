# AxionAOSP ROM Build Script

Automated build script for AxionAOSP custom ROM targeting Realme GT Neo 3T (spartan).

## 🚀 Quick Start

```bash
# One command install and run
curl -fsSL https://raw.githubusercontent.com/bijoyv9/build-script/main/build.sh | bash

# Or download first
curl -fsSL https://raw.githubusercontent.com/bijoyv9/build-script/main/build.sh -o build.sh && chmod +x build.sh
./build.sh --gms core
```

## 📋 Prerequisites

**System Requirements:** Ubuntu/Debian Linux, 500GB+ disk space, 16GB+ RAM

**Install Dependencies:**
```bash
# Repo tool
mkdir -p ~/.bin && curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo && chmod a+rx ~/.bin/repo
echo 'export PATH="${HOME}/.bin:${PATH}"' >> ~/.bashrc && source ~/.bashrc

# Build tools
sudo apt update && sudo apt install git-core gnupg flex bison build-essential zip curl zlib1g-dev libc6-dev-i386 libncurses5 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig python3
```

## 🛠️ Usage

### Basic Commands
```bash
./build.sh --gms core                # First build (recommended)
./build.sh --skip-sync --gms core    # Quick rebuild
./build.sh --help                    # Show all options
```

### Build Options

| Option | Description | Example |
|--------|-------------|----------|
| `--gms [pico\|core]` | Include Google services | `--gms core` |
| `--vanilla` | No Google services (default) | `--vanilla` |
| `--variant <type>` | user/userdebug/eng | `--variant user` |
| `--build-type <type>` | bacon/fastboot/brunch | `--build-type fastboot` |
| `--skip-sync` | Skip source download | `--skip-sync` |
| `--skip-clone` | Skip device repo cloning | `--skip-clone` |
| `--clean` | Clean build environment | `--clean` |
| `--clean-repos` | Fresh device repositories | `--clean-repos` |

### Common Workflows
```bash
# Development (daily)
./build.sh --skip-sync --gms core

# Production release
./build.sh --variant user --gms core --clean --clean-repos

# Quick test
./build.sh --skip-sync --skip-clone --variant eng

# Fresh start
rm -rf ~/axion && ./build.sh --gms core
```

## ⚡ Build Times

| Type | Duration | Command |
|------|----------|---------|
| First build | 4-8 hours | `./build.sh --gms core` |
| Incremental | 1-3 hours | `--skip-sync` |
| Quick rebuild | 30min-2h | `--skip-sync --skip-clone` |

## 🏗️ Build Process

1. **Source Sync**: Downloads AxionAOSP source (~200GB)
2. **Device Setup**: Clones 6 device-specific repositories
3. **Configuration**: Uses AxionAOSP's `axion` command instead of `lunch`
4. **Build**: Uses `ax` command instead of `make`/`mka`
5. **Output**: ROM files in `~/axion/out/target/product/spartan/`

### AxionAOSP Commands
```bash
# Device configuration (replaces lunch)
axion spartan user gms core

# Build execution (replaces mka)
ax -b -j96 user
```

## 🔍 Troubleshooting

| Issue | Solution |
|-------|----------|
| Out of space | Ensure 500GB+ available |
| Sync failures | Use `--skip-sync` for rebuilds |
| Build errors | Check `~/axion/out/build.log` |
| Device repo conflicts | Use `--clean-repos` |
| Environment issues | Use `--clean` |

### Debug Commands
```bash
# View build logs
tail -f ~/axion/out/build.log

# Reset everything
rm -rf ~/axion && ./build.sh --gms core

# Test manually
cd ~/axion && . build/envsetup.sh && axion spartan userdebug gms core
```

## 📂 Directory Structure
```
~/axion/
├── device/realme/spartan/          # Device configuration
├── vendor/realme/spartan/          # Proprietary files
├── kernel/realme/sm8250/           # Kernel source
├── hardware/oplus/                 # Hardware support
└── out/target/product/spartan/     # Build output
```

## 🎯 Target Device

- **Device**: Realme GT Neo 3T (spartan)
- **Platform**: Snapdragon 870 (SM8250)
- **ROM**: AxionAOSP (LineageOS 23.0 based)

## 📞 Support

- Script issues: Check logs and error messages
- ROM issues: Visit AxionAOSP community
- Device specific: Check XDA forums

---

**Happy Building! 🚀**
