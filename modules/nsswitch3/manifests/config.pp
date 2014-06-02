# == Classification: Unclassified (provisional)
#
# == Class: nsswitch3::config
#
# Sets up name services in /etc/nsswitch.conf template defined in nsswitch3::params depending on environment
#
# === Version
#
# 1.0
#
# == Parameters
# [*configtemplate*]
# Template to use based on OS.
#
# === Hiera
#
# N/A
#
# === Templates
#
# nsswitch.conf.RedHat.erb
# nsswitch.conf.Solaris10.erb
# nsswitch.conf.Solaris11.erb
#
# === Maintainers
#
# UPS
#
class nsswitch3::config{
  file { '/etc/nsswitch.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${nsswitch3::configtemplate}"),
    }
}