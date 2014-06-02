# == Classification: Unclassified (provisional)

class policy::environment {

  file { 'root_bashrc':
    ensure => present,
    path   => $::operatingsystem ? {
      'Solaris' => '/.bashrc',
      default   => '/root/.bashrc',
    },
    source => 'puppet:///modules/policy/root_bashrc',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    }

  # Configure the default .bashrc for new accounts to set the correct path
  if $::operatingsystem == 'Solaris' {
    file { '/etc/skel/.profile':
      ensure => 'file',
      source => "puppet:///modules/policy/standard.profile.${::operatingsystem}${::operatingsystemrelease}",
      owner  => 'root',
      group  => 'other',
      mode   => '644',
    }
    file { '/etc/skel/.bashrc':
      ensure => 'file',
      source => 'puppet:///modules/policy/standard.bashrc',
      owner  => 'root',
      group  => 'other',
      mode   => '644',
    }
  }

}
