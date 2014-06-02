# == Classification: Unclassified (provisional)
#
# == Class: sudo3::package
#
# Installs the sudo package based on OS release.
#
# === Parameters
#
# [*packagename*]
# Defines OS specific package name
#
# [*package_provider*]
# Defines OS specific package provider
#
# === Examples
#
# class{'sudo3::package':}
#
# === Hiera
#
# Not applicable
#
#
# === Variables
#
# Not applicable
#
# === Templates
#
# Not applicable
#
# === Maintainers
#
# UPS
#
class sudo3::package{
  package { 'sudo package':
    ensure    => latest,
    name      => "${sudo3::params::packagename}",
    provider  => "${sudo3::params::package_provider}"
  }
}