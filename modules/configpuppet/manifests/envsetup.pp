# == Classification: Unclassified (provisional)
class configpuppet::envsetup {
    require configpuppet::params
    file {
      "${configpuppet::params::puppet_conf_path}/environments" :
        ensure => 'directory',
        owner => 'root',
        group => 'root',
        mode => '644',
    }

    if "${::operatingsystem}${::operatingsystemrelease}" == 'Solaris5.10' {
      package { 'CSWmercurial':
        ensure => present,
        provider  => pkgutil,
      }
    } else {
      package { 'mercurial':
        ensure => present,
      }
    }
  }
