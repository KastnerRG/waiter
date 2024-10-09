#!/bin/bash
NOW=`date +'%Y-%m-%dT%H:%M:%S%:z'` >> /var/log/hourly_zfs_snapshots.log
zfs snapshot -r rpool@$NOW >> /var/log/hourly_zfs_snapshots.log 2>&1
zfs list -t snapshot >> /var/log/hourly_zfs_snapshots.log