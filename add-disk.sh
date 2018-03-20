#!/bin/sh
# Usage: add-disk.sh

set -e  # exit on command failure
enable_info_logging=1
enable_debug_logging=0

main() {
    log_info "Adding data disk"
    apt-get update
    apt-get install -y \
        lvm2
    pvcreate /dev/sdb
    vgcreate data /dev/sdb
    lvcreate -n data-lv1 -L 35g data
    mkfs -t ext4 -L data-lv1-fs /dev/data/data-lv1
    mkdir /data
    echo "/dev/data/data-lv1 /data ext4 defaults 0 0" >> /etc/fstab
    mount /data
    if [ -d /var/lib/docker ]; then
        log_info "Moving docker data"
        mv /var/lib/docker /data
    else
        mkdir /data/docker
    fi
    log_info "Linking docker data directory"
    ln -s /data/docker /var/lib/docker
}

log_info() {
    if [ "x$enable_info_logging" = "x1" ]; then
        echo "$1"
    fi
}

log_debug() {
    if [ "x$enable_debug_logging" = "x1" ]; then
        echo "$1"
    fi
}

die() {
    echo "$1" >&2
    exit 1
}

main "$@"
