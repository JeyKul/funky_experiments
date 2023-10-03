# thermal9810.sh - ReWorked
# !!! THIS SCRIPT WONT MODIFY SYSTEM PARTITIONS !!!
# Termux Needed btw

# Start Logger - Can Be Found At /sdcard/.xxTR.Thermal.Last_Run_Log.txt
echo xxTR Thermal Script - Logger Started > /sdcard/.xxTR.Thermal.Last_Run_Log.txt
echo Start Time - $(date) >> /sdcard/.xxTR.Thermal.Last_Run_Log.txt

# Force Push thermal9810.sh To Termux Local Data Folder (If Exists)
if [ $0 -ne /data/data/com.termux/files/usr/bin/thermal9810 ] 2> /dev/null
then
 if [ $(ls /data/data/com.termux/ | grep files) = files ] 2> /dev/null
 then
 cp $0 /data/data/com.termux/files/usr/bin/thermal9810
 chmod 755 /data/data/com.termux/files/usr/bin/thermal9810
 echo "su -c /data/data/com.termux/files/usr/bin/thermal9810" > /data/data/com.termux/files/usr/bin/thermal
 chmod 755 /data/data/com.termux/files/usr/bin/thermal
 fi
fi
# --- First-Time Setup And Setup Check --- #
# xxTR Local Directory Check
if [ $(ls /sdcard/ | grep xxTR) -ne xxTR ]
then
mkdir /sdcard/xxTR
echo xxTR Local Data Not Found - Running mkdir /sdcard/xxTR >> /sdcard/.xxTR.Thermal.Last_Run_Log.txt
else
echo xxTR Local Data Found >> /sdcard/.xxTR.Thermal.Last_Run_Log.txt
fi

# Make /sdcard/ Current Directory
cd /sdcard/xxTR 

# Check For xxTR.prop
if [ $(cat /sdcard/xxTR/xxTR.prop | grep xxTR.Thermal.PROP_SETUP_DONE= | sed '/s/xxTR.Thermal.PROP_SETUP_DONE=//g') -ne 1 ]
then
echo "Local Properties Not Found - Running touch xxTR.prop && echo xxTR.Thermal.PROP_SETUP_DONE=1 >> xxTR.prop" >> /sdcard/.xxTR.Thermal.Last_Run_Log.txt
touch xxTR.prop
echo xxTR.Thermal.PROP_SETUP_DONE=1 >> xxTR.prop
else
echo "xxTR.prop Found - Proceeding" >> /sdcard/.xxTR.Thermal.Last_Run_Log.txt
fi

# Configure Kernel_NAME And xxTR_Kernel_VERSION And xxTR_Kernel_SUBVERSION
if [ $(cat xxTR.prop | grep Kernel_NAME= | sed 's/Kernel_NAME=//g') = ]
then
clear
echo "First-Time Setup" >> /sdcard/.xxTR.Thermal.Last_Run_Log.txt
echo "What Kernel Are You Using ?
1. xxTR
2. Other"
read Kernel_NAME_Sel
 if [ $Kernel_NAME_Sel = 1 ]
 then
 echo "Kernel_NAME_Sel : Selected xxTR" >> /sdcard/.xxTR.Thermal.Last_Run_Log.txt
 echo Kernel_NAME=xxTR >> xxTR.prop
  if [ $(cat xxTR.prop | grep xxTR_Kernel_VERSION= | sed 's/xxTR_Kernel_VERSION//g') = ]
  then
  clear
  echo "What Version Of xxTR Kernel Are You Using ?
