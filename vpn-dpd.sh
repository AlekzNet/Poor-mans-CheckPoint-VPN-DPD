#!/bin/bash

PEERS="10.0.1.1 10.0.2.1"
ATTEMPTS=5
DELAY=5

peer_test() {
	res=`ping -c 1 -n -q -W$DELAY $ip |  awk '/transmitted/{print $4}'`
	[ $res -eq 0 ] || return 1
	true
}

ismaster() {
	[ `cphaprob state | awk '/(local)/{print $NF}'` = "Active" ] || return true
}

vpn_reset() {
	echo "resetting $ip"
	vpn shell /tunnels/delete/IKE/peer $ip
}

while true
do
	if ismaster; then
		echo "It is the master"
		for ip in $PEERS
		do
			if peer_test; then
				echo "$ip is not reachable"
				warn=1
				while [ $warn -le $ATTEMPTS ]
				do
					if peer_test; then
						(( warn=$warn + 1 ))
					else
						warn=0
						break
					fi
				done
				if [ $warn -ge $ATTEMPTS ]; then
					vpn_reset
				fi
			 else
				echo "$ip is reachable"
			fi

		done
		sleep 60
	else
		echo "It is a slave"
		sleep 600
	fi
done
