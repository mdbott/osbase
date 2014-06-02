# == Classification: Unclassified (provisional)
define sudo::tagline (
  $ensure,
  $password = true,
  $commands = 'ALL',
  $groups   = 'ALL',
  $hosts    = 'ALL',
  $group
) {
  $namearray = split($name,'-')
  $username = $namearray[0]
  $tagname = $namearray[1]
  if $group {
    $type = 'group'
  } else {
    $type = 'user'
  }
  file { "${sudo::params::fragment_dir}/${type}-${username}-${tagname}":
    ensure  => $ensure,
    content => template("sudo/tagline.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    require => Class['sudo'],
  }
}
