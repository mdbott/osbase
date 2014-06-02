# == Classification: Unclassified (provisional)
class configpuppet::master  {
  require configpuppet::params
  require configpuppet::environment
  $puppetenv      = extlookup("environment")
  $puppetmaster   = extlookup("puppetmaster")
  package {
    $configpuppet::params::puppetmaster_package  :
      ensure => installed,
  }
  package {
    $configpuppet::params::puppet_package  :
      ensure => installed,
  }
#  file {
#    '/etc/puppet/puppet.conf' :
#      ensure => 'file',
#      owner => 'root',
#      group => 'root',
#      mode => '644',
#      content => template("configpuppet/puppet.conf.master.erb"),
#      notify => Service['puppet','puppetmaster'],
#      require => Package[$configpuppet::params::puppet_package,$configpuppet::params::puppetmaster_package],
#  }

 file {
    "${configpuppet::params::puppet_conf_path}/puppet.conf" :
      ensure => 'file',
      owner => 'root',
      group => 'root',
      mode => '644',
      content => template("configpuppet/${configpuppet::params::puppet_version}.conf.master.erb"),
      notify => Service['puppetmaster'],
      require => Package[$configpuppet::params::puppet_package,$configpuppet::params::puppetmaster_package],
  }

  service {
    'puppet' :
      name => $configpuppet::params::puppet_service,
      ensure => 'running',
      enable => 'true',
  }
  service {
    'puppetmaster' :
      name => $configpuppet::params::puppetmaster_service,
      ensure => 'running',
      enable => 'true',
  }

  configpuppet::environment::create {"development":
    path    => "${configpuppet::params::puppet_conf_path}/environments/development",
  }
  configpuppet::environment::create {"testing":
    path    => "${configpuppet::params::puppet_conf_path}/environments/testing",
  }
  configpuppet::environment::create {"production":
    path    => "${configpuppet::params::puppet_conf_path}/environments/production",
  }
}


