# == Classification: Unclassified (provisional)
class configpuppet::params {
  case $::operatingsystem {
      Solaris: {
        $mercurial_package = 'CSWmercurial'
        if $::puppetversion =~ /.*Puppet Enterprise.*/ {
          $puppet_package = 'PUPpuppet'
          $facter_package = 'PUPfacter'
          $puppet_service = 'pe-puppet'
          $puppet_version = 'pe-puppet'
          $puppet_owner   = 'pe-puppet'
          $puppet_group   = 'pe-puppet'
          $puppet_conf_path = '/etc/puppetlabs/puppet'
          $pkg_provider       = sun
        }
        else {
      	  $puppet_package = $puppetversion ? {
      	     /^3.*/   => 'CSWpuppet3',
      	     default => 'CSWpuppet',
      	  }
          $puppet_service = 'cswpuppetd'
          $puppet_version = 'puppet'
          $puppetmaster_package = 'CSWpuppetmaster'
          $facter_package = 'CSWfacter'
          $puppetmaster_service = 'cswpuppetmasterd'
          $puppet_owner               = 'root'
          $puppet_group               = 'root'
          $puppet_conf_path = '/etc/puppet'
          $pkg_provider       = pkgutil
        }
      }
      /(RedHat|CentOS)/: {
        $mercurial_package = 'mercurial-1.9.1-0.x86_64'
        if $::puppetversion =~ /.*Puppet Enterprise.*/ {
          $puppetmaster_package = 'pe-httpd'
          $puppetmaster_service = 'pe-httpd'
          $puppet_version = 'pe-puppet'
          $puppet_package = 'pe-puppet'
          $facter_package = 'pe-facter'
          $puppet_service = 'pe-puppet'
          $puppet_owner   = 'pe-puppet'
          $puppet_group   = 'pe-puppet'
          $puppet_conf_path = '/etc/puppetlabs/puppet'
          $pkg_provider       = yum
      	}
      	else {
      	  $puppetmaster_package       = 'puppet-server'
      	  $puppetmaster_service       = 'puppetmaster'
       	  $puppet_package             = 'puppet'
       	  $facter_package             = 'facter'
       	  $puppet_service             = 'puppet'
       	  $puppet_version             = 'puppet'
       	  $puppet_owner               = 'root'
          $puppet_group               = 'root'
       	  $puppet_conf_path           = '/etc/puppet'
     	    $pkg_provider               = yum
     	  }
      }
  }
}