1.V46 And Above
2.V45 And Below"
  read xxTR_Kernel_VERSION_Sel
   if [ $xxTR_Kernel_VERSION_Sel = 1 ]
   then
   echo xxTR_Kernel_VERSION=V46 >> xxTR.prop
    if [ $(cat xxTR.prop | grep xxTR_Kernel_SUBVERSION= | sed 's/xxTR_Kernel_SUBVERSION=//g') = ]
    then
    clear
    echo "What Sub Version Of xxTR V46 Are You Using ?
    1.V46 Beta 3 And Above 
    2.V46 Beta 2 And Below"
    read xxTR_Kernel_SEBVERSION_Sel
     if [ $xxTR_Kernel_SEBVERSION_Sel = 1 ]
     then
     echo "xxTR_Kernel_SUBVERSION_Sel : Selected V46 Beta 3 And Above" >> /sdcard/.xxTR.Thermal.Last_Run_Log.txt
     echo xxTR_Kernel_SUBVERSION=3 >> xxTR.prop
     echo xxTR.Thermal.Use_unlock_freqs=1 >> xxTR.prop
     else
     echo "xxTR_Kernel_SUBVERSION_Sel : Selected V46 Beta 2 And Below" >> /sdcard/.xxTR.Thermal.Last_Run_Log.txt
     echo xxTR_Kernel_SUBVERSION=2 >> xxTR.prop
     fi
    else
    echo "Skipping V46 SUBVERSION Setup" >> /sdcard/.xxTR.Thermal.Last_Run_Log.txt
    fi
   elif [ $xxTR_Kernel_VERSION_Sel = 2 ]
   then
   echo xxTR_Kernel_VERSION=V45 >> xxTR.prop
   echo xxTR.Thermal.Use_unlock_freqs=1 >> xxTR.prop
   else
   echo Worng Input OR Value Out Of Range OR Something Went Wrong
   echo "xxTR_Kernel_VERSION_Sel : ERROR_VALUE_OUT_OF_RANGE , Unknown Input : $xxTR_Kernel_VERSION_sel" >> /sdcard/.xxTR.Thermal.Last_Run_Log.txt
   fi
  fi
 elif [ $Kernel_NAME_Sel = 2 ]
 then
 echo "Kernel_NAME_Sel : Selected Other" >> /sdcard/.xxTR.Thermal.Last_Run_Log.txt
 echo Kernel_NAME=Other >> xxTR.prop
 else
 clear
 echo "Kernel_NAME_Sel : ERROR_VALUE_OUT_OF_RANGE , Unknown Input : $Kernel_NAME_Sel" >> /sdcard/.xxTR.Thermal.Last_Run_Log.txt
 echo Value Out Of Range OR Wrong Input OR Something Went Wrong
 exit
 fi
else
echo Skipping First-Time Setup >> /sdcard/.xxTR.Thermal.Last_Run_Log.txt
fi

# Apply OR Skip unlock_freqs
echo $(cat xxTR.prop | grep xxTR.Thermal.Use_unlock_freqs= | sed 's/xxTR.Thermal.Use_unlock_freqs=//g') > /sys/power/unlock_freqs
echo $(cat xxTR.prop | grep xxTR.Thermal.Use_unlock_freqs= | sed 's/xxTR.Thermal.Use_unlock_freqs=//g') > /sys/devices/platform/17500000.mali/unlock_freqs

# Check If User Can Set Custom Values
if [ $(cat xxTR.prop | grep xxTR.Thermal.Allow_Custom= | sed 's/xxTR.Thermal.Allow_Custom=//g') = 1 ]
then
allow_custom=1
extraline="4.Custom
"
lastmenuitem=4
else
allow_custom=0
lastmenuitem=3
fi

# Main Script
clear
echo "
          _______ _____  
         |__   __|  __ \ 
 __  ____  _| |  | |__) |
 \ \/ /\ \/ / |  |  _  / 
  >  <  >  <| |  | | \ \ 
 /_/\_\/_/\_\_|  |_|  \_\
                         
                         
                
Thermal9810 Mod By @xxmustafacooTR
Re-Modded By @xxrishikcooTR

Choose An Option From 1 - $lastmenuitem
1.Mustafa Edits
2.NightShot TechNoobForSale Edits
3.xxrishikcooTR Edits
$extraline"
read mainmenusel
if [ $mainmenusel = 1 ]
then
clear
echo "
          _______ _____  
         |__   __|  __ \ 
 __  ____  _| |  | |__) |
 \ \/ /\ \/ / |  |  _  / 
  >  <  >  <| |  | | \ \ 
 /_/\_\/_/\_\_|  |_|  \_\
                         

