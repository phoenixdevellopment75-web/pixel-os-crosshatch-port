#!/vendor/bin/sh
# init.crosshatch.sh — Runtime hardware setup script for Pixel 3 XL
# Runs post-boot to apply crosshatch-specific tweaks

# ── Display ──────────────────────────────────────────────────────────────────
# Enable OLED-specific color calibration for crosshatch's P-OLED display
setprop persist.sys.sf.color_saturation 1.0
setprop persist.sys.sf.color_mode 9
setprop debug.sf.enable_gl_backpressure 1

# ── Wireless Charging ─────────────────────────────────────────────────────────
# Enable Qi wireless charging (absent on beryllium, native on crosshatch)
if [ -f /sys/class/power_supply/wireless/enable ]; then
    echo 1 > /sys/class/power_supply/wireless/enable
fi

# ── NFC ───────────────────────────────────────────────────────────────────────
# Ensure NFC chip (NXP PN553) is enabled
if [ -f /dev/nq-nci ]; then
    chmod 0666 /dev/nq-nci
fi

# ── CPU Governor Tuning ───────────────────────────────────────────────────────
# Kryo 385 Gold (big) cluster
for cpu in 4 5 6 7; do
    echo schedutil > /sys/devices/system/cpu/cpu${cpu}/cpufreq/scaling_governor
    echo 2803200 > /sys/devices/system/cpu/cpu${cpu}/cpufreq/scaling_max_freq
done

# Kryo 385 Silver (little) cluster
for cpu in 0 1 2 3; do
    echo schedutil > /sys/devices/system/cpu/cpu${cpu}/cpufreq/scaling_governor
    echo 1766400 > /sys/devices/system/cpu/cpu${cpu}/cpufreq/scaling_max_freq
done

# ── GPU ───────────────────────────────────────────────────────────────────────
echo msm-adreno-tz > /sys/class/kgsl/kgsl-3d0/devfreq/governor
echo 710000000 > /sys/class/kgsl/kgsl-3d0/devfreq/max_freq

# ── I/O Scheduler ────────────────────────────────────────────────────────────
for blk in /sys/block/sd*; do
    echo cfq > ${blk}/queue/scheduler
    echo 2 > ${blk}/queue/rq_affinity
done

# ── Vibrator ─────────────────────────────────────────────────────────────────
# crosshatch uses a different vibrator path than beryllium
if [ -f /sys/class/leds/vibrator/activate ]; then
    echo 0 > /sys/class/leds/vibrator/activate
fi

echo "init.crosshatch.sh complete"
