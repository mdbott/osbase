# == Classification: Unclassified (provisional)
#
class pam3::params{

  $pam3_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'Solaris5.10'    => 'Solaris10',
    /Solaris10_u*/=> 'Solaris10',
    'Solaris5.11'    => 'Solaris11',
    /Solaris11_u*/=> 'Solaris11',
    /RedHat5\.[5-9]/ => 'RedHat5',
    /RedHat6.*/      => 'RedHat6',
    /CentOS6.*/      => 'RedHat6',
    default          => fail("${::operatingsystem}${::operatingsystemrelease} is not supported"),
  }
  $accountsource = hiera("profile::os::base::accountsource","local")
  $encrypted     = hiera("profile::os::ldap::encrypted",false)
  $accesscontrol = hiera("profile::os::base::accesscontrol",true)
  
  $sys_auth = "${accountsource}${pam3_conf_ver}${encrypted}" ? {
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
}
