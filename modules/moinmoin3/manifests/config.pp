# == Classification: Unclassified (provisional)
#
class moinmoin3::config{

  file { '/var/www/cgi-bin/moin.wsgi':
   ensure => 'present',
   source => 'puppet:///modules/moinmoin3/moin.wsgi',
   owner => root,
   group => root,
   mode => 755,
  }

  file { '/var/www/cgi-bin/wikiconfig.py':
   ensure => 'present',
   source => 'puppet:///modules/moinmoin3/wikiconfig.py',
   owner => root,
   group => root,
   mode => 755,
  }

  file { '/etc/httpd/conf.d/moin.conf':
   notify => Service['httpd'], 
   ensure => 'present',
   content => template('moinmoin3/moin.conf.erb'),
   owner => root,
   group => root,
   mode => 644,
  }

}
