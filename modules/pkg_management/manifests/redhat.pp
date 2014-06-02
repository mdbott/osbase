# == Classification: Unclassified (provisional)
#
# Class: pkg_management::redhat
# Setup yum pkg management under RHEL
#
# == Parameters
#
# [*repositories*]
#   Array of repositories to enable, see your local repo server tree for options
#
# == Variables
#
#
# == Examples
#
#   class { 'pkg_management': repositories => [ 'rhel', 'epel'], }
#
class pkg_management::redhat {

  $repositories = split(extlookup('repolist'),':')

  package { 'yum':
    ensure => installed,
  }
  
  if $pkg_management::proxy {
    file { '/etc/yum.conf':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '644',
      content => template("pkg_management/yum.conf.erb")
    }
    
  }

  define central_yumrepo ($repo = $title) {
    $lowercase_os = inline_template("<%= @operatingsystem.downcase %>")
    $repo_server = extlookup("reposerver")
    yumrepo { "${title}-${::operatingsystemrelease}_${::hardwareisa}":
      descr    => "${repo_server} - ${title} - ${::operatingsystemrelease} - ${::hardwareisa}",
      baseurl  => "http://${repo_server}/unix/${lowercase_os}/repositories/${repo}/${::operatingsystemrelease}_${::hardwareisa}/",
      enabled  => 1,
      gpgcheck => 0,
    }
  }

  central_yumrepo { $repositories:
  }

}
