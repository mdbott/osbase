# == Classification: Unclassified (provisional)
class configpuppet::environment  {

  require configpuppet::envsetup
	define create ($path,
	               $owner="root",
	               $group="root",
	               $hgpaths={ 'default'=>'ssh://hg.itsupt.dsd//var/www/hg/repos/DSDpuppet'}
	) {
	  file {
    $path :
      path => "${configpuppet::params::puppet_conf_path}/environments/${path}",
      ensure => 'directory',
      owner => $owner,
      group => $group,
      mode => '755',
    }
    exec { "${path}_hginit":
      command   => "hg init",
      cwd       => "${configpuppet::params::puppet_conf_path}/environments/${path}",
      user      => $owner,
      group     => $group,
      provider => shell,
      path    => ['/usr/sbin', '/usr/bin','/opt/csw/bin'],
      creates => "${configpuppet::params::puppet_conf_path}/environments/${path}/.hg",
      require => File[$path]
    }
    if $owner != "root" {
      file {
        "${path}/.hg/hgrc" :
          path    => "${configpuppet::params::puppet_conf_path}/environments/${path}/.hg/hgrc",
          ensure  => 'file',
          owner   => $owner,
          group   => $group,
          content => template("configpuppet/hgrc.erb"),
          mode    => '644',
          require => Exec["${path}_hginit"]
        }
      exec { "${path}_hgmqinit":
        command => "hg qinit -c",
        cwd => "${configpuppet::params::puppet_conf_path}/environments/${path}",
        user      => $owner,
        group     => $group,
        provider => shell,
        path    => ['/usr/sbin', '/usr/bin','/opt/csw/bin'],
        creates => "${configpuppet::params::puppet_conf_path}/environments/${path}/.hg/patches",
        require => File["${path}/.hg/hgrc"]
      }
      file {
        "${path}/.hg/patches/.hg/hgrc" :
            path    => "${configpuppet::params::puppet_conf_path}/environments/${path}/.hg/patches/.hg/hgrc",
            ensure  => 'file',
            owner   => $owner,
            group   => $group,
            content => template("configpuppet/hgrc_mq.erb"),
            mode    => '644',
            require => Exec["${path}_hgmqinit"]
      }
    }
  }
}
