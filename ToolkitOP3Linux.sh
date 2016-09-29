#!/bin/bash
#Checking if android-tools packages are installed.
if [ -z "$(which adb 2> /dev/null)" ] ; then
  echo ADB is missing. Keep in mind that this script wont work without it. Please install it using: sudo apt install android-tools-adb
read -p "Press [Enter] key..."
fi
if [ -z "$(which fastboot 2> /dev/null)" ] ; then
  echo fastboot is missing. Keep in mind that this script wont work without it. Please install it using: sudo apt install android-tools-fastboot
read -p "Press [Enter] key..."
fi
#Restarting adb server.
adb kill-server
adb start-server
clear
#Let's show the menu, and perform the operations.
PS3='Enter a number to select an operation: '
options=("Backup Data Your Device" "Restore Data Your Device" "Unlock Bootloader" "Relock Bootloader" "Check Bootloader Status" "Flash TWRP Recovery" "Boot TWRP Recovery" "Flash Stock Recovery" "Push SuperSU" "Push OxygenOS Debloater" "Wipe Cache Device" "Exit")
while true; do
	select opt in "${options[@]}"; do 
		case $opt in
			"Backup Data Your Device")
				clear
				echo "You chose to backup the device"
				echo "The backup will be saved on your file toolkit"
				read -p "Press [Enter] key..."
				adb backup -apk -shared -all
				echo "Done!"
				read -p "Press [Enter] key..."
				break
				;;
			"Restore Data Your Device")
				clear
				echo "You chose to restore the device"
				echo "The backup will be restored from your file toolkit"
				read -p "Press [Enter] key..."
				adb restore backup.ab
				echo "Done!"
				read -p "Press [Enter] key..."
				break
				;;
			"Unlock Bootloader")
				clear
				echo "You chose to unlock bootloader"
				echo "ATTENTION! THIS OPERATION WILL WIPE ALL OF YOUR DATA! MAKE SURE YOU HAVE A BACKUP!"
				read -p "If you are sure, press [Enter] key..."
				echo "Please wait"
	#FIXME adb commands under linux must be done on high privileges. The better way: sudo $(which fastboot) [command].
				adb reboot bootloader
				fastboot oem unlock
				echo "Follow on screen instructions, and you have done."
				read -p "Press [Enter] key..."
				break
				;;
			"Relock Bootloader")
				clear
				echo "You chose to relock bootloader"
				echo "ATTENTION! THIS OPERATION WILL WIPE ALL OF YOUR DATA! MAKE SURE YOU HAVE A BACKUP!"
				read -p "If you are sure, press [Enter] key..."
				echo "Please wait"
				adb reboot bootloader
				fastboot oem lock
				echo "Follow on screen instructions, and you have done."
				read -p "Press [Enter] key..."
				break
				;;
			"Check Bootloader Status")
				clear
				echo "You chose to check bootloader status"
				read -p "Press [Enter] key..."
				echo "Rebooting in fastboot mode..."
				adb reboot bootloader
				read -p "If your device is in fastboot mode Press [Enter] key..."
				clear
				echo "Bootloader status is:"
				fastboot oem device-info
				break
				;;
			"Flash TWRP Recovery")
				clear
				echo "You chose to flash TWRP recovery"
				echo "Do you really want to flash TWRP recovery?"
				read -p "Press [Enter] key..."
				clear
				echo "Rebooting in fastboot mode..."
				adb reboot bootloader
				read -p "If your device is in fastboot mode Press [Enter] key..."
				clear
				fastboot flash recovery TWRP_recovery.img
				echo "Done!"
				read -p "Press [Enter] key to boot into TWRP recovery..."
				fastboot boot TWRP_recovery.img
				break
				;;
			"Boot TWRP Recovery")
				clear
				echo "You chose to boot TWRP recovery"
				read -p "Press [Enter] key..."
				fastboot boot TWRP_recovery.img
				echo "Done!"
				read -p "Press [Enter] key..."
				break
				;;
			"Flash Stock Recovery")
				clear
				echo "You chose to flash stock recovery"
				echo "Do you really want to flash stock recovery?"
				read -p "Press [Enter] key..."
				clear
				echo "Rebooting in fastboot mode..."
				adb reboot bootloader
				read -p "If your device is in fastboot mode Press [Enter] key..."
				clear
				fastboot flash recovery Stock_recovery.img
				echo "Done!"
				read -p "Press [Enter] key to boot into stock recovery"
				fastboot boot Stock_recovery.img
				break
				;;
			"Push SuperSU")
				clear
				echo "You chose to push SuperSU"
				read -p "Press [Enter] key..."
				adb push SuperSU.zip /sdcard/
				echo "Done!"
				echo "Rebooting in recovery mode..."
				adb reboot recovery
				read -p "If your device is in recovery mode Press [Enter] key..."
				echo "Now flash SuperSU.zip file, and you have done!"
				read -p "Press [Enter] key..."
				break
				;;
			"Push OxygenOS Debloater")
				clear
				echo "You chose to push OxygenOS debloater"
				read -p "Press [Enter] key..."
				adb push OOS_Debloat.zip /sdcard/
				echo "Done!"
				echo "Rebooting in recovery mode..."
				adb reboot recovery
				read -p "If your device is in recovery mode Press [Enter] key..."
				echo "Now flash OOS_Debloat.zip file, and you have done!"
				read -p "Press [Enter] key..."
				break
				;;
			"Wipe Cache Device")
				clear
				echo "You chose to wipe cache of the device"
				echo "Do you really want to wipe cache?"
				read -p "Press [Enter] key..."
				clear
				echo "Rebooting in fastboot mode..."
				adb reboot bootloader
				read -p "If your device is in fastboot mode Press [Enter] key..."
				clear
				fastboot format cache
				echo "Done!"
				read -p "Press [Enter] key..."
				break
				;;
			"Exit")
				exit 0
				break
				;;
			*) echo Invalid option. Type a number from 1 to 16 please.;;
		esac
	done
	clear
done
