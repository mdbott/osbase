# == Classification: Unclassified (provisional)
#
# == Class: ldapclient::params
# Set up parameters that vary based on platform or distribution.
# 
# === Examples
# class { 'ldapclient::params': }
#
# === Authors
# Andrew Cox <ajcox@dsd>
#
# === Copyright
#
class ldapclient::params {
  
  $ldapclient_conf_ver = "${::operatingsystem}" ? {
    'Solaris'        => 'Solaris',
    default          => fail("${::operatingsystem}${::operatingsystemrelease} is not supported"),
  }

}
