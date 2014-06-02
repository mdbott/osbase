# == Classification: Unclassified (provisional)
#
class buildmaster::params{

  $buildmaster_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    /RedHat6.*/      => 'RedHat',
    /CentOS6.*/      => 'RedHat',
    default          => fail("${::operatingsystem}${::operatingsystemrelease} is not supported"),
  }
}
