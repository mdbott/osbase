# == Classification: Unclassified (provisional)
#
class kerberos::params{
    $kerberos_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'Solaris5.10'    => 'Solaris10',
    /Solaris10_u*/   => 'Solaris10',
    'Solaris5.11'    => 'Solaris11',
    /RedHat5\.[5-9]/ => 'RedHat',
    /RedHat6.*/      => 'RedHat',
    /CentOS6.*/      => 'RedHat',
    default          => fail("${::operatingsystem}${::operatingsystemrelease} is not supported"),
  }

  case $kerberos_conf_ver {
    'Solaris11': {
      $packagename = 'SUNWkrbr'
      $configfile  = '/etc/krb5/krb5.conf'
      $kinitcmd    = '/usr/bin/kinit'
      $keytab      = '/etc/krb5/krb5.keytab'
    }
    'Solaris10': {
      $packagename = 'SUNWkrbr'
      $configfile  = '/etc/krb5/krb5.conf'
      $kinitcmd    = '/usr/bin/kinit'
      $keytab      = '/etc/krb5/krb5.keytab'
    }
    'RedHat': {
      $packagename = ['krb5-libs','krb5-workstation','pam_krb5']
      $configfile  = '/etc/krb5.conf'
      $kinitcmd    = '/usr/bin/kinit'
      $keytab      = '/etc/krb5.keytab'
    }
  }
}