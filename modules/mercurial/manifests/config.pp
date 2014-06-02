# == Classification: Unclassified (provisional)
#
class mercurial::config{

  # The previous host study had users accessing over ssh, repos were stored in /export/repositories
  file { '/export/':
    ensure => directory,
  }

  file { '/export/repositories':
    ensure  => link,
    target  => '/var/www/hg/repos/',
    require => [File['/var/www/hg/repos'], File['/export']],
  }

  file { '/var/www/hg/':
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 755,
  }

  file { '/var/www/hg/repos':
    ensure => directory,
    owner  => apache,
    group  => apache,
    mode   => 777,
  }

  file { '/var/www/hg/hgweb.config':
    ensure  => 'present',
    source  => 'puppet:///modules/mercurial/hgweb.config',
    owner   => root,
    group   => root,
    mode    => 755,
    require => File['/var/www/hg'],
  }

  file { '/var/www/hg/hgweb.wsgi':
    ensure  => 'present',
    source  => 'puppet:///modules/mercurial/hgweb.wsgi',
    owner   => root,
    group   => root,
    mode    => 755,
    require => File['/var/www/hg'],
  }

  file { '//usr/lib64/python2.6/site-packages/mercurial/templates/paper/header.tmpl':
    ensure  => 'present',
    source  => 'puppet:///modules/mercurial/header.tmpl',
    owner   => root,
    group   => root,
    mode    => 644,
    require => Package['mercurial']
  }

  file { '/etc/httpd/conf.d/mercurial.conf':
    notify  => Service['httpd'],
    ensure  => 'present',
    content => template('mercurial/mercurial.conf.erb'),
    owner   => root,
    group   => root,
    mode    => 644,
  }

}
