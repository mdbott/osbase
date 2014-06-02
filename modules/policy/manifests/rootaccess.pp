# == Classification: Unclassified (provisional)

class policy::rootaccess {

  # Disable access to the root account via 
  if $operatingsystem == 'Solaris' {
    file { '/usr/bin/su':
      ensure  => 'file',
      owner   => root,
      group   => root,
      mode    => '0555',

    }
    
  }

  # Ensure selinux is disabled right now & on boot
  if $operatingsystem == 'RedHat' or $operatingsystem == 'CentOS' {
    file { '/bin/su':
      ensure  => 'file',
      owner   => root,
      group   => root,
      mode    => '0755',
    }

  }

}