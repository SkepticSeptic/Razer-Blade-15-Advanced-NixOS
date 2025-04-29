#!/usr/bin/env bash
# check‑icmp‑waybar.sh

# Bail out early if there’s no active IPv4/6 interface
if ! ip -o addr show up scope global | grep -q .; then
  echo '{"text":"N/A","tooltip":"No active network interfaces","class":"na"}'
  exit 0
fi

# Are BOTH IPv4 and IPv6 echo‑request packets being dropped?
if  sudo iptables  -C nixos-fw -p icmp   --icmp-type echo-request  -j DROP 2>/dev/null \
 && sudo ip6tables -C nixos-fw -p icmpv6 --icmpv6-type echo-request -j DROP 2>/dev/null \
 && systemctl is-active --quiet firewall
then
  # Not reachable ⇒ “no” class
  echo '{"text":"N","tooltip":"ICMP echo blocked – host not ping‑reachable","class":"no"}'
else
  # Reachable ⇒ “yes” class
  echo '{"text":"Y","tooltip":"ICMP echo allowed – host can be pinged","class":"yes"}'
fi
