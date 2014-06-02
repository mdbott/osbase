# == Classification: Unclassified (provisional)
#
# Class: haproxy::service
#
#
class haproxy::service {
	service { 'haproxy':
		ensure    => running,
		enable    => true,
		hasstatus => true,
		restart   => '/etc/init.d/haproxy reload',
		require   => Class['haproxy::config'],
	}
}
