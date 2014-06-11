# == Classification: Unclassified (provisional)
#
class kerberos::service(
  $krbuser = '',
  $krbpassword = ''
  ){
    include kerberos::params
    if $krbuser != '' {
      exec { 'kinit':
        command => "/bin/echo ${krbpassword} | ${kerberos::params::kinitcmd} ${krbuser}",
        creates => $kerberos::params::keytab,
      }
    }

}
