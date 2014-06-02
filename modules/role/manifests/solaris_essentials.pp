# == Classification: Unclassified (provisional)
#
class role::solaris_essentials {
  # Installs modern support tools
  package { 'vim':
    ensure => installed,
    provider  => 'pkgutil'
  }

  package { 'screen':
    ensure => installed,
    provider  => 'pkgutil'
  }

  package { 'gtar':
    ensure => installed,
    provider  => 'pkgutil'
  }
}