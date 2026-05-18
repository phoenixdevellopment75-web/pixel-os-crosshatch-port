#
# BoardConfig.mk — Pixel 3 XL (crosshatch)
# Ported from Poco F1 (beryllium) for PixelOS Android 14
#

DEVICE_PATH := device/google/crosshatch

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := kryo385

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := kryo385

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := sdm845
TARGET_NO_BOOTLOADER := true

# Platform
TARGET_BOARD_PLATFORM := sdm845

# Kernel
BOARD_KERNEL_BASE        := 0x00000000
BOARD_KERNEL_CMDLINE     := console=ttyMSM0,115200n8 \
                            earlycon=msm_geni_serial,0xA84000 \
                            androidboot.hardware=crosshatch \
                            androidboot.console=ttyMSM0 \
                            androidboot.memcg=1 \
                            lpm_levels.sleep_disabled=1 \
                            video=vfb:640x400,bpp=32,memsize=3072000 \
                            msm_rtb.filter=0x237 \
                            service_locator.enable=1 \
                            swiotlb=2048 \
                            firmware_class.path=/vendor/firmware \
                            loop.max_part=7 \
                            androidboot.usbcontroller=a600000.dwc3 \
                            androidboot.selinux=enforcing

BOARD_KERNEL_PAGESIZE         := 4096
BOARD_KERNEL_TAGS_OFFSET      := 0x01E00000
BOARD_RAMDISK_OFFSET          := 0x02000000
BOARD_KERNEL_IMAGE_NAME       := Image.lz4-dtb
TARGET_KERNEL_ARCH            := arm64

# ── Prebuilt kernel ─────────────────────────────────────────────────────────
# Using a prebuilt kernel binary instead of compiling from source.
# This saves ~45 minutes of build time and ~8 GB of disk on GitHub runners.
# To use your own kernel: set TARGET_KERNEL_SOURCE and remove TARGET_PREBUILT_KERNEL.
TARGET_PREBUILT_KERNEL        := $(DEVICE_PATH)/prebuilt/Image.lz4-dtb
BOARD_PREBUILT_DTBOIMAGE      := $(DEVICE_PATH)/prebuilt/dtbo.img

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE     := 67108864       # 64M
BOARD_DTBOIMG_PARTITION_SIZE       := 8388608        # 8M
BOARD_SYSTEMIMAGE_PARTITION_SIZE   := 4294967296     # 4G
BOARD_VENDORIMAGE_PARTITION_SIZE   := 1073741824     # 1G
BOARD_USERDATAIMAGE_PARTITION_SIZE := 10737418240    # 10G
BOARD_CACHEIMAGE_PARTITION_SIZE    := 268435456      # 256M

BOARD_FLASH_BLOCK_SIZE := 262144  # (BOARD_KERNEL_PAGESIZE * 64)

TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4

TARGET_COPY_OUT_VENDOR := vendor

# A/B (seamless) Updates
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS := \
    boot \
    system \
    vendor \
    dtbo \
    vbmeta

# Display
TARGET_SCREEN_DENSITY := 560

# Notch / Display Cutout — Pixel 3 XL specific
TARGET_HAS_NOTCH := true

# APEX image
DEXPREOPT_GENERATE_APEX_IMAGE := true

# Audio
USE_XML_AUDIO_POLICY_CONF := 1
BOARD_USES_ALSA_AUDIO := true
AUDIO_FEATURE_ENABLED_MULTI_VOICE_SESSIONS := true
AUDIO_FEATURE_ENABLED_SND_MONITOR := true
AUDIO_FEATURE_ENABLED_USB_TUNNEL := true
AUDIO_FEATURE_ENABLED_AHAL_EXT := false

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(DEVICE_PATH)/bluetooth/include

# Camera
BOARD_QTI_CAMERA_32BIT_ONLY := false

# Charger
BOARD_CHARGER_ENABLE_SUSPEND := true
HEALTHD_USE_BATTERY_INFO := true

# CNE/DPM
BOARD_USES_QCNE := true

# Crypto
TARGET_HW_DISK_ENCRYPTION := true
TARGET_CRYPTFS_HW_PATH := vendor/qcom/opensource/commonsys/cryptfs_hw

# Dex
ifeq ($(HOST_OS),linux)
  ifneq ($(TARGET_BUILD_VARIANT),eng)
    WITH_DEXPREOPT := true
  endif
endif

# DRM
TARGET_ENABLE_MEDIADRM_64 := true

# Filesystem
TARGET_FS_CONFIG_GEN := $(DEVICE_PATH)/config.fs

# GPS
BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := default
GNSS_HIDL_VERSION := 2.1
LOC_HIDL_VERSION := 4.0

# Graphics
TARGET_USES_GRALLOC1 := true
TARGET_USES_HWC2 := true
TARGET_USES_ION := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 2

# HIDL
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := \
    $(DEVICE_PATH)/device_framework_matrix.xml
DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(DEVICE_PATH)/compatibility_matrix.xml

# NFC — Pixel 3 XL has NFC
BOARD_NFC_CHIPSET  := pn553
BOARD_NFC_HAL_SUFFIX := $(TARGET_BOARD_PLATFORM)

# Partitions (super / dynamic — for Android 10+)
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false
BOARD_USES_METADATA_PARTITION := true

# Power
TARGET_USES_INTERACTION_BOOST := true

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := "BGRA_8888"
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.hardware
BOARD_INCLUDE_RECOVERY_DTBO := true

# Releasetools
TARGET_RELEASETOOLS_EXTENSIONS := $(DEVICE_PATH)

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

# Security patch level
VENDOR_SECURITY_PATCH := 2024-01-05

# SELinux
include device/qcom/sepolicy_vndr/SEPolicy.mk
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/system

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)

# Treble
BOARD_VNDK_VERSION := current
PRODUCT_FULL_TREBLE_OVERRIDE := true

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

# Wi-Fi
BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_DRIVER_DEFAULT := qca_cld3
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
WPA_SUPPLICANT_VERSION := VER_0_8_X
