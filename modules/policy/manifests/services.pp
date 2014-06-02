# == Classification: Unclassified (provisional)

class policy::services {

   # Configure redhat systems to ensure that listed services are removed
   $policy_services_ver = "${::operatingsystem}${::operatingsystemrelease}"

   if $policy_services_ver =~ /RedHat5.*/ {
    service {
      'NetworkManager' :
        ensure => 'stopped',
        enable => 'false',
    }
  }

  $systemprofiles = split(extlookup("systemprofile"),':')
  
  # NFS policy
  # Currently only RHEL6 systems
  if $policy_services_ver =~ /RedHat6.*/ {
    case $systemprofiles {
      /nfsserver/ : {
        class {'nfs::client':      stage => pre4}
        class {'nfs::server':  enabled => true,    stage => pre4}
      }   
      default : {
        class {'nfs::client':      stage => pre4}
        class {'nfs::server':  enabled => false,    stage => pre4}
      }
    }
  } else { # Retain the default behaviour
    class {'nfs::client':  stage => pre4}
  }

  
  # Mail Server policy
  # Currently only RHEL6 systems
  if $policy_services_ver =~ /RedHat6.*/ {
    case $systemprofiles {
      /mailserver/: {
        #service {'postfix' : ensure => 'running',enable => 'true',}
        class {'postfix::server':  enabled => 'true'}
      }
      /nomail/: {
        #service {'postfix' : ensure => 'stopped',enable => 'false',}
        class {'postfix::client::service':  enabled => 'false'}
      }
      default : {
        #service {'postfix' : ensure => 'running',enable => 'true',}
        class {'postfix::client':  enabled => 'true'}
      }
    }
  }
  
  # Print Server policy
  # Currently only RHEL6 systems
  if $policy_services_ver =~ /RedHat6.*/ {
    case $systemprofiles {
      /printserver/: {
        service {'cups' : ensure => 'running',enable => 'true',}
      }   
      default : {
        # Ensure CUPS Service is turned off 
        service {'cups' : ensure => 'stopped',enable => 'false',}
        # Remove the port reservation
        #service {'portreserve':ensure => 'running',enable => 'true', }
        file { '/etc/portreserve/cups':
          ensure  => absent,
          #notify  => Service['portreserve']
        }
      }
    }
  }
  
  
  
  
  
  
  
  
}
