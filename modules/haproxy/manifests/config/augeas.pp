# == Classification: Unclassified (provisional)
#
# Class: haproxy::config::augeas
#
#
class haproxy::config::augeas {
	include augeas
	
	File {
	}
		
	file { "${haproxy::params::configdir}/haproxy.cfg":
		ensure  => present,
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		notify  => Class['haproxy::service'],
		require => Class['haproxy::config'],
	}

	# Augeas lens
	file { "${::augeas::params::contribdir}/haproxy.aug":
		ensure  => present,
		source  => 'puppet:///modules/haproxy/haproxy.aug',
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		require => [ Class['augeas::config'], Class['haproxy::config'] ],
	}
	
	Haproxy::Augeas {
		require => [ Class['haproxy::config'], File["${::augeas::params::contribdir}/haproxy.aug"] ],
	}
	
	haproxy::augeas { 'managed-by-puppet':
		changes => [
			"ins #comment before global",
			"set global/#comment 'file managed by puppet'"
		],
		notify  => Class['haproxy::service'],
		require => [ Class['haproxy::config'], File["${::augeas::params::contribdir}/haproxy.aug"], Haproxy::Augeas["global"] ],
	}
	
	haproxy::augeas { 'global':
		section => "global",
		changes => [
			"set log[1] '127.0.0.1 local0'",
			"set log[2] '127.0.0.1 local1 notice'",
			"set maxconn 4096",
			"set user ${haproxy::params::user}",
			"set group ${haproxy::params::group}",
			"clear daemon"
		],
		notify  => Class['haproxy::service'],
		require => [ Class['haproxy::config'], File["${::augeas::params::contribdir}/haproxy.aug"] ],
	}
	
	haproxy::augeas { 'defaults':
		section => "defaults",
		changes => [
			"set log global",
			"set mode http",
			"set retries 3",
			"set maxconn 2000",
			"set contimeout 5000",
			"set clitimeout 50000",
			"set srvtimeout 50000"
		],
		notify  => Class['haproxy::service'],
		require => [ Class['haproxy::config'], File["${::augeas::params::contribdir}/haproxy.aug"], Haproxy::Augeas["global"] ],
	}
}
