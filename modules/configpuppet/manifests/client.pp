# == Classification: Unclassified (provisional)
class configpuppet::client{
  tag('bootstrap')
  tag('puppet')

  include configpuppet::facts

  require configpuppet::params
  $puppetenv        = extlookup("environment")
  $puppetmaster     = extlookup("puppetmaster")
  $puppetcaserver   = extlookup("puppetcaserver")
  $puppetservice    = extlookup("puppetservice")
  
  # LDAP info for enumerated group lookups
  $ldapencrypt      = extlookup("ldapencrypt")
  $ldapservers      = extlookup("ldapservers")
  if is_array($ldapservers) {
    if $ldapservers[0] =~ /.*\:*/ {
      $firstldap        = split($ldapservers[0],':')
      $firstserver      = $firstldap[0]
    } else {
      $firstserver      = $ldapservers[0]
    }
  } else {
    if $ldapservers =~ /.*\:*/ {
      $firstldap        = split($ldapservers,':')
      $firstserver      = $firstldap[0]
    } else {
      $firstserver      = $ldapservers
    }
  }
#  
  
  
  

  $puppet_package_version  = extlookup("puppet_package_version")
  $facter_package_version  = extlookup("facter_package_version")
  package {
    $configpuppet::params::puppet_package  :
      ensure => $puppet_package_version,
      provider => $configpuppet::params::pkg_provider
  }
  
  package {
    $configpuppet::params::facter_package :
      ensure => 'latest',
      provider => $configpuppet::params::pkg_provider
  }
  File {
      owner => 'root',
      group => 'root',
      mode	=> '644',
  }

  file { "${configpuppet::params::puppet_conf_path}/puppet.conf" :
    ensure  => present,
    content => template("configpuppet/${configpuppet::params::puppet_version}.conf.client.erb"),
    owner   => $configpuppet::params::puppet_owner,
    group   => $configpuppet::params::puppet_group,
    mode    => '644',
    require => Package[$configpuppet::params::puppet_package],
  }

  file {
    "${configpuppet::params::puppet_conf_path}/auth.conf" :
      ensure => 'file',
      source => "puppet:///modules/configpuppet/${configpuppet::params::puppet_version}.auth.conf",
      require => Package[$configpuppet::params::puppet_package],
  }

  file {
    "${configpuppet::params::puppet_conf_path}/namespaceauth.conf" :
      ensure => 'file',
      source => "puppet:///modules/configpuppet/namespaceauth.conf",
      require => Package[$configpuppet::params::puppet_package],
  }

#  configpuppet::scriptable_facts{ 'has_ruby_ldap':
#    content   => template('configpuppet/has_ruby_ldap.erb'),
#  }

  service {
    $configpuppet::params::puppet_service :
      ensure => "${puppetservice}",
      enable => true,
  }
}
