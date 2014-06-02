# == Classification: Unclassified (provisional)
#
# == Class: pkg_management
#
# Setup pkg management under RHEL and Solaris
#
# == Future Directions
#
#
# == Parameters
#
# [*repositories*]
#   Provide an array of repos to enable, defaults to:
#   ['base', 'extra', 'corporate', 'monitoring']
#   Other options include:
#   ['monitoring', 'puppet']
#   OpenCSW only supports ['extra','corporate']
#
# == Variables
#
#
# == Extlookup
#
# [*reposerver*]
#   Server to use for package repository [OpenCSW,yum]
# [*opencswpath*]
#   Path to OpenCSW on reposerver [OpenCSW]
#
# == Examples
#
#   include pkg_management
#
# == Maintainers
#
# SSU
#

class pkg_management(
  $proxy = ''
) {

  tag('bootstrap')

  case $::operatingsystem {
    'Solaris': {
      class { 'pkg_management::opencsw':  }
    }
    'RedHat': {
      class { 'pkg_management::redhat':   }
    }
    'CentOS': {
      class { 'pkg_management::redhat':   }
    }
    default: {
      fail("No package management for this OS is supported")
    }
  }

}
