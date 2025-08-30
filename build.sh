#!/bin/bash

# AxionAOSP Custom ROM Build Script
# Device: Realme GT Neo 3T (spartan)
# Author: Generated for bijoyv9
# Created: August 30, 2025

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ROM_NAME="AxionAOSP"
DEVICE="spartan"
BUILD_DIR="$HOME/axion"
MANIFEST_URL="https://github.com/AxionAOSP/android.git"
MANIFEST_BRANCH="lineage-23.0"
SYNC_JOBS="24"

# Build configuration - modify these as needed
BUILD_VARIANT="userdebug"                        # Build variant: user, userdebug, eng
GMS_VARIANT="vanilla"                            # GMS variant: vanilla, gms pico, gms core
BUILD_TYPE="-b"                                  # Build type: -b (bacon), -fb (fastboot), -br (brunch)

# Device-specific repositories
DEVICE_TREE_URL="https://github.com/AxionAOSP-devices/android_device_realme_spartan.git"
DEVICE_TREE_BRANCH="lineage-23.0"
VENDOR_TREE_URL="https://github.com/AxionAOSP-devices/proprietary_vendor_realme_spartan.git"
VENDOR_TREE_BRANCH="lineage-23.0"
HW_OPLUS_URL="https://github.com/AxionAOSP-devices/android_hardware_oplus.git"
HW_OPLUS_BRANCH="lineage-23.0"
KERNEL_TREE_URL="https://github.com/bijoyv9/kernel_realme_RMX3371.git"
KERNEL_TREE_BRANCH="phoeniX-AOSP"
CAMERA_TREE_URL="https://gitlab.com/ryukftw/proprietary_vendor_oplus_camera.git"
CAMERA_TREE_BRANCH="15.0"
SIGNING_KEYS_URL="https://github.com/bijoyv9/axion-keys.git"
SIGNING_KEYS_BRANCH="master"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
check_command() {
    if ! command -v "$1" &> /dev/null; then
        print_error "Command '$1' not found. Please install it first."
        exit 1
    fi
}

# Function to check system requirements
check_requirements() {
    print_status "Checking system requirements..."
    
    # Check for required tools
    check_command "repo"
    check_command "git"
    check_command "python3"
    check_command "make"
    check_command "gcc"
    
    # Check available disk space (minimum 500GB recommended)
    available_space=$(df -BG "$HOME" | awk 'NR==2 {print $4}' | sed 's/G//')
    if [ "$available_space" -lt 500 ]; then
        print_warning "Available disk space: ${available_space}GB. Minimum 500GB recommended for Android builds."
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    print_success "System requirements check completed"
}

# Function to setup build directory
setup_build_dir() {
    print_status "Setting up build directory..."
    
    # Create build directory
    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR"
    
    print_success "Build directory setup completed"
}

# Function to initialize and sync ROM sources
sync_sources() {
    print_status "Initializing and syncing ROM sources..."
    cd "$BUILD_DIR"
    
    # Initialize repo
    print_status "Initializing repository..."
    repo init -u "$MANIFEST_URL" -b "$MANIFEST_BRANCH" --git-lfs
    
    if [ $? -ne 0 ]; then
        print_error "Failed to initialize repository"
        exit 1
    fi
    
    # Sync sources
    print_status "Syncing sources (this may take a while)..."
    repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j"$SYNC_JOBS"
    
    if [ $? -ne 0 ]; then
        print_error "Failed to sync sources"
        exit 1
    fi
    
    print_success "ROM sources synced successfully"
}

# Function to clean existing device repositories
clean_device_repos() {
    print_status "Cleaning existing device repositories..."
    cd "$BUILD_DIR"
    
    # List of device repo directories to clean
    DEVICE_DIRS=(
        "device/realme/$DEVICE"
        "vendor/realme/$DEVICE"
        "hardware/oplus"
        "kernel/realme/sm8250"
        "vendor/oplus/camera"
        "vendor/lineage-priv"
    )
    
    for dir in "${DEVICE_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            print_status "Removing $dir"
            rm -rf "$dir"
        fi
    done
    
    print_success "Device repositories cleaned"
}

