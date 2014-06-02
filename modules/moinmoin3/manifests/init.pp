# == Classification: Unclassified (provisional)
#
# == Class: moinmoin3
#
# Installs moinmoin, requires a httpd of some description
#
# === Parameters
#
#
# === Hiera
#
# === Examples
#
# include profile::moinmoinserver
#
# === Maintainers
#
# UPS
#
class moinmoin3 {

  package {['moin','xapian-core','xapian-bindings','xapian-bindings-python']:
    ensure => latest,
  }

  file { '/var/www/cgi-bin/moin.wsgi':
    notify => Service['httpd'],
    ensure => 'present',
    source => 'puppet:///modules/moinmoin3/moin.wsgi',
    owner  => root,
    group  => root,
    mode   => 755,
  }

  file { '/var/www/cgi-bin/wikiconfig.py':
    notify => Service['httpd'],
    ensure => 'present',
    source => 'puppet:///modules/moinmoin3/wikiconfig.py',
    owner  => root,
    group  => root,
    mode   => 755,
  }

  file { '/etc/httpd/conf.d/moin.conf':
    notify  => Service['httpd'],
    ensure  => 'present',
    content => template('moinmoin3/moin.conf.erb'),
    owner   => root,
    group   => root,
    mode    => 644,
  }

  file { '/usr/share/moin/data':
    ensure  => directory,
    owner   => apache,
    group   => apache,
    recurse => true,
    require => Package['moin'],
  }

  file { '/usr/share/moin/underlay':
    ensure  => directory,
    owner   => apache,
    group   => apache,
    recurse => true,
    require => Package['moin'],
  }

  # initialise the xapian index to allow searches
  exec { xapianIndexBuild :
    command   => "moin --config-dir=/var/www/cgi-bin --wiki-url=$::fqdn/ index build --mode=rebuild",
    user      => apache,
    group     => apache,
    creates   => '/usr/share/moin/data/cache/xapian/index',
    logoutput => true,
    require   => [ Package['moin'],Package['xapian-core'],Package['xapian-bindings-python'], File['/var/www/cgi-bin/wikiconfig.py'], Exec['installLanguagePack'] ],
  }

  # Install extra pages for moin. Includes all help pages and admin pages
    exec { installLanguagePack :
    command => "python /usr/lib/python2.6/site-packages/MoinMoin/packages.py i /usr/share/moin/underlay/pages/LanguageSetup/attachments/English--all_pages.zip --config-dir=/var/www/cgi-bin/",
    user    => apache,
    group   => apache,
    creates => '/usr/share/moin/underlay/pages/SystemInfo',
    require => Package['moin'],
  }

  # This is a measure to ensure the successful return of the installLanguagePack command.
  # This is required because the --config-dir command is not directing the correct path to the wikiconfig.py file.
  file { '/usr/lib/python2.6/site-packages/MoinMoin/wikiconfig.py':
    ensure  => link,
    target  => '/var/www/cgi-bin/wikiconfig.py',
    require => [ Package['moin'], File['/var/www/cgi-bin/wikiconfig.py'] ],
    before  => Exec['installLanguagePack'],
  }

}
