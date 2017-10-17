# Arch Linux Installation
## System
* UEFI
* single Drive
* Encrypted
* BootLoader: Grub
* Nvidia Graphics
* Wireless Installation
* WM: BSPWM
* Shell: ZSH

## 0. Links
* https://imgur.com/Hokk8sK
* https://gist.github.com/HardenedArray/31915e3d73a4ae45adc0efa9ba458b07

## 1. Boot
* Download ArchLinux
#### Create USB Stick via Linux:
`dd if=i/path/to/archlinux-*.iso of=/dev/sdX bs=16M && sync`
#### If you have nvidia graphics only edit boot mode
* nomodeset

## 2. Setup wifi and system time
#### If necessary change Keyboard layout
`loadkeys de-latin1`
#### Graphical wifi setup
`wifi-menu -o`

`netctl start "profile`
#### If ping works your ready
`ping google.com`
#### Sync time with network
`timedatectl set-ntp true`
#### Check if time is right
`timedatectl status`

## 3. Partiton Disks
#### I will do one EFI, one Boot and one Main (will be encrypted later)
#### Check your Disk names carefull (something like sda, sdb)
`lsblk`
#### Replace X with a, b, c of the Disk you want to choose
`gdisk /dev/sdX`
#### Wipe
`o`

`y`
##### Partition EFI
`n` (new)

ENTER (1)

ENTER (Start Sector)

`100 MiB` (Size)

`EF00` (HexCode)
##### Partition Boot
`n`

ENTER

ENTER

`250 MiB`

ENTER
##### Partition root (left space)
`n`

ENTER

ENTER

ENTER (choose size if u dont want whole disk)

ENTER
#### Show partitions and check
`p`
#### Write out
`w`
#### Format
1 = EFI, 2 = Boot

`mkfs.vfat -F 32 /dev/sdX1`

`mkfs.ext2 /dev/sdX2`

## 4. Encrypt main partiton
#### 3 = Main partition
`cryptsetup -c aes-xts-plain64 -h sha512 -s 512 --use-random luksFormat /dev/sdX3`
#### Type upercase YES
`YES`

Choose Password
#### YourMapperName can be everything but shouldnt be to short
`cryptsetup luksOpen /dev/sdX3 YourMapperName`

`pvcreate /dev/mapper/YourMapperName`

`vgcreate Arch /dev/mapper/YourMapperName`
#### setup little swap
`lvcreate -L +512M Arch -n swap`

`lvcreate -l +100%FREE Arch -n root`

`mkfs.ext4 /dev/mapper/Arch-root`

`mkswap /dev/mapper/Arch-swap`

## 5. Mount Partitions
`mount /dev/mapper/Arch-root /mnt`

`swapon /dev/mapper/Arch-swap`

`mkdir /mnt/boot`

`mount /dev/sdX2 /mnt/boot`

`mkdir /mnt/boot/efi`

`mount /dev/sdX1 /mnt/boot/efi`

## 6. Install base packages
#### you can add installations like vim but its not recommended
`pacstrap /mnt base base-devel grub-efi-x86_64 efibootmgr dialog wpa_supplicant`

## 7. Create fstab
`genfstab -U /mnt >> /mnt/etc/fstab`
#### Check fstab carefully and Change "relatime" to "noatime" on boot and root partition
`nano /mnt/etc/fstab`

## 8. Get into your System
`arch-chroot /mnt /bin/bash`
#### Uncomment your preffered system langugae like en_US
`nano /etc/locale.gen`
#### Load your language
`locale-gen`
#### locale.conf should one have one line with your language
`nano /etc/locale.conf`

LANG=en_US.UTF-8
#### Select your timezone
`tzselect`
#### sync hardware clock to utc time
`hwclock --systohc --utc`

## 9. Set up your User
#### Choose "root" password
`passwd`
#### Choose your hostname
`echo yourHostname > /etc/hostname`
#### add a new User
`useradd -m -G wheel yourName`
#### Choose name for your new User
`passwd yourName`
#### Edit Sudoers to allow all users to sudo
`EDITOR=nano visudo`

'##Uncomment to allow member of group..

%wheel ALL=(ALL) ALL

## 10. set up hooks
`nano /etc/mkinitcpio.conf`

HOOKS="base udev autodetect modconf block keymap encrypt lvm2 resume filesystems keyboard fsck"

`mkinitcpio -p linux`

## 11. Install grub EFI
`grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinux`

`nano /etc/default/grub`

`GRUB_CMDLINE_LINUX="cryptdevice=/dev/sdX3:yourMapperName resume=/dev/mapper/Arch-swap"`

`grub-mkconfig -o /boot/grub/grub.cfg`

## 12. Use your Arch Installation
`exit`
#### Umount all Partitions
`umount -R /mnt`

`swapoff -a`

`reboot`
#### Remove USB Stick with your ISO
#### If everything works fine, you need to unlock your encrpted Partition and can lock in as User now

## 13. Enable multilib to use 32 Bit Compatibility
#### Uncomment following lines
`sudo nano /etc/pacman.conf`

'####Misc options

[multilib]

Include = /etc/pacman.d/mirrorlist

## 14. Add archlinuxfr and yaourt to use aur packages
#### add to pacman.conf at end
`sudo nano /etc/pacman.conf`

[archlinuxfr]

SigLevel = Never

Server = http://repo.archlinux.fr/$arch
#### sync and install yaourt
`sudo pacman -Sy`

`sudo pacman -S yaourt`

## 15. Default video drivers
`sudo pacman -S xf86-video-vesa`

`sudo pacman -S mesa`

`sudo pacman -S xorg-server xorg-xinit xterm`

## 16. Nvidia Drivers
`sudo pacman -S nvidia nvidia-utils nvidia-settings lib32-nvidia-libgl`
#### If you use nvidia and Intel graphics Install bumblebee
`sudo pacman -S bumblebee`

## 17. Init pacman keyring
`sudo pacman-key --init`

`sudo dirmngr`
#### if you can read OK in last line press ctrl+c
`sudo pacman-key -r 962DDE58`

`sudo pacman-key --lsign-key 962DDE58`

## 18. Install zsh
`sudo pacman -S zsh`

`touch ~/.zshrc`

`yaourt prezto-git`

`chsh -s /bin/zsh`

## 19. Install dekstop environment
`sudo pacman -S bspwm sxhkd`
#### Start on boot
`nano ~/.xinitrc`

sxhkd &

exec bspwm
#### you should install a terminal like termite
`sudo pacman -S termite`
#### create some config setup
`mkdir ~/.config`

`mkdir ~/.config/bspwm`

`mkdir ~/.config/sxhkd`
#### here will be your keybinds, you dont need anything now
#### you can copy one later, github is full with it
`nano ~/.config/sxhkd/sxhkdrc`
#### add "Termite" at end of bspwmrc to autostart a Terminal on login
`nano ~/.config/bspwm/bspwmrc`

## 20. Install login manager
`sudo pacman -S lightdm-gtk-greeter`

`systemctl enable lightdm.service`

`reboot`
#### Now lightdm should start and you should be able to login and you should see a terminal
#### now u got a terminal where u can install your favorite browser and load some dotfiles

## 21. Auto connect to wifi
#### install wpa_actiond
`yaourt wpa_actiond`
#### check your wifi interface name
`ip link`
#### enable interface
`systemctl enable netctl-auto@interface.service`

.

.

.

#### Here you go. You done the installation.
#### Check out my git repo to get a list with some cool programs like image viewers, font, ...

# ENJOY :)
