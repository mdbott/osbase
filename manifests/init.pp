# == Classification: Unclassified (provisional)
#
# PRIMARY FILEBUCKET
# This configures puppet agent and puppet inspect to back up file contents when
# they run. The Puppet Enterprise console needs this to display file contents
# and differences.

# Define filebucket 'main':
if $::puppetversion =~ /.*Puppet Enterprise 3.*/ {
  filebucket { 'main':
    server => 'puppet',
    path   => false,
  }

  # Make filebucket 'main' the default backup location for all File resources:
  File { backup => 'main' }
}


# Site info 
$extlookup_datadir = "${settings::manifestdir}/extlookup"
#$extlookup_datadir = "/etc/puppet/environments/$environment/manifests/extlookup" Reverted as it breaks standalone mode
$extlookup_precedence = ["hosts/%{fqdn}","systems/%{system}_%{env}","systems/%{system}","domain_%{domain}","common" ]
# Global Defaults
Exec { path => ["/bin", "/sbin", "/usr/bin", "/usr/sbin", "/usr/local/bin", "/usr/local/sbin", "/root/bin"]}

# stage naming convention rules:
# $N is a single digit number
# pre$N runs before main
# post$N runs after main
# if $N < $M, pre$N runs before pre$M
# if $N < $M, post$N runs before post$M
class stages {
  stage { [ 'pre4', 'pre5', 'post4', 'post5' ]: }
  Stage['pre4'] -> Stage['pre5'] -> Stage['main'] -> Stage['post4'] -> Stage['post5']
}
