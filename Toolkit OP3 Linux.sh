#!/bin/bash
#Checking if android-tools packages are installed. If not, install.
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' android-tools-adb|grep "install ok installed")
echo Checking if android-tools-adb is installed: $PKG_OK
if [ "" == "$PKG_OK" ]; then
  echo "The package android-tools-adb is missing. Type your password for install it."
  sudo apt --force-yes --yes install android-tools-adb
fi
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' android-tools-fastboot|grep "install ok installed")
echo Checking if android-tools-fastboot is installed: $PKG_OK
if [ "" == "$PKG_OK" ]; then
  echo "The package android-tools-fastboot is missing. Type your password for install it."
  sudo apt --force-yes --yes install android-tools-fastboot
fi
#Restarting adb server.
adb kill-server
adb start-server
clear
#Let's show the menu, and perform the operation.
PS3='Enter a number to select an operation: '
options=("Backup Data Your Device" "Restore Data Your Device" "Unlock - ReLock Bootloader" "Check Device Status" "Check Bootloader Status" "Flash TWRP Recovery" "Boot TWRP Recovery" "Flash Stock Recovery" "Push Systemless SuperSU" "Push OxygenOS Debloater" "Reboot Mene" "Wipe Cache Device" "Force Decryption Device [WIPE]" "Change LCD Density On Device" "XDA Thread" "Exit")
select opt in "${options[@]}"
do
	case $opt in
		"Backup Data Your Device")
			echo "You chose to backup the device"
			echo "The backup will be saved on your file toolkit"
			adb backup -apk -shared -all
			ping -n 5 127.0.0.1
			echo "Done!"
			read -p "Press [Enter] key..."
			break
			;;
		"Restore Data Your Device")
			echo "You chose to restore the device"
			echo "The backup will be restored from your file toolkit"
			adb restore backup.ab
			echo "Done!"
			read -p "Press [Enter] key..."
			break
			;;
		"Unlock - ReLock Bootloader")
			echo "You chose to unlock or relock bootloader"
			PS3='You want to unlock or relock bootloader?'
			options=("Unlock bootloader" "Relock bootloader" "Exit")
			select opt in "${options[@]}"
			do
				case $opt in
					"Unlock bootloader")
						clear
						echo "You chose to unlock bootloader"
						echo "ATTENTION! This operation will wipe all of your data! Make sure you have a backup."
						read -p "If you are sure, press [Enter] key..."
						echo "Please wait"
#FIXME adb commands under linux must be done on high privileges. The better way: sudo $(which fastboot) [command].
						adb reboot bootloader
						fastboot oem unlock
						echo "Follow on screen instructions, and you have done."
						read -p "Press [Enter] key..."
						break
						;;
					"Relock bootloader")
						clear
						echo "You chose to relock bootloader"
						echo "ATTENTION! This operation will wipe all of your data! Make sure you have a backup."
						read -p "If you are sure, press [Enter] key..."
						echo "Please wait"
						adb reboot bootloader
						fastboot oem lock
						echo "Follow on screen instructions, and you have done."
						read -p "Press [Enter] key..."
						break
						;;
					"Exit")
						break
						;;
					*) echo Invalid option.;;
				esac
			done
			;;
		"Check Device Status")
			echo "You chose to check device status"
			;;
		"Check Bootloader Status")
			echo "You chose to check bootloader status"
			;;
		"Flash TWRP Recovery")
			echo "You chose to flash TWRP recovery"
			;;
		"Boot TWRP Recovery")
			echo "You chose to boot TWRP recovery"
			;;
		"Flash Stock Recovery")
			echo "You chose to flash stock recovery"
			;;
		"Push Systemless SuperSU")
			echo "You chose to push systemless SuperSU"
			;;
		"Push OxygenOS Debloater")
			echo "You chose to push OxygenOS debloater"
			;;
		"Reboot Mene")
			echo "You chose to reboot mene"
			;;
		"Wipe Cache Device")
			echo "You chose to wipe cache of the device"
			;;
		"Force Decryption Device [WIPE]")
			echo "You chose to force decryption on the device"
			;;
		"Change LCD Density On Device")
			echo "You chose to change LCD density"
			;;
		"XDA Thread")
			echo "You chose to visit XDA thread"
			;;
		"Exit")
			break
			;;
		*) echo Invalid option. Type a number from 1 to 16 please.;;
	esac
done
