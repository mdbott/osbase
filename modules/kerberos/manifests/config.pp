# == Classification: Unclassified (provisional)
#
class kerberos::config{

  file {$kerberos::params::configfile:
      ensure => present,
      content => template('kerberos/krb5.conf.erb'),
      owner  => 'root',
      group  => 'sys',
      mode   => '0644',
  }

}