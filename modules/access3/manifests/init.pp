# == Classification: Unclassified (provisional)
#
# == Class: access3
#
# This configures access to puppet managed  systems via
# /etc/security/access.conf for linux &and/etc/users.allow for solaris.
#
# == Version
#
# 1.0
#
# == Parameters
#
# access::params
#
# == Variables
#
#
# == Examples
#
#   Use Case: a system requires access for all members of the desktop-support
#   netgroup as well as a specific user 'newuser'
#
#   include access3
#   access::allowuser { 'newuser':
#      ensure   => present,
#   }
#   access::allowgroup { 'desktop-support':
#      ensure   => present,
#   }
#
# == Maintainers
#
# Author Name <CAIS-UPS@domain.com>
#
#
class access3 {
  include access3::config
}
