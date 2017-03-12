# Poor-mans-CheckPoint-VPN-DPD
Shell VPN DPD implementation for CheckPoint firewall.

Old CheckPoint software does not support MEP, DPD and permanent tunnels between CP and non-CP devices. This script helps to create a failover configuration for the following topology:

```txt
                             / NonCP-FW1 \
Net1 - CPFW(HA) - Internet -               - Net2
                             \ NonCP-FW2 /
```

The script checks if the VPN peer is responding to ping. If not, it checks `ATTEMPTS` times with a timeout of `DELAY` seconds, then clears the corresponding IKE/IPSec SAs, and checks again in 60 seconds.

If the firewall is not the Active member of the cluster, nothing happens, the cycle goes to sleep for 600 seconds.

On the CheckPoint firewall the tunnels are configured using the Center - Two satellites topology (no explicit MEP).

If the peer IP-addresses are not pingable, vpn-dpd-2.sh can be used. `TESTIP` is the address of a pingable host from Net2. If the host in not reachable, the SA's for both peers get cleared.
