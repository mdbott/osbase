# == Classification: Unclassified (provisional)
#
define admin_users3::extendeduser (
  $uid,
  $gid,
  $groups='',
  $comment,
  $pass='',
  $shell='/bin/bash',
  $managehome=true,
  $home='',
  $key='',
  $type='',
  $ensure='present',
  $useaccess=true,
  $usesudo=false,
  $sudocommand='',
  $sudopassword='true'
 ) {

  user { $title:
    ensure     => $ensure,
    uid        => $uid,
    gid        => $gid,
    shell      => $shell,
    comment    => $comment,
    managehome => $managehome,
  }

  if $type != '' {
    ssh_authorized_key {$title:
      ensure => $ensure,
      type   => $type,
      key    => $key,
      user   => $title,
    }
  }

  # Conditionally set the password hash only if it is set in the definition
  if ($pass != '') {
    User[$title] {
      password +> $pass,
    }
  }
  # Conditionally set the homedir only if it is set in the definition
  if ($home != '') {
    User[$title] {
      home +> $home,
    }
  }
  # Conditionally set the groups parameter only if it is set in the definition
  if ($groups != '') {
    User[$title] {
      groups +> $groups,
    }
  }

  # Unlock any managed account (allowing keyaccess to new accounts
  $unlock_command = $::operatingsystem ? {
    solaris => "/usr/bin/passwd -N ${title}",
    default => '/bin/true',
  }

  exec {"unlock${title}":
    command     => $unlock_command,
    onlyif      => "grep ${title}:\\\\*LK\\\\*: /etc/shadow",
    refreshonly => true,
  }

  # Add users to access.conf
  if ($useaccess) {
    # Class['sshd'] -> Class['access']
    include sshd3
    include access3
    access3::allowuser { $title: ensure => $ensure}

  }

  include sudo3
  sudo3::user { $title :
    ensure   => present,
    password => $sudopassword ? {
                          "true"  => true,
                          "false" => false,
                          default => true
                         },
    commands => [$sudocommand],
  }

}
