# == Classification: Unclassified (provisional)
#
class profile::os::local {
  
  case $operatingsystem {

    'RedHat' : {
      class{'nscd::service':  ensure => 'stopped'}
      class{'nslcd::service': ensure => 'stopped'}
      class{'sssd3::service': ensure => 'stopped'}
      service { 'autofs': ensure     => stopped, enable     => false}
    }
    
    'Solaris': {
      class   {'ldapclient::service': ensure => 'stopped'}
      #service { 'autofs': ensure     => stopped, enable     => false}
      
    }
  }
  
  
}