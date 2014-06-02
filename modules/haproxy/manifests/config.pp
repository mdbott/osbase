# == Classification: Unclassified (provisional)
#
# Class: haproxy::config
#
#
class haproxy::config {
	if ( $::operatingsystem =~ /(?i)(Debian|Ubuntu)/ ) {
		file { '/etc/default/haproxy':
			ensure  => present,
			owner   => 'root',
			group   => 'root',
			mode    => '0644',
			require => Class["haproxy::install::${haproxy::params::install_mode}"]
		}
		
		augeas { 'enable-haproxy':
			context => '/files/etc/default/haproxy',
			changes => "set ENABLED 1",
			onlyif  => "get ENABLED != 1",
			require => File['/etc/default/haproxy'],
		}
	}
	
	file { '/etc/init.d/haproxy':
		ensure  => present,
		owner   => 'root',
		group   => 'root',
		mode    => '0755',
		source  => "puppet:///modules/haproxy/haproxy-init.${haproxy::params::os_suffix}",
		notify  => Class['haproxy::service'],
		require => Class["haproxy::install::${haproxy::params::install_mode}"]
	}
	
	file { $haproxy::params::configdir:
		ensure  => directory,
		owner   => 'root',
		group   => 'root',
		require => Class["haproxy::install::${haproxy::params::install_mode}"]
	}
	
	include "haproxy::config::${haproxy::params::config_builder}"
}
