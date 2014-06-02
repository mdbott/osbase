# == Classification: Unclassified (provisional)
#
define pkg_management::reposerver(
  $ensure = present,
  $repository_home = '/var/www/html',
  $repo_extension,

){

  # Create the repo directory
  file{"${repository_home}/${repo_extension}":
    ensure => directory,
  }

  file{"/etc/incron.d/${name}":
    ensure  => $ensure,
    content => template("pkg_management/incrond.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
  }
}