# Function to clone device-specific repositories
clone_device_repos() {
    print_status "Cloning device-specific repositories..."
    cd "$BUILD_DIR"
    
    # Clone device tree
    print_status "Cloning device tree..."
    git clone "$DEVICE_TREE_URL" -b "$DEVICE_TREE_BRANCH" "device/realme/$DEVICE"
    
    # Clone vendor tree
    print_status "Cloning vendor tree..."
    git clone "$VENDOR_TREE_URL" -b "$VENDOR_TREE_BRANCH" "vendor/realme/$DEVICE"
    
    # Clone hardware/oplus
    print_status "Cloning hardware/oplus..."
    git clone "$HW_OPLUS_URL" -b "$HW_OPLUS_BRANCH" "hardware/oplus"
    
    # Clone kernel tree
    print_status "Cloning kernel tree..."
    git clone "$KERNEL_TREE_URL" -b "$KERNEL_TREE_BRANCH" "kernel/realme/sm8250"
    
    # Clone camera tree
    print_status "Cloning camera tree..."
    git clone "$CAMERA_TREE_URL" -b "$CAMERA_TREE_BRANCH" "vendor/oplus/camera"
    
    # Clone signing keys
    print_status "Cloning signing keys..."
    git clone "$SIGNING_KEYS_URL" -b "$SIGNING_KEYS_BRANCH" "vendor/lineage-priv"
    
    print_success "All device repositories cloned successfully"
}

# Function to setup build environment and start compilation
build_rom() {
    print_status "Setting up build environment and starting compilation..."
    cd "$BUILD_DIR"
    
    # Source build environment
    print_status "Sourcing build environment..."
    source build/envsetup.sh
    
    # Setup device configuration
    print_status "Setting up device configuration with AxionAOSP..."
    if [ "$GMS_VARIANT" = "vanilla" ]; then
        axion "$DEVICE" "$BUILD_VARIANT" vanilla
    elif [ "$GMS_VARIANT" = "gms core" ]; then
        axion "$DEVICE" "$BUILD_VARIANT" gms core
    elif [ "$GMS_VARIANT" = "gms pico" ]; then
        axion "$DEVICE" "$BUILD_VARIANT" gms pico
    else
        axion "$DEVICE" "$BUILD_VARIANT" "$GMS_VARIANT"
    fi
    
    if [ $? -ne 0 ]; then
        print_error "Failed to setup device configuration"
        exit 1
    fi
    
    # Run installclean if this is a clean build
    if [ "$CLEAN_FIRST" = true ]; then
        print_status "Running installclean for clean build..."
        make installclean
    fi
    
    # Get number of CPU cores for parallel compilation
    CORES=$(nproc)
    print_status "Starting build with $CORES parallel jobs..."
    
    # Start the build using AxionAOSP build system
    print_status "Building ROM (this will take several hours)..."
    ax "$BUILD_TYPE" -j"$CORES" "$BUILD_VARIANT"
    
    if [ $? -eq 0 ]; then
        print_success "ROM build completed successfully!"
        
        # Find the output file
        OUTPUT_FILE=$(find "$BUILD_DIR/out/target/product/$DEVICE" -maxdepth 1 -name "*axion*.zip" | head -1)
        if [ -n "$OUTPUT_FILE" ]; then
            print_success "ROM file created: $OUTPUT_FILE"
            ls -lh "$OUTPUT_FILE"
        fi
    else
        print_error "ROM build failed!"
        exit 1
    fi
}

# Function to clean build (optional) - only for complete clean
clean_build() {
    print_status "Cleaning build directory..."
    cd "$BUILD_DIR"
    if [ -f "build/envsetup.sh" ]; then
        source build/envsetup.sh
        make installclean
    else
        print_warning "Build environment not found, skipping clean"
    fi
    print_success "Build directory cleaned"
}

