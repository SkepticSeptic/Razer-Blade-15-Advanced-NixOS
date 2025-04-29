#!/usr/bin/env bash
# check‑hardening‑sysctl.sh

GREEN='\033[32m'; RED='\033[31m'; NC='\033[0m'

declare -A want=(
  [net.ipv4.conf.all.rp_filter]=1
  [net.ipv4.conf.default.rp_filter]=1
  [net.ipv4.icmp_echo_ignore_broadcasts]=1
  [net.ipv4.conf.all.accept_redirects]=0
  [net.ipv4.conf.all.send_redirects]=0
)

ok=1
for k in "${!want[@]}"; do
  [[ $(<"/proc/sys/${k//./\/}") == "${want[$k]}" ]] || { ok=0; break; }
done

[[ $ok == 1 ]] && echo '{"text":"Y","tooltip":"Kernel security modules loaded","class":"yes"}' || echo '{"text":"N","tooltip":"Kernel security modules not loaded","class":"no"}'
