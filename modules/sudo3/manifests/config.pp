# == Classification: Unclassified (provisional)
#
# == Class: sudo3::config
#
# Installs a default sudoers configuration file and a custom sudoers directory.
#
# === Parameters
#
# [*configfile*]
# Defines the path of sudoers file
#
# [*configtemplate*]
# Specifies the template to use for the sudoers file
#
# [*fragment_dir*]
# Specifies the location/path for the diectory holding the custom user/group/netgroup entires
#
# === Examples
#
# class{'sudo3::config':}
#
# === Hiera
#
# Not applicable
#
# === Variables
#
# Not applicable
#
# === Templates
#
# sudoers.erb
# Defines the sudoers file
#
# === Maintainers
#
# UPS
#
class sudo3::config inherits sudo3::params {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0440',
  }
    
  file { "${sudo3::params::configfile}":
    ensure  => file,
    alias   => 'sudoers',
    content => template("${sudo3::params::configtemplate}"),
  }
    
  file { "${sudo3::params::fragment_dir}":
    ensure  => directory,
    purge   => true,
    recurse => true,
    backup  => false,  
  }
  
  if $sudo3::params::sudo_conf_version== 'Solaris' {
      file { "$sudo3::params::configfile2":
        ensure  => present,
        alias   => 'sudoers2',
        content => template('sudo/sudoers.erb'),
      }  

  }
  
}