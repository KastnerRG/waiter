#!/bin/bash
zfs snapshot -r rpool@$(date + '%Y-%m-%dT%H:%M:%S%:z') >> /var/log/hourly_zfs_snapshots.log 2>&1