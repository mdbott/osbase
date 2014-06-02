# == Classification: Unclassified (provisional)
#
class etckeeper::params {

  $etckeeper_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'RedHat6.0'   => 'RedHat6.0',
    'RedHat6.1'   => 'RedHat6.0',
    'RedHat6.2'   => 'RedHat6.0',
    'RedHat6.3'   => 'RedHat6.0',
    'RedHat6.4'   => 'RedHat6.0',
    'RedHat6.5'   => 'RedHat6.0',
    default       => 'UNSUPPORTED'
  }

  if $etckeeper_conf_ver == 'UNSUPPORTED' {
    fail("Version ${::operatingsystemrelease} of ${::operatingsystem} is not explicitly supported")
  }

}
