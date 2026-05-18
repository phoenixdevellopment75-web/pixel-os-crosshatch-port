#
# pixelos_crosshatch.mk — PixelOS product definition for Pixel 3 XL
#

# Inherit from AOSP base
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit PixelOS common configuration
$(call inherit-product, vendor/pixelos/config/common_full_phone.mk)

# Inherit device-specific configuration
$(call inherit-product, device/google/crosshatch/device.mk)

# Device identifiers
PRODUCT_DEVICE   := crosshatch
PRODUCT_NAME     := pixelos_crosshatch
PRODUCT_BRAND    := google
PRODUCT_MODEL    := Pixel 3 XL
PRODUCT_MANUFACTURER := Google

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_DEVICE=crosshatch \
    PRODUCT_NAME=crosshatch

# Build fingerprint — use official Pixel 3 XL fingerprint for Play Integrity pass
BUILD_FINGERPRINT := google/crosshatch/crosshatch:14/UP1.231005.007/10754064:user/release-keys

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT) \
    ro.bootimage.build.fingerprint=$(BUILD_FINGERPRINT) \
    ro.vendor.build.fingerprint=$(BUILD_FINGERPRINT) \
    ro.product.device=crosshatch \
    ro.product.model=Pixel\ 3\ XL \
    ro.product.name=crosshatch \
    ro.product.brand=google \
    ro.product.manufacturer=Google \
    ro.build.product=crosshatch \
    ro.build.description=crosshatch-user\ 14\ UP1.231005.007\ 10754064\ release-keys

# GMS / Google Apps (included in PixelOS)
PRODUCT_GMS_CLIENTID_BASE := android-google

# Pixel-specific features
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opa.eligible_device=true \
    ro.recents.grid=false
