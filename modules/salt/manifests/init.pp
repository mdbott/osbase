# == Classification: Unclassified (provisional)
#
# == Class: salt
#
# Setup a salt server or client
#
# Then from the server one can:
# - List client public keys:
    # salt-key -L
# - Accept client public keys
#   # salt-key -A
# - Start working on hosts:
#   Ping all hosts
#   # salt '*' test.ping
#   Run uname -a on all hosts
#   # salt '*' cmd.run 'uname -a'
#   Print python version on all hosts
#   # salt '*' cmd.exec_code python 'import sys; print sys.version'
#   List packages that can be updated
#   # salt '*' pkg.list_upgrades
#   Tell specific host to upgrade packages to latest:
#   # salt -L 'elzar.itsupt.defence.ic.gov.au' pkg.upgrade
#   Tell all registered hosts to upgrade:
#   # salt '*' pkg.upgrade
# - Read about all the other functionality:
#   # salt '*' sys.doc
#
# === Parameters
#
# [*saltserver*]
#  Salt server to use
#
# === Examples
#
# # clients:
# class {'salt': saltserver => 'salt.itsupt.defence.ic.gov.au' }
#
# # or a server which is a client to itself:
# class {'salt': saltserver => 'localhost' }
# class {'salt::server': }
#
# === Maintainers
#
# UPS
#
class salt($saltserver) inherits salt::params {

  package { $salt_pkg:
    ensure => installed,
  }

  service { $salt_srv:
    ensure  => running,
    enable  => true,
    require => File[$salt_client_conf],
  }

  file { $salt_client_conf:
    ensure  => present,
    content => inline_template("master: <%= @saltserver %>\n"),
    require => Package[$salt_pkg],
  }

}
