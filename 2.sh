#!/bin/bash

print_line() {
	printf "%$(tput cols)s\n"|tr ' ' '-'
}

print_title() {
	clear
	print_line
	echo -e "# ${Bold}$1${Reset}"
	print_line
	echo ""
}
arch_chroot() {
	arch-chroot /mnt /bin/bash -c "${1}"
}

#最小安装
install_baseSystem(){
	print_title "install_baseSystem"
        pacstrap /mnt base linux linux-firmware dhcpcd vim neovim
}

#生成标卷文件表
generate_fstab(){
	print_title "generate_fstab"
	genfstab -U /mnt >> /mnt/etc/fstab
}

#配置系统时间,地区和语言
configure_system(){
	print_title "configure_system"
	arch_chroot "ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime"
	arch_chroot "hwclock --systohc --utc"
	arch_chroot "mkinitcpio -p linux"
	echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
	echo "zh_CN.UTF-8 UTF-8" >> /mnt/etc/locale.gen
	arch_chroot "locale-gen"
	echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
}

#安装驱动程序
configrue_drive(){
	print_title "configrue_drive"
        arch_chroot "pacman -S --noconfirm xorg-server xorg-twm xorg-xclock xorg-server -y"
	arch_chroot "pacman -S --noconfirm bumblebee -y"
        arch_chroot "systemctl enable bumblebeed"
        arch_chroot "pacman -S --noconfirm nvidia-dkms nvidia-utils nvidia-settings xf86-input-synaptics -y"        
        #arch_chroot "pacman -S --noconfirm intel-ucode -y"
        arch_chroot "pacman -S --noconfirm amd-ucode -y"
}

#安装网络管理程序
configrue_networkmanager(){
       print_title "configrue_networkmanager"
       arch_chroot "pacman -S --noconfirm iw wireless_tools wpa_supplicant dialog netctl networkmanager networkmanager-openconnect rp-pppoe network-manager-applet net-tools -y"
       arch_chroot "systemctl enable NetworkManager.service"      
}

#安装配置引导程序（efi引导的话，将grub改成grub-efi-x86_64 efibootmgr）
configrue_bootloader(){
       print_title "configrue_bootloader"
       arch_chroot "pacman -S --noconfirm grub efibootmgr os-prober -y"
       arch_chroot "mkdir /boot/EFI/grub"
       #arch_chroot "grub-install --target=i386-pc /dev/sda" #MBR+BIOS启动
       arch_chroot "grub-mkconfig > /boot/EFI/grub/grub.cfg"
       arch_chroot "grub-install --target=x86_64-efi --efi-directory=/boot/EFI" #GPT+UEFI启动
}


#添加本地域名
configure_hostname(){
	print_title "configure_hostname"
	read -p "Hostname [ex: archlinux]: " host_name
	echo "$host_name" > /mnt/etc/hostname
	if [[ ! -f /mnt/etc/hosts.aui ]]; then
	cp /mnt/etc/hosts /mnt/etc/hosts.aui
	else
	cp /mnt/etc/hosts.aui /mnt/etc/hosts
	fi
	arch_chroot "sed -i '/127.0.0.1/s/$/ '${host_name}'/' /etc/hosts"
	arch_chroot "sed -i '/::1/s/$/ '${host_name}'/' /etc/hosts"
	arch_chroot "passwd"
  }
  
#添加本地域名
configure_username(){
        print_title "configure_username"
        read -p "Username [ex: archlinux]: " User
        arch_chroot "pacman -S --noconfirm sudo zsh -y"
        arch_chroot "useradd -m -g users -G wheel -s /bin/zsh $User"
        arch_chroot "passwd $User"
        arch_chroot "sed -i 's/\# \%wheel ALL=(ALL) ALL/\%wheel ALL=(ALL) ALL/g' /etc/sudoers"
	arch_chroot "sed -i 's/\# \%wheel ALL=(ALL) NOPASSWD: ALL/\%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers"
	clear
	print_title "install has been done! please reboot."
}



install_baseSystem
generate_fstab
configure_system
configrue_drive
configrue_networkmanager
configrue_bootloader
configure_hostname
configure_username
