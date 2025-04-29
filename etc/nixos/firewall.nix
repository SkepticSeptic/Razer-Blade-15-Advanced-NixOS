{ pkgs, ... }:

{




# For most users, it's suggested to omit much of this section as it's configured for hardcore security and may cause networking issues that many users wouldn't know how to fix.

  networking.firewall = {
    enable = true;
	# totally fine to leave blank unless you're hosting stuff/giving others SSH access/know what you're doing
    allowedTCPPorts = []; # TCP ports to open
    allowedUDPPorts = []; # UDP ports to open
    # all outbound traffic is allowed, no need to add 443 to those to connect to google or something

    # the below options are HIGHLY SUGGESTED to be removed for regular users, they are overkill security/anti-recon options that may cause issues if you don't know what you're doing.
    
    #rejectPackets = false; # drop packets instead of rejecting them
    allowPing = false; # drop ICMP pings as well
    
    # the above two (as of 2025-04-08 YYYY-MM-DD) don't do their job so old school firewall stuff it is

    extraCommands = ''
  ############################################################################
  # EARLY SANITY CUT‑OFFS (hit first, save CPU)                              #
  ############################################################################
    # 1.  Axe all fragments – common IDS‑evasion trick
      iptables -I nixos-fw 1 -f -j DROP

    # 2.  NEW TCP packets that aren’t SYNs → bogus half‑opens
      iptables -I nixos-fw 2 -p tcp ! --syn -m conntrack --ctstate NEW -j DROP

    # 3.  Anything conntrack already marked INVALID
      iptables -I nixos-fw 3 -m conntrack --ctstate INVALID -j DROP


  ############################################################################
  # WEIRD‑FLAG SCANS (NULL / XMAS / FIN, etc.)                               #
  ############################################################################
      iptables -I nixos-fw 4 -p tcp --tcp-flags ALL NONE -j DROP        # NULL
      iptables -I nixos-fw 5 -p tcp --tcp-flags ALL ALL -j DROP         # XMAS
      iptables -I nixos-fw 6 -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP # partial XMAS
      iptables -I nixos-fw 7 -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
      iptables -I nixos-fw 8 -p tcp --tcp-flags SYN,RST SYN,RST -j DROP


  ############################################################################
  # SILENCE CLOSED PORTS COMPLETELY (no RSTs)                                #
  ############################################################################
      iptables -I nixos-fw 9 -p tcp --tcp-flags RST RST -j DROP


  ############################################################################
  # SHUT UP UDP — no ICMP “port‑unreachable” chatter                         #
  ############################################################################
      iptables -A nixos-fw -p udp -m conntrack --ctstate NEW -j DROP


  ############################################################################
  # ICMP: KEEP ONLY WHAT YOU ACTUALLY NEED (you said: none)                  #
  ############################################################################
  # Drop ping plus every recon / PMTU type you don’t care about
      for t in echo-request fragmentation-needed source-quench \
               address-mask-request address-mask-reply \
               timestamp-request  timestamp-reply \
               router-solicitation router-advertisement; do
        iptables -A nixos-fw -p icmp --icmp-type $t -j DROP
      done


  ############################################################################
  # OPTIONAL: SYN rate‑limit to protect conntrack table                      #
  # (scanners still just see “filtered” because the final rule is DROP)      #
  ############################################################################
      iptables -A nixos-fw -p tcp --syn -m hashlimit \
               --hashlimit 2/second --hashlimit-burst 6 \
               --hashlimit-mode srcip --hashlimit-name synlim -j RETURN
      iptables -A nixos-fw -p tcp --syn -j DROP
    

#====================[ ipv6 firewall ]====================


    ############################################################################
    # EARLY SANITY CUT‑OFFS (hit first, save CPU)                              #
    ############################################################################
    # 1. Axe all fragments — typical IDS‑evasion trick
      ip6tables -I nixos-fw 1 -m frag -j DROP

    # 2. NEW TCP packets that aren’t SYN → bogus half‑opens
      ip6tables -I nixos-fw 2 -p tcp ! --syn -m conntrack --ctstate NEW -j DROP

    # 3. Anything conntrack already marked INVALID
      ip6tables -I nixos-fw 3 -m conntrack --ctstate INVALID -j DROP


    ############################################################################
    # WEIRD-FLAG SCANS (NULL / XMAS / FIN, etc.)
    ############################################################################
      ip6tables -I nixos-fw 4 -p tcp --tcp-flags ALL NONE -j DROP         # NULL
      ip6tables -I nixos-fw 5 -p tcp --tcp-flags ALL ALL -j DROP          # XMAS
      ip6tables -I nixos-fw 6 -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP  # partial XMAS
      ip6tables -I nixos-fw 7 -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
      ip6tables -I nixos-fw 8 -p tcp --tcp-flags SYN,RST SYN,RST -j DROP


    ############################################################################
    # SILENCE CLOSED PORTS COMPLETELY (no RSTs)
    ############################################################################
      ip6tables -I nixos-fw 9 -p tcp --tcp-flags RST RST -j DROP


    ############################################################################
    # SHUT UP UDP — no “port unreachable” chatter
    ############################################################################
      ip6tables -A nixos-fw -p udp -m conntrack --ctstate NEW -j DROP


    ############################################################################
    # ICMPv6: KEEP ONLY WHAT YOU ACTUALLY NEED
    # (If you block neighbor/RA messages, IPv6 may not work at all.)
    ############################################################################
      for t in echo-request packet-too-big time-exceeded router-solicitation \
               router-advertisement neighbor-solicitation neighbor-advertisement \
               redirect; do
        ip6tables -A nixos-fw -p icmpv6 --icmpv6-type $t -j DROP
      done


    ############################################################################
    # OPTIONAL: SYN rate-limit to protect conntrack table
    ############################################################################
      ip6tables -A nixos-fw -p tcp --syn -m hashlimit \
                --hashlimit 2/second --hashlimit-burst 6 \
                --hashlimit-mode srcip --hashlimit-name synlimv6 -j RETURN
      ip6tables -A nixos-fw -p tcp --syn -j DROP
    '';
  };



}
