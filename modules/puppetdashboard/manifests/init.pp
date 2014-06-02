# == Classification: Unclassified (provisional)
#
# Manages the installation of tomcat6 via yum repo - only available on RHEL6.
# Requires the puppetmaster class to be included.
class puppetdashboard ( $role       = 'MASTER',
                        $primary    = 'default'){
  Class['configpuppet::prodmaster'] -> Class['puppetdashboard']

  include mysql::client
  include mysql::server
  include puppetdashboard::cron

  package { "puppet-dashboard":
    ensure => latest,
  }

  file { "/etc/httpd/conf.d/dashboard-vhost.conf" :
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => 644,
    content => template("puppetdashboard/dashboard-vhost.conf.erb"),
    require => Package["httpd"],
    notify  => Service["httpd"],
  }

  file { "/usr/share/puppet-dashboard/config/database.yml" :
    ensure  => file,
    owner   => "puppet-dashboard",
    group   => "puppet-dashboard",
    mode    => 644,
    content => template("puppetdashboard/database.yml.erb"),
    require => Package["puppet-dashboard"],
    notify  => Service["httpd"],
  }
  file { '/usr/share/puppet-dashboard/log/production.log':
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => '666',
  }
  exec { "create_database" :
    command => "/usr/bin/rake RAILS_ENV=production db:create",
    cwd => "/usr/share/puppet-dashboard/",
    unless => '/usr/bin/mysql -e "use dashboard_production"',
    require => [Package["mysql","puppet-dashboard"], Service["mysqld"],],
  }

  exec { "migrate_database" :
    command => "/usr/bin/rake RAILS_ENV=production db:migrate",
    cwd => "/usr/share/puppet-dashboard/",
    unless => '/usr/bin/mysql -e "use dashboard_production; select * from reports limit 1;"',
    require => [Package["mysql","puppet-dashboard"], Service["mysqld"]],
  }
  if ($role == 'MASTER') {
    service { 'puppet-dashboard-workers':
      ensure => 'running',
      enable => 'true',
      require => Exec['migrate_database'],
    }
  }

}
