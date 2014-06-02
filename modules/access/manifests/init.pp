# == Classification: Unclassified (provisional)
# == Class: access
#
# This configures access to puppet managed  systems via
# /etc/security/access.conf for linux & /etc/users.allow for solaris. As this
# restarts the sshd service it has an implicit dependency on the ssh module.
#
# == Future Directions
#
#
# == Parameters
#
# [*var1*]
#   TODO parameters the class takes
#
# == Variables
#
# [*common*::*data*::*stuff*]
#   TODO External variables this class uses
#
# == Extlookup
#
# [*extvar1*]
#   TODO Variables this class resolves via extlookup()
#
# == Examples
#
#   Use Case: a system requires access for all members of the desktop-support
#   netgroup as well as a specific user 'newuser'
#
#   include access
#   access::allowuser { 'newuser':
#      ensure   => present,
#   }
#   access::allowgroup { 'desktop-support':
#      ensure   => present,
#   }
#
# == Maintainers
#
# SSU
#
class access {
  Class['sshd'] -> Class['access']

  case $::operatingsystem {
      Solaris: { include access::usersallow }
      CentOS: { include access::accessconf }
      RedHat: { include access::accessconf }
    }
}
