# == Classification: Unclassified (provisional)
#
class moinmoin3::params{

  $moinmoin3_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    /RedHat6.*/      => 'RedHat',
    /CentOS6.*/      => 'RedHat',
    default          => fail("${::operatingsystem}${::operatingsystemrelease} is not supported"),
  }
}
