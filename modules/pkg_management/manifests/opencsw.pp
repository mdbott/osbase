# == Classification: Unclassified (provisional)
#
# Class: pkg_management::opencsw
# Description of class here
#
# == Parameters
#
# [*var1*]
#   parameters the class takes
#
# == Variables
#
# [*common*::*data*::*stuff*]
#   External variables this class uses
#
# == Examples
#
#   include module_template
#   class { 'module_template': var1 => "foo", }
#
class pkg_management::opencsw {

  $repo_server = extlookup('reposerver')
  $repositories = split(extlookup('opencswrepolist'),':')

  package { 'CSWpkgutil':
    ensure => 'installed',
  }
  
  file { '/etc/opt/csw/pkgutil.conf':
    content => template('pkg_management/pkgutil.conf.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'bin',
    require => Package['CSWpkgutil'],
  }

}
