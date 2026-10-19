# Docker Swarm ports, reachable only from swarm member IPs.
{
  flake.nixosModules.swarm-firewall = {
    networking.nftables.enable = true;
    networking.firewall.extraInputRules = ''
      ip saddr { 192.168.0.5, 192.168.0.23, 192.168.0.3, 192.168.0.30 } tcp dport { 2377, 7946 } accept
      ip saddr { 192.168.0.5, 192.168.0.23, 192.168.0.3, 192.168.0.30 } udp dport { 4789, 7946 } accept
    '';
  };
}
