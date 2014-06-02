# == Classification: Unclassified (provisional)
#
# == Class: access3::config
#
# Sets up the header in /etc/users.allow (Solaris) and header/footer in /etc/access.conf (linux).
#
# == Version
#
# 1.0
#
# == Parameters
#
# Uses access3::params
#
# == Maintainers
#
# Author Name <CAIS-UPS@domain.com>
#
class access3::config inherits access3::params
{
  include concat::setup
  
  concat{$access3::params::accessfile:
    owner => root,
    group => root,
    mode  => 440
  }

  concat::fragment{"header":
    target  => $access3::params::accessfile,
    order   => 01,
    content => $contentheader
  }
  
  # For RedHat by default deny access to the system unless specifically allowed
  if $::operatingsystem == 'RedHat' or  $::operatingsystem == 'CentOS' {
    access3::line{"ALL": permission=>'-', origin=>'ALL', priority=>'99' }
  #Allow the root user full access to the system
    access3::allowuser{'root': priority => '05'}
  }
}
