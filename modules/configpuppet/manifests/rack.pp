# == Classification: Unclassified (provisional)
# Sets up rack for use by passenger and Puppetmaster
class configpuppet::rack($ca_server  = 'yes') {
  $puppet_version_array = split($puppetversion,'[.]')
  $puppet_majorversion = $puppet_version_array[0]
  file { "/etc/puppet/rack/":
    owner   => "root",
    group   => "root",
    mode    => 755,
    ensure  => directory
  }

  file { "/etc/puppet/rack/public":
    owner   => "root",
    group   => "root",
    mode    => 755,
    ensure  => directory,
    require => File["/etc/puppet/rack/"]
  }

  file { "/etc/puppet/rack/tmp":
    owner   => "root",
    group   => "root",
    mode    => 755,
    ensure  => directory,
    require => File["/etc/puppet/rack/"]
  }

  file { "/etc/puppet/rack/config.ru" :
    ensure  => file,
    owner   => "puppet",
    group   => "puppet",
    mode    => 644,
    source => "puppet:///modules/configpuppet/config.ru.${puppet_majorversion}",
    require => File["/etc/puppet/rack/"]
  }

  file { "/etc/httpd/conf.d/puppetmasterd.conf" :
    ensure  => file,
    owner   => "puppet",
    group   => "root",
    mode    => 644,
    content => template("configpuppet/puppetmasterd.conf.erb"),
    require => Package["httpd"]
  }
}
