# == Classification: Unclassified (provisional)
#
class salt::params{

  $salt_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    /RedHat6.*/      => 'RedHat',
    /CentOS6.*/      => 'RedHat',
    default          => fail("${::operatingsystem}${::operatingsystemrelease} is not supported"),
  }

  $salt_pkg = 'salt-minion'
  $salt_server_pkg = 'salt-master'
  $salt_srv = $salt_pkg
  $salt_server_srv = $salt_server_pkg
  $salt_client_conf = '/etc/salt/minion'
  $salt_server_conf = '/etc/salt/master'

}
