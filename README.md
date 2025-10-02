# AxionAOSP ROM Build Script

Automated build script for AxionAOSP custom ROM with multi-device support via JSON configurations.

## 🚀 Quick Start

```bash
git clone https://github.com/SM8250-Common/build-script_axion.git build-axion && cd build-axion && chmod +x build.sh
./build.sh --device spartan --gms core
```

## 📋 Prerequisites

**System Requirements:** Ubuntu/Debian Linux, 500GB+ disk space, 16GB+ RAM

**Install Dependencies:**
```bash
# Repo tool
mkdir -p ~/.bin && curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo && chmod a+rx ~/.bin/repo
echo 'export PATH="${HOME}/.bin:${PATH}"' >> ~/.bashrc && source ~/.bashrc

# Build tools
sudo apt update && sudo apt install git-core gnupg flex bison build-essential zip curl zlib1g-dev libc6-dev-i386 libncurses5 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig python3 jq
```

## 🛠️ Usage

### Basic Commands
```bash
./build.sh -d spartan --gms core              # First build
./build.sh -d spartan --skip-sync --gms core  # Quick rebuild
./build.sh --help                             # Show all options
```

### Build Options

| Option | Description |
|--------|-------------|
| `--device, -d <name>` | Device to build (required) |
| `--gms [pico\|core]` | Include Google services |
| `--vanilla` | No Google services (default) |
| `--variant <type>` | user/userdebug/eng |
| `--build-type <type>` | bacon/fastboot/brunch |
| `--skip-sync` | Skip source download |
| `--skip-clone` | Skip device repo cloning |
| `--clean` | Clean build environment |
| `--clean-repos` | Fresh device repositories |

### Common Workflows
```bash
# First build
./build.sh -d spartan --gms core

# Daily development
./build.sh -d spartan --skip-sync --gms core

# Production release
./build.sh -d spartan --variant user --gms core --clean-repos

# Quick test
./build.sh -d spartan --skip-sync --skip-clone
```

## 📱 Device Configuration

Device configs are stored in `devices/*.json`. Each JSON defines repositories, branches, and build settings.

### Adding a New Device
1. Copy `devices/device-template.json` to `devices/your-device.json`
2. Update device info, repository URLs, and branches
3. Build: `./build.sh -d your-device`

**Included Devices:**
- `spartan` - Realme GT Neo 3T

---

**Happy Building! 🚀**
