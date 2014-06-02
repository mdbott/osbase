# == Classification: Unclassified (provisional)
#
class ntp::params {
  $ntp_conf_version = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'Solaris5.10'  => 'Solaris5.10',
    /Solaris10_u*/ => 'Solaris5.10',
    'Solaris5.11'  => 'Solaris5.11',
    /RedHat5.*/    => 'RedHat5.0',
    /RedHat6.*/    => 'RedHat6.0',
    /CentOS6.*/    => 'RedHat6.0',
    default        => 'UNSUPPORTED'
  }

  if $ntp_conf_version == 'UNSUPPORTED' {
    fail("Version ${::operatingsystemrelease} of ${::operatingsystem} is not explicitly supported by ntp module")
  }

  case $ntp_conf_version {
      'Solaris5.10': {
        $ntp_package = 'SUNWntpu'
        $ntp_service = 'network/ntp'
        $ntp_configfile = '/etc/inet/ntp.conf'
        $ntp_dhcp_script = undef
      }
      'Solaris5.11': {
        $ntp_package = 'SUNWntpu'
        $ntp_service = 'network/ntp'
        $ntp_configfile = '/etc/inet/ntp.conf'
        $ntp_dhcp_script = undef
      }
      'RedHat5.0': {
        $ntp_package = 'ntp'
        $ntp_service = 'ntpd'
        $ntp_configfile = '/etc/ntp.conf'
        $ntp_dhcp_script = undef
      }
      'RedHat6.0': {
        $ntp_package = 'ntp'
        $ntp_service = 'ntpd'
        $ntp_configfile = '/etc/ntp.conf'
        $ntp_dhcp_script = '/etc/dhcp/dhclient.d/ntp.sh'
      }
    }
}