# Main execution flow
main() {
    clear
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  $ROM_NAME Custom ROM Builder  ${NC}"
    echo -e "${BLUE}  Device: Realme GT Neo 3t      ${NC}"
    echo -e "${BLUE}================================${NC}"
    echo
    
    # Parse command line arguments
    SKIP_SYNC=false
    CLEAN_FIRST=false
    CLEAN_REPOS=false
    SKIP_CLONE=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --skip-sync)
                SKIP_SYNC=true
                shift
                ;;
            --clean)
                CLEAN_FIRST=true
                shift
                ;;
            --clean-repos)
                CLEAN_REPOS=true
                shift
                ;;
            --skip-clone)
                SKIP_CLONE=true
                shift
                ;;
            --gms)
                case $2 in
                    pico|core)
                        GMS_VARIANT="gms $2"
                        shift 2
                        ;;
                    *)
                        GMS_VARIANT="gms core"
                        shift
                        ;;
                esac
                ;;
            --vanilla)
                GMS_VARIANT="vanilla"
                shift
                ;;
            --variant)
                case $2 in
                    user|userdebug|eng)
                        BUILD_VARIANT="$2"
                        shift 2
                        ;;
                    *)
                        print_error "Invalid build variant: $2. Use user, userdebug, or eng"
                        exit 1
                        ;;
                esac
                ;;
            --build-type)
                case $2 in
                    bacon|-b)
                        BUILD_TYPE="-b"
                        shift 2
                        ;;
                    fastboot|-fb)
                        BUILD_TYPE="-fb"
                        shift 2
                        ;;
                    brunch|-br)
                        BUILD_TYPE="-br"
                        shift 2
                        ;;
                    *)
                        print_error "Invalid build type: $2. Use bacon, fastboot, or brunch"
                        exit 1
                        ;;
                esac
                ;;
            --help|-h)
                echo "Usage: $0 [OPTIONS]"
                echo "Options:"
                echo "  --skip-sync           Skip source sync (useful for rebuilds)"
                echo "  --clean               Clean build directory before building"
                echo "  --clean-repos         Clean and re-clone device repositories"
                echo "  --skip-clone          Skip cloning device repositories"
                echo "  --gms [pico|core]     Build with GMS (default: core)"
                echo "  --vanilla             Build vanilla (no GMS)"
                echo "  --variant <variant>   Build variant: user, userdebug, eng (default: userdebug)"
                echo "  --build-type <type>   Build type: bacon, fastboot, brunch (default: bacon)"
                echo "  --help, -h            Show this help message"
                echo
                echo "Examples:"
                echo "  $0                    # Vanilla userdebug build"
                echo "  $0 --gms core         # GMS core build"
                echo "  $0 --gms pico         # GMS pico build"
                echo "  $0 --variant user     # User variant build"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
    
    # Show configuration
    echo -e "${YELLOW}Build Configuration:${NC}"
    echo "  ROM: $ROM_NAME"
    echo "  Device: $DEVICE"
    echo "  Build Directory: $BUILD_DIR"
    echo "  Manifest Branch: $MANIFEST_BRANCH"
    echo "  Sync Jobs: $SYNC_JOBS"
    echo "  Build Variant: $BUILD_VARIANT"
    echo "  GMS Variant: $GMS_VARIANT"
    echo "  Build Type: $BUILD_TYPE"
    echo "  Skip Sync: $SKIP_SYNC"
    echo "  Clean First: $CLEAN_FIRST"
    echo "  Clean Repos: $CLEAN_REPOS"
    echo "  Skip Clone: $SKIP_CLONE"
    echo
    
    # Confirmation
    read -p "Continue with build? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Build cancelled by user"
        exit 0
    fi
    
    # Record start time
    START_TIME=$(date +%s)
    
    # Execute build steps
    check_requirements
    setup_build_dir
    
    # Note: Clean will be handled after build environment setup
    
    # Sync sources (unless skipped)
    if [ "$SKIP_SYNC" = false ]; then
        sync_sources
    else
        print_warning "Skipping source sync as requested"
        if [ ! -d "$BUILD_DIR/.repo" ]; then
            print_error "No existing repo found in $BUILD_DIR. Cannot skip sync."
            exit 1
        fi
    fi
    
    # Clean and re-clone device repos if requested
    if [ "$CLEAN_REPOS" = true ]; then
        clean_device_repos
    fi
    
    # Clone device repos unless skipped
    if [ "$SKIP_CLONE" = false ]; then
        clone_device_repos
    else
        print_warning "Skipping device repository cloning as requested"
        # Verify essential device repos exist
        if [ ! -d "$BUILD_DIR/device/realme/$DEVICE" ]; then
            print_error "Device tree not found. Cannot skip cloning without existing device repos."
            exit 1
        fi
    fi
    
    build_rom
    
    # Calculate and display build time
    END_TIME=$(date +%s)
    BUILD_TIME=$((END_TIME - START_TIME))
    HOURS=$((BUILD_TIME / 3600))
    MINUTES=$(((BUILD_TIME % 3600) / 60))
    SECONDS=$((BUILD_TIME % 60))
    
    echo
    echo -e "${GREEN}================================${NC}"
    echo -e "${GREEN}       BUILD COMPLETED!         ${NC}"
    echo -e "${GREEN}================================${NC}"
    echo -e "${GREEN}Total build time: ${HOURS}h ${MINUTES}m ${SECONDS}s${NC}"
    echo
}

# Trap to handle script interruption
trap 'echo -e "\n${RED}Build interrupted by user${NC}"; exit 1' INT

# Run main function with all arguments
main "$@"
