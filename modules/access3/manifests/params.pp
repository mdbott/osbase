# == Classification: Unclassified (provisional)
#
class access3::params {
  case $::operatingsystem {
      Solaris: {
        $accessfile = '/etc/users.allow'
        $accesslinetemplate = 'access3/users.allow.line.erb'
        $contentheader = "#%access.conf\n# This file is managed by Puppet.\n# User changes will be destroyed the next time puppet runs.\n"
      }
      /CentOS|RedHat/: {
        $accessfile = '/etc/security/access.conf'
        $accesslinetemplate = 'access3/access.conf.line.erb'
        $contentheader = "#%access.conf\n# This file is managed by Puppet.\n# User changes will be destroyed the next time puppet runs.\n+ : ALL : cron crond :0 tty1 tty2 tty3 tty4 tty5 tty6\n"
      }
      default: {
        fail("Unsupported Operating System: ${::operatingsystem}")
      }
  }
}