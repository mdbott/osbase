# == Classification: Unclassified (provisional)
#
class nscd::config{
  # Currently only manage the contents of the nscd.conf file on RedHat system
  if $nscd::params::nscd_conf_ver == 'RedHat' {
    file {'/etc/nscd.conf':
        ensure => present,
        content => template('nscd/nscd.conf.erb'),
        owner  => 'root',
        group  => 'sys',
        mode   => '0644',
    }
  }
}