Choose An Option From 1 - 3                
1.Mustafa V0
2.Mustafa V1
3.Mustafa V3"
read mustafamenusel
 if [ $mustafamenusel = 1 ]
 then
 TS_DIR="/data/.tskernel"
 LOG="$TS_DIR/tskernel.log"
    ## Thermal settings
    echo "## -- Thermal settings by ThundeRStormS" >> $LOG;
    # BIG Cluster
    echo "30000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_0_temp  # 20000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_0_hyst   # 5000
    echo "65000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_1_temp  # 55000
    echo "2000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_1_hyst   # 2000
    echo "85000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_2_temp  # 83000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_2_hyst   # 5000
    echo "90000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_3_temp  # 95000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_3_hyst   # 5000
    echo "95000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_4_temp  # 100000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_4_hyst   # 5000
    echo "100000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_5_temp  # 105000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_5_hyst   # 5000
    echo "105000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_6_temp  # 110000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_6_hyst   # 5000
    echo "110000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_7_temp  # 115000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_7_hyst   # 5000
    # MID Cluster
    echo "30000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_0_temp  # 20000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_0_hyst   # 5000
    echo "65000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_1_temp  # 55000
    echo "2000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_1_hyst   # 2000
    echo "85000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_2_temp  # 83000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_2_hyst   # 5000
    echo "90000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_3_temp  # 95000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_3_hyst   # 50000
    echo "90000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_4_temp  # 100000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_4_hyst   # 5000
    echo "100000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_5_temp  # 105000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_5_hyst   # 5000
    echo "105000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_6_temp  # 110000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_6_hyst   # 5000
    echo "110000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_7_temp  # 115000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_7_hyst   # 5000
    # LITTLE Cluster
    echo "30000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_0_temp  # 20000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_0_hyst   # 5000
    echo "80000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_1_temp  # 76000
    echo "2000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_1_hyst   # 2000
    echo "85000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_2_temp  # 83000
    echo "8000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_2_hyst   # 5000
    echo "90000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_3_temp  # 95000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_3_hyst   # 5000
    echo "95000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_4_temp  # 100000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_4_hyst   # 5000
    echo "100000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_5_temp  # 105000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_5_hyst   # 5000
    echo "105000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_6_temp  # 110000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_6_hyst   # 5000
    echo "110000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_7_temp  # 115000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_7_hyst   # 5000
    # GPU
    echo "20000" > /sys/devices/virtual/thermal/thermal_zone3/trip_point_0_temp  # 20000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone3/trip_point_0_hyst   # 5000
    echo "90000" > /sys/devices/virtual/thermal/thermal_zone3/trip_point_1_temp  # 78000
    echo "3000" > /sys/devices/virtual/thermal/thermal_zone3/trip_point_1_hyst   # 2000
    echo "95000" > /sys/devices/virtual/thermal/thermal_zone3/trip_point_2_temp  # 88000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone3/trip_point_2_hyst   # 5000
    echo "100000" > /sys/devices/virtual/thermal/thermal_zone3/trip_point_3_temp  # 105000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone3/trip_point_3_hyst   # 5000
    echo "105000" > /sys/devices/virtual/thermal/thermal_zone3/trip_point_4_temp  # 110000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone3/trip_point_4_hyst   # 5000
    echo "107000" > /sys/devices/virtual/thermal/thermal_zone3/trip_point_5_temp  # 115000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone3/trip_point_5_hyst   # 5000
    echo "109000" > /sys/devices/virtual/thermal/thermal_zone3/trip_point_6_temp  # 115000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone3/trip_point_6_hyst   # 5000
    echo "110000" > /sys/devices/virtual/thermal/thermal_zone3/trip_point_7_temp  # 115000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone3/trip_point_7_hyst   # 5000
    # ISP
    #echo "step_wise" > /sys/devices/virtual/thermal/thermal_zone4/policy
    # NPU
    #echo "step_wise" > /sys/devices/virtual/thermal/thermal_zone5/policy
    # AC
    #echo "step_wise" > /sys/devices/virtual/thermal/thermal_zone6/policy
    # BATTERY
    #echo "step_wise" > /sys/devices/virtual/thermal/thermal_zone7/policy
     ## Devices Misc
    echo "2106000" > /sys/devices/platform/exynos-migov/cl0/cl0_pm_qos_max_freq # -1 CPU1
    echo "2504000" > /sys/devices/platform/exynos-migov/cl1/cl1_pm_qos_max_freq # 2314000 CPU4
    echo "2730000" > /sys/devices/platform/exynos-migov/cl2/cl2_pm_qos_max_freq # 1898000 CPU6
    echo "0" > /sys/devices/virtual/thermal/thermal_zone2/sustainable_power     # 0 CPU0
    echo "700" > /sys/devices/virtual/thermal/thermal_zone1/sustainable_power   # 500 CPU4
    echo "1300" > /sys/devices/virtual/thermal/thermal_zone0/sustainable_power   # 1000 CPU6
    echo "1800" > /sys/devices/virtual/thermal/thermal_zone3/sustainable_power  # 1500 GPU
    # Use RCU_normal instead of RCU_expedited for improved real-time latency, CPU utilization and energy efficiency - TweaksBatteryExtremeX
    echo "1" > /sys/kernel/rcu_expedited
    echo "0" > /sys/kernel/rcu_normal
    echo " " >> $LOG;
    chmod 777 $LOG;
    clear
    echo Done
    sleep 1
    clear
    exit
 elif [ $mustafamenusel = 2 ]
 then
 echo Applying Thermal9810 Mod By @xxmustafacooTR
 echo V1
 echo Current Mode : Safe - Default Mustafa Mod
 KERNEL_DIR="/data/.thundertweaks"
 LOG="$KERNEL_DIR/kernel.log"
    ## Thermal settings
    echo "## -- Thermal settings" >> $LOG;
    # BIG Cluster
    echo "30000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_0_temp  # 20000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_0_hyst   # 5000
    echo "95000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_1_temp  # 55000
    echo "2000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_1_hyst   # 2000
    echo "97000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_2_temp  # 83000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_2_hyst   # 5000
    echo "99000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_3_temp  # 95000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_3_hyst   # 5000
    echo "100000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_4_temp  # 100000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_4_hyst   # 5000
    echo "103000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_5_temp  # 105000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_5_hyst   # 5000
    echo "105000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_6_temp  # 110000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_6_hyst   # 5000
    echo "110000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_7_temp  # 115000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_7_hyst   # 5000
    # LITTLE Cluster
    echo "30000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_0_temp  # 20000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_0_hyst   # 5000
    echo "95000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_1_temp  # 76000
    echo "2000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_1_hyst   # 2000
    echo "97000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_2_temp  # 83000
    echo "8000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_2_hyst   # 5000
    echo "99000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_3_temp  # 95000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_3_hyst   # 5000
    echo "101000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_4_temp  # 100000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_4_hyst   # 5000
    echo "103000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_5_temp  # 105000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_5_hyst   # 5000
    echo "105000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_6_temp  # 110000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_6_hyst   # 5000
    echo "110000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_7_temp  # 115000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_7_hyst   # 5000
    # GPU
    echo "20000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_0_temp  # 20000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_0_hyst   # 5000
    echo "95000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_1_temp  # 78000
    echo "3000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_1_hyst   # 2000
    echo "98000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_2_temp  # 88000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_2_hyst   # 5000
    echo "100000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_3_temp  # 105000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_3_hyst   # 5000
    echo "105000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_4_temp  # 110000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_4_hyst   # 5000
    echo "107000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_5_temp  # 115000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_5_hyst   # 5000
    echo "109000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_6_temp  # 115000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_6_hyst   # 5000
    echo "110000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_7_temp  # 115000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_7_hyst   # 5000
    # ISP
    #echo "step_wise" > /sys/devices/virtual/thermal/thermal_zone3/policy
    # AC
    #echo "step_wise" > /sys/devices/virtual/thermal/thermal_zone4/policy
    # BATTERY
    #echo "step_wise" > /sys/devices/virtual/thermal/thermal_zone5/policy
     ## Devices Misc
     # Check sustainable powers
    # Use RCU_normal instead of RCU_expedited for improved real-time latency, CPU utilization and energy efficiency - TweaksBatteryExtremeX
    echo "1" > /sys/kernel/rcu_expedited
    echo "0" > /sys/kernel/rcu_normal
 clear
 echo Done
 sleep 1
 clear
 exit
 elif [ $mustafamenusel = 3 ]
 then
  echo Applying Thermal9810 Mod By @xxmustafacooTR
 echo Current Mode : Safe - Default Mustafa Mod

    ## Thermal settings
    echo "## -- Thermal settings" >> $LOG;
    # xxmustafacooTR Custom Mods
    echo "1" > /sys/devices/platform/17500000.mali/unlock_freqs  # Unlock GPU
    echo "1" > /sys/power/unlock_freqs   # Unlock CPU
    # BIG Cluster
    echo "20000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_0_temp  # 20000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_0_hyst   # 5000
    echo "75000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_1_temp  # 55000
    echo "2000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_1_hyst   # 2000
    echo "85000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_2_temp  # 83000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_2_hyst   # 5000
    echo "90000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_3_temp  # 95000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_3_hyst   # 5000
    echo "95000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_4_temp  # 100000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_4_hyst   # 5000
    echo "100000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_5_temp  # 105000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_5_hyst   # 5000
    echo "105000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_6_temp  # 110000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_6_hyst   # 5000
    echo "115000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_7_temp  # 115000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_7_hyst   # 5000
    # LITTLE Cluster
    echo "20000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_0_temp  # 20000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_0_hyst   # 5000
    echo "82000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_1_temp 
    echo "2000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_1_hyst   # 2000
    echo "87000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_2_temp 
    echo "2000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_2_hyst   # 5000
    echo "90000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_3_temp 
    echo "2000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_3_hyst   # 5000
    echo "96000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_4_temp 
    echo "2000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_4_hyst   # 5000
    echo "100000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_5_temp
    echo "3000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_5_hyst   # 5000
    echo "110000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_6_temp
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_6_hyst   # 5000
    echo "115000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_7_temp
    echo "6000" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_7_hyst   # 5000
    # GPU
    echo "20000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_0_temp  # 20000
    echo "2000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_0_hyst   # 5000
    echo "95000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_1_temp  # 78000
    echo "2000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_1_hyst   # 2000
    echo "97000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_2_temp  # 88000
    echo "2000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_2_hyst   # 5000
    echo "102000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_3_temp  # 105000
    echo "2000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_3_hyst   # 5000
    echo "104000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_4_temp  # 110000
    echo "2000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_4_hyst   # 5000
    echo "106000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_5_temp  # 115000
    echo "2000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_5_hyst   # 5000
    echo "110000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_6_temp  # 115000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_6_hyst   # 5000
    echo "115000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_7_temp  # 115000
    echo "5000" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_7_hyst   # 5000

    echo " " >> $LOG;
    chmod 777 $LOG;
 clear
 echo Done.
 sleep 1
 clear
 exit
 elif [ $mustafamenusel = back ]
 then
 sh $0
 else
 clear
 echo Wrong Usage , Exiting
 exit
 fi
