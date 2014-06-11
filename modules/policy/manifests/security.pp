# == Classification: Unclassified (provisional)

class policy::security(
  $selinuxstatus='disabled'
) {

  # Configure solaris systems to default to linux md5 hashes  for password
  if $::operatingsystem == 'Solaris' {
    file { '/etc/security/policy.conf':
        ensure => file,
        source  => "puppet:///modules/policy/policy.conf.${::operatingsystem}${::operatingsystemrelease}",
        owner   => 'root',
        group   => 'sys',
        mode    => '0644',
      }
  }

  # Ensure selinux is disabled right now & on boot
  if $::operatingsystem == 'RedHat' or $::operatingsystem == 'CentOS' {
    file { '/etc/selinux/config':
        content => template("policy/selinux_config"),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
    if $selinuxstatus=='enforcing' {
      exec { 'setenforce':
        onlyif  => '/usr/sbin/getenforce | /bin/grep disabled',
        command => '/usr/sbin/setenforce 1',
      }
    }
    else {
      exec { 'setenforce':
        onlyif  => '/usr/sbin/getenforce | /bin/grep Enforcing',
        command => '/usr/sbin/setenforce 0',
      }
   }
  }

  
  # Ensure that the root password does not expire
  
  exec {"unexpireroot":
        command     => $::operatingsystem ?{
                      Solaris => "/usr/bin/passwd -x -1 root",
                      RedHat  => "/usr/bin/chage -M -1 root",
                      CentOS  => "/usr/bin/chage -M -1 root",
                      default => "/bin/true"
                    },
        onlyif      => $::operatingsystem ?{
                      Solaris => 'cat /etc/shadow | cut -d: -f1,5| egrep "root:[0-9]"',
                      RedHat  => '/usr/bin/chage -l root | grep "Password expires" | grep -v never',
                      CentOS  => '/usr/bin/chage -l root | grep "Password expires" | grep -v never',
                      default => "/bin/true"
                      },

      }

}
