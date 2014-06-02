# == Classification: Unclassified (provisional)
#
define util::firewall_port( $port, $protocol = "tcp" ) {
  exec { "open_port_${port}_${protocol}":
    command => "system-config-securitylevel-tui --quiet --port=${port}:${protocol}",
    unless => "grep -q ' -p ${protocol} --dport ${port} -j ACCEPT' /etc/sysconfig/iptables"
  }
}