exit
elif [ $mainmenusel = 2 ]
then
clear
echo "
          _______ _____  
         |__   __|  __ \ 
 __  ____  _| |  | |__) |
 \ \/ /\ \/ / |  |  _  / 
  >  <  >  <| |  | | \ \ 
 /_/\_\/_/\_\_|  |_|  \_\
                         

Choose An Option From 1 - 2              
1.TechNoob V1 - 85°C
2.TechNoob V2 - 95°C
"
read technoobmenusel
 if [ $technoobmenusel = 1 ]
 then
 cthermal=85
 presetname="TechNoob V1"
 elif [ $technoobmenusel = 2 ]
 then
 cthermal=95
 presetname="TechNoob V2"
 elif [ $technoobmenusel = back ]
 then
 sh $0
 else
 echo Wrong Input , Exiting 
 exit
 fi
elif [ $mainmenusel = 3 ]
then
clear
echo "
          _______ _____  
         |__   __|  __ \ 
 __  ____  _| |  | |__) |
 \ \/ /\ \/ / |  |  _  / 
  >  <  >  <| |  | | \ \ 
 /_/\_\/_/\_\_|  |_|  \_\
                         

Choose An Option From 1 - 3                
1.xxrishikcooTR V1 - 100°C
2.xxrishikcooTR V2 - 115°C
"
read xxrishikcooTRmenusel
 if [ $xxrishikcooTRmenusel = 1 ]
 then
 cthermal=100
 presetname="xxrishikcooTR V1"
 elif [ $xxrishikcooTRmenusel = 2 ]
 then
 cthermal=115
 presetname="xxrishikcooTR V2"
 elif [ $xxrishikcooTRmenusel = back ]
 then
 sh $0
 else
 echo Wrong Input , Exiting 
 exit
 fi
