#!/system/bin/sh

mount -o remount,rw /;
mount -o rw,remount /system

# init.d support
if [ ! -e /system/etc/init.d ]; then
   mkdir /system/etc/init.d
   chown -R root.root /system/etc/init.d
   chmod -R 755 /system/etc/init.d
fi

# start init.d
for FILE in /system/etc/init.d/*; do
   sh $FILE >/dev/null
done;

# Set cpu min freq for big and small clusters (400mhz) 
echo '0:400000' > /sys/module/msm_performance/paramaters/cpu_min_freq 
echo '1:400000' > /sys/module/msm_performance/paramaters/cpu_min_freq 
echo '2:400000' > /sys/module/msm_performance/paramaters/cpu_min_freq 
echo '3:400000' > /sys/module/msm_performance/paramaters/cpu_min_freq 
echo '4:400000' > /sys/module/msm_performance/paramaters/cpu_min_freq 
echo '5:400000' > /sys/module/msm_performance/paramaters/cpu_min_freq 
echo '6:400000' > /sys/module/msm_performance/paramaters/cpu_min_freq 
echo '7:400000' > /sys/module/msm_performance/paramaters/cpu_min_freq 
 
# Disable core control thermal 
echo 0 > /sys/module/msm_thermal/core_control/enabled 
 
# Enable core control for big and small cpu clusters 
insmod /system/lib/modules/core_ctl.ko 
#for Big cluster 
echo 2 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 
echo 4 > /sys/devices/system/cpu/cpu4/core_ctl/max_cpus 
echo 68 > /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres 
echo 40 > /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres 
echo 100 > /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms 
echo 1 > /sys/devices/system/cpu/cpu4/core_ctl/is_big_cluster 
#for Small cluster 
echo 2 > /sys/devices/system/cpu/cpu0/core_ctl/min_cpus 
echo 4 > /sys/devices/system/cpu/cpu0/core_ctl/max_cpus 
echo 68 > /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres 
echo 40 > /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres 
echo 100 > /sys/devices/system/cpu/cpu0/core_ctl/offline_delay_ms 
echo 1 > /sys/devices/system/cpu/cpu0/core_ctl/is_big_cluster 
 
# IO disable iostats for sdcard and microsd 
echo '0' > /sys/block/mmcblk0/queue/iostats 
echo '0' > /sys/block/mmcblk0/queue/add_random 
echo '0' > /sys/block/mmcblk1/queue/iostats 
echo '0' > /sys/block/mmcblk1/queue/add_random 
 
# Disable Fsync 
echo 'N' > /sys/module/sync/parameters/fsync_enabled