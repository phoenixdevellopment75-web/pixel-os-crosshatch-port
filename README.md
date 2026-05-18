# 🔥 PixelOS Android 14 — Poco F1 ➜ Pixel 3 XL Port

> **Codenames:** beryllium (Poco F1) → crosshatch (Pixel 3 XL)  
> **SoC:** Snapdragon 845 (shared — greatly simplifies the port)  
> **Android Version:** 14 (UP1.231005.007)  
> **ROM Base:** [PixelOS](https://pixelos.net)

---

## 📋 Table of Contents

- [Device Compatibility](#-device-compatibility)
- [Features & Status](#-features--status)
- [Prerequisites](#-prerequisites)
- [Build Instructions](#-build-instructions)
- [Patch Information](#-patch-information)
- [Flashing Guide](#-flashing-guide)
- [Known Issues](#-known-issues)
- [Credits](#-credits)

---

## 📱 Device Compatibility

| Feature              | Poco F1 (beryllium) | Pixel 3 XL (crosshatch) | Status     |
|----------------------|---------------------|--------------------------|------------|
| SoC                  | SD845               | SD845                    | ✅ Shared   |
| RAM                  | 6/8 GB LPDDR4X      | 4 GB LPDDR4X             | ✅ OK       |
| Display              | IPS LCD 6.18"       | OLED P-OLED 6.3" + Notch | ✅ Patched  |
| Fingerprint          | Rear capacitive     | Rear capacitive          | ✅ OK       |
| NFC                  | No                  | Yes                      | ✅ Enabled  |
| Wireless Charging    | No                  | Yes (Qi 7.5W)            | ✅ Enabled  |
| Camera               | Dual rear           | Single rear + Dual front | ✅ Patched  |
| Audio                | Hi-Res DAC          | Standard                 | ✅ Patched  |
| USB                  | USB-C 3.1           | USB-C 3.1                | ✅ OK       |
| Bluetooth            | 5.0                 | 5.0                      | ✅ OK       |
| Wi-Fi                | 802.11ac             | 802.11ac                 | ✅ OK       |

---

## ✨ Features & Status

| Feature                      | Status         |
|------------------------------|----------------|
| Boot                         | ✅ Working      |
| Display & Notch Cutout       | ✅ Working      |
| Touchscreen                  | ✅ Working      |
| Wi-Fi                        | ✅ Working      |
| Bluetooth                    | ✅ Working      |
| Calls & SMS                  | ✅ Working      |
| Mobile Data (4G/LTE)         | ✅ Working      |
| Camera (Main)                | ✅ Working      |
| Camera (Front Dual)          | ✅ Working      |
| Fingerprint Sensor           | ✅ Working      |
| NFC                          | ✅ Working      |
| Wireless Charging            | ✅ Working      |
| Audio (Speaker/Mic/3.5mm)    | ✅ Working      |
| USB-C (Data/Charging)        | ✅ Working      |
| GPS                          | ✅ Working      |
| SELinux                      | ✅ Enforcing    |
| SafetyNet / Play Integrity    | ✅ Passing      |
| VoLTE                        | ✅ Working      |
| Hotspot                      | ✅ Working      |
| Encryption                   | ✅ Working      |
| Pixel Features (Now Playing etc) | ✅ Working |

---

## 🛠️ Prerequisites

### System Requirements
- **OS:** Ubuntu 20.04+ or Debian 11+ (Linux only for building)
- **RAM:** Minimum 16 GB (32 GB recommended)
- **Storage:** Minimum 300 GB free space
- **CPU:** 8+ cores recommended

### Install Build Dependencies

```bash
sudo apt update && sudo apt install -y \
  bc bison build-essential ccache curl flex g++-multilib gcc-multilib \
  git git-lfs gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev \
  lib32z1-dev libelf-dev liblz4-tool libncurses5 libncurses5-dev \
  libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop m4 \
  openjdk-11-jdk pngcrush rsync schedtool squashfs-tools xsltproc \
  zip zlib1g-dev python3 python3-pip repo
```

### Setup repo tool
```bash
mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

## 🔨 Build Instructions

### 1. Initialize the PixelOS source

```bash
mkdir -p ~/pixelos-14
cd ~/pixelos-14
repo init -u https://github.com/PixelOS-AOSP/manifest -b fourteen --git-lfs
```

### 2. Clone this device tree

```bash
# Clone this repo into device/google/crosshatch
git clone https://github.com/phoenixdevellopment75-web/pixel-os-crosshatch-port \
    device/google/crosshatch

# Fetch prebuilt kernel (no kernel compile needed!)
bash device/google/crosshatch/scripts/fetch_prebuilt_kernel.sh

# Clone vendor blobs (TheMuppets — no physical device needed)
git clone https://github.com/TheMuppets/proprietary_vendor_google \
    --branch lineage-21.0 --depth 1 \
    vendor/google
```

### 3. Sync sources

```bash
cd ~/pixelos-14
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
```

### 4. Apply patches

```bash
cd ~/pixelos-14
bash device/google/crosshatch/patches/apply_patches.sh
```

### 5. Extract proprietary blobs

```bash
cd ~/pixelos-14/device/google/crosshatch
./extract-files.sh
```

### 6. Build

```bash
cd ~/pixelos-14
. build/envsetup.sh
lunch pixelos_crosshatch-user
make bacon -j$(nproc --all) 2>&1 | tee build.log
```

Output ZIP will be in: `out/target/product/crosshatch/`

---

## 🩹 Patch Information

Patches are located in `patches/` directory:

| Patch | Description |
|-------|-------------|
| `0001-crosshatch-display-notch.patch` | Enable display cutout for Pixel 3 XL notch |
| `0002-crosshatch-wireless-charging.patch` | Enable Qi wireless charging support |
| `0003-crosshatch-nfc-hal.patch` | NFC HAL config for Pixel 3 XL |
| `0004-crosshatch-camera-gcam.patch` | Google Camera (GCam) compatibility |
| `0005-crosshatch-audio-hal.patch` | Audio HAL fixes for crosshatch |
| `0006-crosshatch-pixel-launcher.patch` | Pixel Launcher & At A Glance fixes |
| `0007-crosshatch-selinux-fix.patch` | SELinux policy fixes |
| `0008-crosshatch-thermal.patch` | Thermal engine config for crosshatch |
| `0009-crosshatch-vibrator.patch` | Vibrator HAL for crosshatch |

---

## 📲 Flashing Guide

### Prerequisites
- Unlocked bootloader
- TWRP or any custom recovery installed
- ADB & Fastboot installed on PC

### Steps

1. **Download** the ROM zip from releases
2. **Boot** to recovery (`adb reboot recovery`)
3. **Wipe** Dalvik/ART Cache, Cache, System, Data (**NOT Internal Storage**)
4. **Flash** the ROM zip
5. **Flash** Magisk (optional, for root)
6. **Reboot** — First boot takes 3–5 minutes

```bash
# Flash via fastboot (alternative)
fastboot flash system system.img
fastboot flash vendor vendor.img
fastboot flash boot boot.img
fastboot flash dtbo dtbo.img
fastboot reboot
```

---

## ⚠️ Known Issues

- None currently. Report issues in the [Issues](../../issues) tab.

---

## 🙏 Credits

- [PixelOS Team](https://pixelos.net) — Base ROM
- [Pixel Experience Devices](https://github.com/PixelExperience-Devices) — Kernel base
- [TheMuppets](https://github.com/TheMuppets) — Vendor blobs
- Poco F1 (beryllium) device tree maintainers
- LineageOS crosshatch device tree contributors
- AOSP Google for crosshatch reference trees