elif [ $mainmenusel = 4 ]
then
 if [ $allow_custom = 1 ]
 then
 echo You Have Permission To Set Custom Values
 echo Enter A Value 100-150 Recommended
 read cthermal
 presetname="$cthermal"°c
 else
 echo Wrong Input , Exiting 
 exit
 fi
else
echo Wrong Usage , Exiting 
exit
fi

echo Applying $presetname
sleep 1
# Apply Mod
  # BIG Cluster
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone0/trip_point_0_temp  # 20000
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone0/trip_point_1_temp  # 55000
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone0/trip_point_2_temp  # 83000
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone0/trip_point_3_temp  # 95000
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone0/trip_point_4_temp  # 100000
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone0/trip_point_5_temp  # 105000
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone0/trip_point_6_temp  # 110000
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone0/trip_point_7_temp  # 100000
    # LITTLE Cluster
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone1/trip_point_0_temp  # 20000
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone1/trip_point_1_temp 
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone1/trip_point_2_temp 
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone1/trip_point_3_temp 
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone1/trip_point_4_temp 
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone1/trip_point_5_temp
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone1/trip_point_6_temp
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone1/trip_point_7_temp
    # GPU
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone2/trip_point_0_temp  # 20000
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone2/trip_point_1_temp  # 78000
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone2/trip_point_2_temp  # 88000
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone2/trip_point_3_temp  # 105000
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone2/trip_point_4_temp  # 110000
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone2/trip_point_5_temp  # 100000
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone2/trip_point_6_temp  # 100000
    echo "$cthermal"000 > /sys/devices/virtual/thermal/thermal_zone2/trip_point_7_temp  # 100000
 #Hyst Hiest
    echo "$stockhyst1" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_0_hyst   # 5000
    echo "$stockhyst2" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_1_hyst   # 2000
    echo "$stockhyst3" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_2_hyst   # 5000
    echo "$stockhyst4" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_3_hyst   # 5000
    echo "$stockhyst5" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_4_hyst   # 5000
    echo "$stockhyst6" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_5_hyst   # 5000
    echo "$stockhyst7" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_6_hyst   # 5000
    echo "$stockhyst8" > /sys/devices/virtual/thermal/thermal_zone0/trip_point_7_hyst   # 5000
    echo "$stockhyst9" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_0_hyst   # 5000
    echo "$stockhyst10" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_1_hyst   # 2000
    echo "$stockhyst11" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_2_hyst   # 5000
    echo "$stockhyst12" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_3_hyst   # 5000
    echo "$stockhyst13" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_4_hyst   # 5000
    echo "$stockhyst14" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_5_hyst   # 5000
    echo "$stockhyst15" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_6_hyst   # 5000
    echo "$stockhyst16" > /sys/devices/virtual/thermal/thermal_zone1/trip_point_7_hyst   # 5000
    echo "$stockhyst17" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_0_hyst   # 5000
    echo "$stockhyst18" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_1_hyst   # 2000
    echo "$stockhyst19" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_2_hyst   # 5000
    echo "$stockhyst20" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_3_hyst   # 5000
    echo "$stockhyst21" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_4_hyst   # 5000
    echo "$stockhyst22" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_5_hyst   # 5000
    echo "$stockhyst23" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_6_hyst   # 5000
    echo "$stockhyst24" > /sys/devices/virtual/thermal/thermal_zone2/trip_point_7_hyst   # 5000

