# == Classification: Unclassified (provisional)
#
class ldapclient::keystore {
  
  $keystore=['/var/ldap/cert8.db','/var/ldap/key3.db','/var/ldap/secmod.db']
  
  $certarray = split("${ldapclient::certname}",".")
  $certtitle = $certarray[0]

  File["/var/ldap/${ldapclient::certname}"]
  -> Exec['create keystore']
  ~> Exec['clear key']
  ~> Exec['add CA']
  ~> File[$keystore]
 
  file {"/var/ldap/${ldapclient::certname}":
    ensure      => 'file',
    owner       => 'root',
    mode        => '0644',
    source      => "puppet:///modules/ldapclient/${ldapclient::certname}",
  }

  exec {'create keystore':
    command     => "/usr/sfw/bin/certutil -N -d /var/ldap -f /var/ldap/${ldapclient::certname}",
    creates     => '/var/ldap/cert8.db',
  }

  exec {'clear key':
    command     => '/usr/bin/rm -f /var/ldap/key3.db',
    refreshonly => true,
  }

  exec {'add CA':
    command     => "/usr/sfw/bin/certutil -A -n CA -i /var/ldap/${ldapclient::certname} -a -t \"CT\" -d /var/ldap",
    refreshonly => true,
  }

  file {$keystore:
    ensure      => 'file',
    owner       => 'root',
    mode        => '0644',
  }
}