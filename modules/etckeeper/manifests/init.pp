# == Classification: Unclassified (provisional)
#
# == Class: etckeeper
#
# Sets up etckeeper using hg, daily commits
#
# == Future Directions
#
# Depends on mercurial, assumes its installed. Need to decide
# how we're going to deal with that
#
# == Parameters
#
# [*$vcs_status_email*]
#   If defined, a daily email will be sent to this address if etckeeper vcs status returns a
#   non-zero number of lines - implemented via a root cron.daily entry
#
# == Variables
#
#
# == Extlookup
#
#
# == Examples
#
#   include etckeeper
#
# == Maintainers
#
# SSU
#
class etckeeper ($vcs_status_email = undef) {
  require etckeeper::params
  case $etckeeper::params::etckeeper_conf_ver {
    'RedHat6.0':   { class {'etckeeper::redhat60': vcs_status_email => $vcs_status_email } }
    'UNSUPPORTED': {
      fail("${::operatingsystem}${::operatingsystemrelease} not supported") }
  }
}
