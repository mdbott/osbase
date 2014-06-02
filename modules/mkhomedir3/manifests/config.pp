# == Classification: Unclassified (provisional)
#
class mkhomedir3::config {
  include mkhomedir3::params
  case $mkhomedir3::params::mkhomedir3_conf_ver {
    
    'RedHat6.0': {
      pam3::line{"system-oddjob":      target => '/etc/pam.d/system-auth-ac',  type=>'session',  control=>'optional',  modulepath=>'pam_oddjob_mkhomedir.so',priority=>'315'}
      pam3::line{"password-oddjob":    target => '/etc/pam.d/password-auth-ac',type=>'session',  control=>'optional',  modulepath=>'pam_oddjob_mkhomedir.so',priority=>'315'}
    }
    'RedHat5.0': {
      pam3::line{"system-oddjob":      target => '/etc/pam.d/system-auth-ac',  type=>'session',  control=>'optional',  modulepath=>'pam_oddjob_mkhomedir.so',priority=>'315'}
      pam3::line{"password-oddjob":    target => '/etc/pam.d/password-auth-ac',type=>'session',  control=>'optional',  modulepath=>'pam_oddjob_mkhomedir.so',priority=>'315'}    
    }
    'Solaris10': {
                    file { '/etc/auto_home':
                      ensure  => file,
                      content => template($mkhomedir3::params::configtemplate),
                      backup => true,
                      owner => "root",
                      group => "root",
                      mode => 755
                    }
    }
    'Solaris11': {
                    file { '/etc/auto_home':
                      ensure  => file,
                      content => template($mkhomedir3::params::configtemplate),
                      backup => true,
                      owner => "root",
                      group => "root",
                      mode => 755
                    }      
    }
    
    
  }
  
}