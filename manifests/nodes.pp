# == Classification: Unclassified (provisional)
#

###########################
# Definition Nodes
###########################

# Standard base node
node basenode {
  include stages
  class {'dns'    : stage => pre4 }
  class {'policy' : stage => pre4 }
  include ntp
  include sshd
}

# Standard Legacy base node + LDAP Authentication
node baseldapnode_nopuppet inherits basenode {
  include stages
  class {'nsswitch': stage => pre4, type => 'ldap'}
  class {'pam':      stage => pre5, authentication => 'ldap' }
  class {'ldap': stage => pre5}
  class {'autofs':   stage => pre5}
  class {'admin_users':             auth => 'ldap'}
}

node baseldapnode inherits baseldapnode_nopuppet {
  include configpuppet
}

# Standard Legacy base node + Winbind Authentication
node basewinbindnode inherits basenode {
  include stages
  include configpuppet
  class {'nsswitch': stage => pre4, type => 'winbind' }
  class {'pam':      stage => pre5,  authentication => 'winbind'}
  class {'winbind':    stage => pre5 }
  class {'admin_users': auth => 'winbind'}
}

# Standard Legacy base node + VAS Authentication
node basevasnode inherits basenode {
  include stages
  include configpuppet
  class {'nsswitch': stage => pre4, type => 'vas' }
  class {'pam':      stage => pre5,  authentication => 'vas'}
  class {'admin_users': auth => 'vas'}
}

# Standard Legacy base node + Local Authentication
node baselocalnode inherits basenode {
  include configpuppet
  class {'nsswitch': stage => pre4, type => 'local'}
  class {'pam':                     authentication => 'local'}
  class {'admin_users':             auth => 'local'}
}

# Standard LDAP base node with Snare & Xymon
node extldapnode inherits baseldapnode {
  include configpuppet::facts
  include configpuppet::owner_facts
  class {'pkg_management': stage => pre4 }
  include snare
  include xymon
  include sudo
  sudo::netgroup { 'role-unix-support': ensure   => present,commands => 'ALL',}
  access::allowgroup { "access-${::fqdn}":        ensure => present}
  case $::operatingsystem {
      Solaris: { include role::solaris_essentials }
      CentOS: { }
      RedHat: { include role::redhat_essentials }
    }
}

# Standard localauth base node with Snare & Xymon
node extlocalnode inherits baselocalnode {
  include configpuppet::facts
  include configpuppet::owner_facts
  class {'pkg_management': stage => pre4 }
  include snare
  include xymon
  case $::operatingsystem {
      Solaris: { include role::solaris_essentials }
      CentOS: { }
      RedHat: { include role::redhat_essentials }
    }
}

# Standard vasauth base node with Snare & Xymon
node divasnode inherits basevasnode {
  include configpuppet::facts
  include configpuppet::owner_facts
  class {'pkg_management': stage => pre4 }
  include snare
  include xymon
  case $::operatingsystem {
      Solaris: { include role::solaris_essentials }
      CentOS: { }
      RedHat: { include role::redhat_essentials }
    }
}

# Standard winbindauth base node with Snare & Xymon
node extwinbindnode inherits basewinbindnode {
  include configpuppet::facts
  include configpuppet::owner_facts
  class {'pkg_management': stage => pre4 }
  include snare
  include xymon
  case $::operatingsystem {
    Solaris: { include role::solaris_essentials }
    CentOS: { }
    RedHat: { include role::redhat_essentials }
  }
    
}

# Puppetmaster configuration
#node puppetmaster inherits basenode {
#  include configpuppet::master
#}

#Temporary VM node definition
node /^.*temp\..*/ inherits baseldapnode_nopuppet {
  include configpuppet::facts
  include configpuppet::owner_facts
  class {'pkg_management': stage => pre4 }
  include snare
  include xymon
  include sudo
  sudo::netgroup { 'role-unix-support': ensure   => present,commands => 'ALL',}
  include vmwaretools
}
