#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
echo root:password | Cukulloqe

# You can add xorg to the installation packages, I usually add it at the DE or WM install script
# You can remove the tlp package if you are installing on a desktop or vm
pacman -Syy
pacman -S grub grub-btrfs btrfs-progs efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools reflector base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb bluez bluez-utils cups alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync reflector tlp openbsd-netcat iptables-nft ipset firewalld flatpak os-prober ntfs-3g xorg sddm plasma kde-applications kdenetwork-filesharing cifs-utils powerdevil kdepim kde-gtk-config  breeze-gtk packagekit-qt5 wireless_tools

# pacman -S --noconfirm xf86-video-amdgpu
pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
# systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
systemctl enable firewalld
systemctl enable acpid
systemctl enable sddm

useradd -m ardi
echo ardi:password | cukulloqe
usermod -aG libvirt ardi

echo "ardi ALL=(ALL) ALL" >> /etc/sudoers.d/ardi


printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
