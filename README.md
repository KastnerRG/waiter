# waiter
Waiter configurations

# Manual Bootstrap
1. Install Python
2. Insert `waiter`'s pubkey into `~/.ssh/authorized_hosts`
1. Run `bw unlock --raw`, authenticate with a https://vault.e4e-gateway.ucsd.edu account that has access to `waiter-admin`.
```
bw config server https://vault.e4e-gateway.ucsd.edu
bw login
bw unlock --raw
```
2. Copy the output of the above to the file `~/bw_session`, ensuring that that file has `400` perms afterwards.

