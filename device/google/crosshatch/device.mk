#
# device.mk — Pixel 3 XL (crosshatch)
# PixelOS Android 14 port from Poco F1 (beryllium)
#

DEVICE_PATH := device/google/crosshatch

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(DEVICE_PATH)/overlay

PRODUCT_ENFORCE_RRO_TARGETS := *

# A/B
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

PRODUCT_PACKAGES += \
    otapreopt_script \
    cppreopts.sh \
    update_engine \
    update_verifier \
    update_engine_sideload

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio@7.0-impl \
    android.hardware.audio.effect@7.0-impl \
    android.hardware.audio.service \
    android.hardware.soundtrigger@2.3-impl \
    audio.a2dp.default \
    audio.bluetooth.default \
    audio.r_submix.default \
    audio.usb.default \
    libaudioroute \
    libaudioutils \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libqcompostprocbundle

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(DEVICE_PATH)/audio/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    $(DEVICE_PATH)/audio/audio_output_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_output_policy.conf \
    $(DEVICE_PATH)/audio/mixer_paths_crosshatch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml \
    frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_in_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml

PRODUCT_PROPERTY_OVERRIDES += \
    af.fast_track_multiplier=1 \
    audio.deep_buffer.media=true \
    audio.offload.min.duration.secs=30 \
    audio.offload.video=true \
    ro.af.client_heap_size_kbyte=7168 \
    ro.config.media_vol_steps=25 \
    ro.config.vc_call_vol_steps=7 \
    vendor.audio.offload.buffer.size.kb=32 \
    vendor.audio.offload.gapless.enabled=true

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.1-impl-qti \
    android.hardware.bluetooth@1.1-service-qti

# Camera (GCam support + crosshatch dual front camera)
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.7-service \
    camera.device@3.5-impl \
    libcamera2ndk_vendor

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/camera/camera3_profiles_crosshatch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/camera/camera3_profiles.xml

PRODUCT_PROPERTY_OVERRIDES += \
    persist.camera.HAL3.enabled=1 \
    persist.vendor.camera.privapp.list=com.google.android.GoogleCamera \
    ro.camera.enableCamera1ForExternalCamera=1

# Charger / Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service

# ConfigStore
PRODUCT_PACKAGES += \
    disable_configstore

# Context hub
PRODUCT_PACKAGES += \
    android.hardware.contexthub@1.2-service.generic

# Display
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.4-service \
    android.hardware.graphics.mapper@4.0-impl-qti-display \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    gralloc.sdm845 \
    hwcomposer.sdm845 \
    memtrack.sdm845 \
    libdisplayconfig.qti \
    libqdMetaData

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm@1.4-service.clearkey

# Fingerprint
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint@2.3-service.crosshatch

# Gatekeeper
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service

# GPS / Location
PRODUCT_PACKAGES += \
    android.hardware.gnss@2.1-impl-qti \
    android.hardware.gnss@2.1-service-qti

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/gps.conf:$(TARGET_COPY_OUT_VENDOR)/etc/gps.conf

# HIDL
PRODUCT_PACKAGES += \
    libhidltransport \
    libhwbinder

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.1-service

# Media
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    $(DEVICE_PATH)/configs/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    $(DEVICE_PATH)/configs/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml

# NFC (Pixel 3 XL has NFC — not present on Poco F1)
PRODUCT_PACKAGES += \
    android.hardware.nfc@1.2-service \
    com.android.nfc_extras \
    NfcNci \
    Tag

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/libnfc-nxp.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nxp.conf \
    $(DEVICE_PATH)/configs/libnfc-nxp_RF.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nxp_RF.conf

PRODUCT_PROPERTY_OVERRIDES += \
    ro.nfc.port=I2C

# Neural Networks (NPE/NNAPI)
PRODUCT_PACKAGES += \
    android.hardware.neuralnetworks@1.3-service-qti

# Power
PRODUCT_PACKAGES += \
    android.hardware.power@1.3-service.crosshatch-libperfmgr

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json

# RIL
PRODUCT_PACKAGES += \
    android.hardware.radio@1.6-radio-service \
    android.hardware.radio.config@1.3-radio-service \
    android.hardware.secure_element@1.2-service

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors@2.1-service.multihal

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0-service.qti

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/thermal-engine-crosshatch.conf:$(TARGET_COPY_OUT_VENDOR)/etc/thermal-engine.conf

# Trust/TEE
PRODUCT_PACKAGES += \
    android.hardware.weaver@1.0-impl \
    android.hardware.weaver@1.0-service

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb@1.3-service.cuttlefish

# Vibrator (Pixel 3 XL uses a different vibrator driver than Poco F1)
PRODUCT_PACKAGES += \
    android.hardware.vibrator-service.crosshatch

# Wi-Fi
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.6-service \
    hostapd \
    libwifi-hal-qcom \
    wpa_supplicant \
    wpa_supplicant.conf

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
    $(DEVICE_PATH)/configs/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    $(DEVICE_PATH)/configs/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini

# Wireless Charging (Pixel 3 XL — not on Poco F1)
PRODUCT_PACKAGES += \
    android.hardware.health.storage@1.0-service

PRODUCT_PROPERTY_OVERRIDES += \
    sys.charger.show_percentage=1 \
    ro.wireless.charging.enabled=true

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH) \
    hardware/google/pixel \
    hardware/google/interfaces \
    hardware/qcom/sdm845

# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 28

# Inherit vendor blobs
$(call inherit-product, vendor/google/crosshatch/crosshatch-vendor.mk)
