# == Classification: Unclassified (provisional)
class configpuppet::prodmaster( $certname        = 'default',
                                $servername      = 'default',
                                $primary         = 'default',
                                $ca_server       = 'yes',
                                $caclientofself  = 'yes',
                                $environmentdefs = {
  ##########################################
  # Puppet Default Environment Definitions
  ##########################################
    'development'              => { 'path' => "development",
                                    'owner' => 'root',
                                    'group' => 'root',
    },
    'testing'                  => { 'path' => "testing",
                                    'owner' => 'root',
                                    'group' => 'root',
    },
    'production'               => { 'path' => "production",
                                    'owner' => 'root',
                                    'group' => 'root',
    },

   })  {
  tag('bootstrap')
  require configpuppet::params
  require configpuppet::environment
  $puppetenv      = extlookup("environment")
  $puppetmaster   = extlookup("puppetmaster")
  $puppetmasterversion   = extlookup("puppetmasterversion")
  $puppetcaserver = extlookup("puppetcaserver")

  if $certname == "default" {
          $privatekey         = "${configpuppet::params::puppet_conf_path}/ssl/private_keys/${::fqdn}.pem"
          $publiccertificate  = "${configpuppet::params::puppet_conf_path}/ssl/certs/${::fqdn}.pem"
        }
        else {
          $privatekey         = "${configpuppet::params::puppet_conf_path}/ssl/private_keys/${certname}.pem"
          $publiccertificate  = "${configpuppet::params::puppet_conf_path}/ssl/certs/${certname}.pem"
   }

  $environmentpath = "${configpuppet::params::puppet_conf_path}/environments/"

  package {
    $configpuppet::params::puppetmaster_package  :
      ensure => $puppetmasterversion,
      provider => $configpuppet::params::pkg_provider,
  }
  package {
    $configpuppet::params::puppet_package  :
      ensure => installed,
      provider => $configpuppet::params::pkg_provider,
  }
  include apache
  #include httpd::puppetpassenger
  #include httpd::mod_ssl
  class {'configpuppet::rack': ca_server  => $ca_server }



  file { '/etc/puppet/client':
      ensure => directory,
      owner => 'root',
      group => 'root',
      mode => '755',
      }

  exec { "create_puppetmaster_keys" :
    command => "service puppetmaster start && service puppetmaster stop",
    cwd => "/tmp/",
    creates => [ $privatekey, $publiccertificate ],
    require => Package[$configpuppet::params::puppet_package,$configpuppet::params::puppetmaster_package],
    before  => Service['httpd'],
  }

  file {
    "${configpuppet::params::puppet_conf_path}/puppet.conf" :
      ensure => 'file',
      owner => 'root',
      group => 'root',
      mode => '644',
      content => template("configpuppet/${configpuppet::params::puppet_version}.conf.prodmaster.erb"),
      notify => Service['httpd'],
      require => [File['/etc/puppet/client'],Package[$configpuppet::params::puppet_package,$configpuppet::params::puppetmaster_package]],
  }
  service {
    'puppet' :
      name => $configpuppet::params::puppet_service,
      ensure => 'stopped',
      enable => false,
  }


  create_resources(configpuppet::environment::create,$environmentdefs)



}


