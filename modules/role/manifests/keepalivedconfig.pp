# == Classification: Unclassified (provisional)
#
class role::keepalivedconfig(   $role='MASTER',
				$virtualaddress='170.157.142.216/26',
				$interface="bond0") {
  # Keepalived configuration
  class {'keepalived':             email => "mdbott@dsd.defence.gov.au"}
  keepalived::vrrp_instance {
    "VI":
      kind              => "${role}",
      interface         => "${interface}",
      virtualaddresses  => "${virtualaddress} dev ${interface}",
      password          => "PASSWORD",
      virtual_router_id => "51",
      script            => "chk_haproxy",
      notify_master     => '"/etc/rc.d/init.d/haproxy start"',
      notify_backup     => '"/etc/rc.d/init.d/haproxy stop"',
      notify_fault      => '"/etc/rc.d/init.d/haproxy stop"'
  }
  keepalived::vrrp_script {
    "chk_haproxy":
      script            => '"killall -0 haproxy"',
  }
}
