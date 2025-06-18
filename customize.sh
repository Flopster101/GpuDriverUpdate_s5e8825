# Android magisk customize.sh - Mali GPU driver updater

# Gather Information
SOC=$(getprop ro.soc.model)
MODVER=$(grep_prop version $MODPATH/module.prop)
MODVERCODE=$(grep_prop versionCode $MODPATH/module.prop)

# Check for conflicting modules
check_conflicting_modules() {
    if [ -d "/data/adb/modules/gpu_driver_mali" ] && [ -f "/data/adb/modules/gpu_driver_mali/module.prop" ]; then
        ui_print " "
        ui_print " ✗ Error: Conflicting module detected!"
        ui_print " "
        ui_print " Please uninstall old Mali GPU driver module first!"
        ui_print " "
        ui_print " Module found: gpu_driver_mali"
        ui_print " "
        abort " Installation aborted due to module conflict"
    fi
}

# Display Info
ui_print " "
ui_print " Version: $MODVER"
ui_print " Mali GPU driver updater"
ui_print " GPU: Mali G68 MP4"
ui_print " "

# Check for conflicts before proceeding
check_conflicting_modules

# Pause before setting permissions
sleep 1

# Apply permissions for the vendor directory and its subfolders
set_perm_recursive $MODPATH/system/vendor 0 0 0755 0644 u:object_r:same_process_hal_file:s0

# Pause after setting permissions
sleep 1

ui_print " - Success"
ui_print " "
ui_print " - Final step for Mali GPU driver updater"
ui_print " - Please wait..."

# GPU Cache Cleaner
gpu_cache_cleaner() {
    find "$1" -type f -name '*shader*' -exec rm -f {} \;
    if [ -e "$1" ]; then
        :
    else
        echo " - $1 cleared"
    fi
}

gpu_cache_cleaner "/data"
gpu_cache_cleaner "/data/user_de/*shader_cache*/code_cache"

ui_print " "
ui_print " - Please reboot!"
ui_print " "
