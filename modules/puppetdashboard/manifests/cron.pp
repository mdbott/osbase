# == Classification: Unclassified (provisional)
#
# Cron jobs to cleanup old reports in the puppetdashboard database
class puppetdashboard::cron {
  cron { 'prune_reports':
    command => '/usr/bin/rake -f /usr/share/puppet-dashboard/Rakefile RAILS_ENV=production reports:prune upto=14 unit=day',
    user    => 'root',
    hour  => '17',
    minute  => '0',
    ensure  => present,
  }

  cron { 'optimize_reports':
    command => '/usr/bin/mysql -e "optimize table dashboard_production.reports"',
    user    => 'root',
    hour  => '18',
    minute  => '0',
    ensure  => present,
  }

  cron { 'optimize_resource_statuses':
    command => '/usr/bin/mysql -e "optimize table dashboard_production.resource_statuses"',
    user    => 'root',
    hour  => '19',
    minute  => '0',
    ensure  => present,
  }
}
