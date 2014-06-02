# == Classification: Unclassified (provisional)
#
# == Class: keepalived
#
# TODO Description of class here
#
# == Future Directions
#
#
# == Parameters
#
# [*var1*]
#   TODO parameters the class takes
#
# == Variables
#
# [*common*::*data*::*stuff*]
#   TODO External variables this class uses
#
# == Extlookup
#
# [*extvar1*]
#   TODO Variables this class resolves via extlookup()
#
# == Examples
#
#   include TODO
#   class { 'module_template': var1 => "foo", }
#
# == Maintainers
#
# SSU
#
class keepalived($email, $smtp_server = '127.0.0.1') {
  require keepalived::params
  case $keepalived::params::keepalived_conf_ver {
    'RedHat6.0':   { class {'keepalived::redhat60': } }
    'UNSUPPORTED': {
      fail("${::operatingsystem}${::operatingsystemrelease} not supported") }
  }

  include concat::setup

  package {"keepalived":
    ensure => installed;
  }

  concat::fragment {"global_defs":
    target  => "${keepalived::params::keepalived_cfg_location}",
    ensure  => present,
    backup  => false,
    order   => 01,
    content => template("keepalived/global_defs.erb"),
  }

  concat { "${keepalived::params::keepalived_cfg_location}":
    mode    => 644,
    owner   => 'root',
    group   => 'root',
    notify  => Service["keepalived"]
  }

  service { "keepalived":
    ensure => running,
    require => Package["keepalived"],
  }

  # Allows daemons to bind to VIP addresses which are in a BACKUP state
  util::line { "sysctl_ipv4_nonlocal_bind" :
    file => "/etc/sysctl.conf",
    line => "net.ipv4.ip_nonlocal_bind = 1",
    ensure => present,
  }

  exec {'install nonlocal_bind':
    path => "/usr/sbin:/usr/bin:/sbin:/bin",
    user => root,
    command => "/sbin/sysctl -p",
    unless => "/sbin/sysctl -n net.ipv4.ip_nonlocal_bind |grep 1",
    require => Util::Line ['sysctl_ipv4_nonlocal_bind'],
  }

  define vrrp_instance(
    $kind,
    $interface,
    $virtualaddresses,
    $password,
    $virtual_router_id = 10,
    $advert_int = 1,
    $script = 'none',
    $notify_master = 'none',
    $notify_backup = 'none',
    $notify_fault = 'none') {

      concat::fragment {"vrrp_instance_${name}":
        target  => "${keepalived::params::keepalived_cfg_location}",
        ensure  => present,
        backup  => false,
        content => template("keepalived/vrrp_instance.erb"),
        require => Package["keepalived"];
      }

  }

  define vrrp_sync_group(
    $members
  ) {
      concat::fragment {"vrrp_sync_group_${name}":
        target  => "${keepalived::params::keepalived_cfg_location}",
        ensure  => present,
        backup  => false,
        content => template("keepalived/vrrp_sync_group.erb"),
        require => Package["keepalived"];
      }
  }

  define vrrp_script(
    $script,
    $interval = 2,
    $weight   = 2
  ) {
      concat::fragment {"vrrp_script_${name}":
        target  => "${keepalived::params::keepalived_cfg_location}",
        ensure  => present,
        backup  => false,
        content => template("keepalived/vrrp_script.erb"),
        require => Package["keepalived"];
      }
  }
}
