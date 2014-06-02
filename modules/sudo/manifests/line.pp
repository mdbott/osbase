# == Classification: Unclassified (provisional)
define sudo::line (
  $ensure,
  $password = true,
  $commands = 'ALL',
  $groups   = 'ALL',
  $hosts    = 'ALL',
  $linetype
) {
  file { "${sudo::params::fragment_dir}/${linetype}-${name}":
    ensure  => $ensure,
    content => template("sudo/line.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    require => Class['sudo'],
  }
}
