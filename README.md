# Poor-man-CheckPoint-VPN-DPD
Shell VPN DPD implementation for CheckPoint firewall.

Old CheckPoint software does not support MEP, DPD and permanent tunnels between CP and non-CP devices. This script helps to create a failover configuration for the following topology:

```txt
             / NonCP-FW1 \
Net1 - CPFW -              - Net2
             \ NonCP-FW2 /
```

The script checks if the VPN peer is responding to ping. If not, it checks `ATTEMPT` times with a timeout of `DELAY` seconds, then clears the corresponding IKE SA, and checks again in 60 seconds.

If the firewall is not the Active member of the cluster, nothing happens, the cycle goes to sleep for 600 seconds.
