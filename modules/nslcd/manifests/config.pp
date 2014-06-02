# == Classification: Unclassified (provisional)
#
class nslcd::config{
    file {    
      '/etc/nslcd.conf':
      ensure  => present,
      content => template('nslcd/nslcd.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0600';


    '/etc/pam_ldap.conf':
      ensure  => present,
      content => template('nslcd/pam_ldap.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644'
  }
}