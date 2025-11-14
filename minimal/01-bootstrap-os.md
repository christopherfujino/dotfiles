In virtualbox, from ArchLinux x64 iso with:

- 4GiB of RAM
- 4 CPUs
- 12GiB of storage (we will allocate 4gb to a swap partition)
    - (Partition is better because simpler than swapping to a FS entity)

- Partitions:
    ```
    fdisk /dev/sda

    n # new partition, this will be swap
    # default; primary partition
    # default; partition number 1
    # default first sector
    +4G # 4GiB

    n # new partition, this will be root
    # default; primary partition
    # default; partition number 2
    # default first sector
    # default last sector

    t # change type of partition 1 to swap

    a # make partition 2 bootable

    p # preview changes

    w # write changes
    ```

- format the new partitions:
    ```
    mkswap      /dev/sda1
    mkfs.ext4   /dev/sda2
    ```

- enable swap: `swapon /dev/sda1`
- mount root: `mount /dev/sda2 /mnt`

- curate /etc/pacman.d/mirrorlist from the live system

- bootstrap packages:
    ```
    pacstrap -K /mnt \
        base \
        base-devel \
        curl \
        gcc \
        git \
        grub \
        linux \
        linux-firmware \
        man-db \
        networkmanager \
        openssh \
        sudo \
        vi
    ```

- follow the wiki suckah

- install GRUB:
    ```
    # i386-pc used because you want MBR
    # NOTE: on the DISK, not the partition!
    grub-install --target=i386-pc /dev/sda
    ```

- configure GRUB
    - curate `/etc/default/grub`, or add a script in `/etc/grub.d/`
    - `grub-mkconfig -o /boot/grub/grub.cfg`

- exit the chroot and reboot