# Use OR Skip Custom HYSTs
if [ $(cat xxTR.prop | grep xxTR.Thermal.Use_CUSTOM_HYSTs= | sed 's/xxTR.Thermal.Use_CUSTOM_HYSTs=//g') = 1 ] 2> /dev/null
then
stockhyst1="$cthermal"000
stockhyst2="$cthermal"000
stockhyst3="$cthermal"000
stockhyst4="$cthermal"000
stockhyst5="$cthermal"000
stockhyst6="$cthermal"000
stockhyst7="$cthermal"000
stockhyst8="$cthermal"000
stockhyst9="$cthermal"000
stockhyst10="$cthermal"000
stockhyst11="$cthermal"000
stockhyst12="$cthermal"000
stockhyst13="$cthermal"000
stockhyst14="$cthermal"000
stockhyst15="$cthermal"000
stockhyst16="$cthermal"000
stockhyst17="$cthermal"000
stockhyst18="$cthermal"000
stockhyst19="$cthermal"000
stockhyst20="$cthermal"000
stockhyst21="$cthermal"000
stockhyst22="$cthermal"000
stockhyst23="$cthermal"000
stockhyst24="$cthermal"000
else
stockhyst1=5000
stockhyst2=2000
stockhyst3=5000
stockhyst4=5000
stockhyst5=5000 
stockhyst6=5000
stockhyst7=5000
stockhyst8=5000
stockhyst9=5000
stockhyst10=2000
stockhyst11=5000
stockhyst12=5000
stockhyst13=5000
stockhyst14=3000 
stockhyst15=5000
stockhyst16=6000
stockhyst17=5000
stockhyst18=2000
stockhyst19=5000
stockhyst20=5000 
stockhyst21=5000
stockhyst22=5000
stockhyst23=5000
stockhyst24=5000
fi
echo Done
sleep 1
clear
exit