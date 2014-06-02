# == Classification: Unclassified (provisional)
#
# == Class: xymon
#
# Installs and configures xymon agent
#
# == Future Directions
#
#
# == Parameters
#
#
# == Variables
#
#
# == Extlookup
#
# [*hobbitserver*]
#   Hobbit/xymon server to use
# [*raidtype*]
#   RAID type that will be monitored, currently supported options:
#   'hphwraid', 'swraid' (RHEL only)
#
# == Examples
#
#   node X inherits dsdldapnode {
#     class {'pkg_management': stage => pre4 }
#     include xymon
#   }
#
# == Maintainers
#
# SSU
#
class xymon inherits xymon::params {



  case $xymon_conf_ver {
    /RedHat.*/    :   { class {'xymon::redhat': } }
    'Solaris' :   { class {'xymon::solaris10': } }
    'UNSUPPORTED': {
      fail("${::operatingsystem}${::operatingsystemrelease} not supported") }
  }
}
