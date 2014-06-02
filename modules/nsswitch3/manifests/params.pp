# == Classification: Unclassified (provisional)
#
# == Class: nsswitch3
#
# Sets up name services in /etc/nsswitch.conf depending on environment
#
# === Version
#
# 1.0
#
# == Parameters
# [*aliases*]
#  Array of databases to use for the service
# [*automount*]
#  Array of databases to use for the service
# [*bootparams*]
#  Array of databases to use for the service
# [*ethers*]
#  Array of databases to use for the service
# [*group*]
#  Array of databases to use for the service
# [*hosts*]
#  Array of databases to use for the service
# [*netgroup*]
#  Array of databases to use for the service
# [*netmasks*]
#  Array of databases to use for the service
# [*network*]
#  Array of databases to use for the service
# [*passwd*]
#  Array of databases to use for the service
# [*protocols*]
#  Array of databases to use for the service
# [*publickey*]
#  Array of databases to use for the service
# [*rpc*]
#  Array of databases to use for the service
# [*services*]
#  Array of databases to use for the service
# [*shadow*]
#  Array of databases to use for the service
# [*sudoers*]
#  Array of databases to use for the service
#
# === Hiera
#
# [*auth*]
# System authentication method - 'local', 'ldap', 'sss', 'vas', 'winbind'.  Default is 'local'
#
# [*nsswitch3::<service>*]
#   Array of databases to use for the service - 'files', 'ldap' etc.
#
# === Variables
# 
# [*configtemplate*]
# The nsswitch.conf template to used based on OS
#
# [*sys_auth*]
# System authentication method return from hiera. Defaults to 'local'.
#
# === Templates
#
# nsswitch.conf.RedHat.erb
# nsswitch.conf.Solaris10.erb
# nsswitch.conf.Solaris11.erb
#
# === Maintainers
#
# UPS
#
class nsswitch3::params{
  $nsswitch3_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'Solaris5.10'     => 'Solaris10',
    /Solaris10_u*/    => 'Solaris10',
    'Solaris5.11'     => 'Solaris11',
    /RedHat5\.[5-9]/  => 'RedHat5',
    /RedHat6.*/       => 'RedHat6',
    /CentOS6.*/       => 'RedHat6',
    default           => fail("Version ${::operatingsystemrelease} of ${::operatingsystem} is not explicitly supported"),
  }
  
  $configtemplate = "nsswitch3/nsswitch.conf.${nsswitch3_conf_ver}.erb"
  
  $accountsource = hiera("profile::os::base::accountsource","local")
  $encrypted = hiera("profile::os::ldap::encrypted",false)
  
  $sys_auth = "${accountsource}${nsswitch3_conf_ver}${encrypted}" ? {
    /local.*/           => 'local',
    /ldapSolaris.*/     => 'ldap',
    'ldapRedHat5false'  => 'ldap',
    'ldapRedHat5true'   => 'sss',
    'ldapRedHat6false'  => 'ldap',
    'ldapRedHat6true'   => 'sss',
    /adSolaris.*/       => 'winbind',
    /adRedHat5.*/       => 'winbind',
    /adRedHat6.*/       => 'sss',
    #'adRedHat6'        => 'vas',
    /ipaSolaris.*/      => 'ipa',
    /ipaRedHat.*/       => 'ipa',
    default         => fail("Unsupported Account source/ Operation system combination!")
    
    
  }
      
  case $sys_auth {
    
    'local': {
      $auth_attr = ['files']
      $automount = ['files']
      $group     = ['files']
      $netgroup  = ['ldap']
      $passwd    = ['files']
      $printers  = ['user', 'files']
      $prof_attr = ['files']
      $project   = ['files']
      $services  = ['files']
      $shadow    = ['files']
    }
    
    'ldap':  {
      $auth_attr = ['files', 'ldap']
      $automount = ['files', 'ldap']
      $group     = ['files', 'ldap']
      $netgroup  = ['ldap']
      $passwd    = ['files', 'ldap']
      $printers  = ['user', 'files', 'ldap']
      $prof_attr = ['files', 'ldap']
      $project   = ['files', 'ldap']
      $services  = ['files', 'ldap']
      $shadow    = ['files', 'ldap']
    }
        
    'sss':  {
      $auth_attr = ['files', 'sss']
      $automount = ['files', 'sss']
      $group     = ['files', 'sss']
      $netgroup  = ['sss']
      $passwd    = ['files', 'sss']
      $printers  = ['user', 'files', 'sss']
      $prof_attr = ['files', 'sss']
      $project   = ['files', 'sss']
      $services  = ['files', 'sss']
      $shadow    = ['files', 'sss']
    }
            
    'vas':  {
      $auth_attr = ['files']
      $automount = ['files']
      $group     = ['files', 'vas4']
      $netgroup  = ['files']
      $passwd    = ['files', 'vas4']
      $printers  = ['user', 'files']
      $prof_attr = ['files']
      $project   = ['files']
      $services  = ['files']
      $shadow    = ['files']
    }
                
    'winbind':  {
      $auth_attr = ['files']
      $automount = ['files']
      $group     = ['files', 'winbind']
      $netgroup  = ['ldap']
      $passwd    = ['files', 'winbind']
      $printers  = ['user', 'files']
      $prof_attr = ['files']
      $project   = ['files']
      $services  = ['files']
      $shadow    = ['files']
    }
  }

  $aliases    = ['files']
  $bootparams = ['files']
  $ethers     = ['files']
  $hosts      = ['files', 'dns']
  $ipnodes    = ['files']
  $netmasks   = ['files']
  $network    = ['files']
  $protocols  = ['files']
  $publickey  = ['files']
  $rpc        = ['files']
  $sendmailvars = ['files']
  $sudoers    = undef
  $tnrhdb     = ['files']
  $tnrhtp     = ['files']
}