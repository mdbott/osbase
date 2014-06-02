# == Classification: Unclassified (provisional)
#
class pam3::config{
  
  case $pam3::params::pam3_conf_ver {
      Solaris10: { 
        class{'pam3::config::pamconf':}
      }
      Solaris11: { 
        class{'pam3::config::login':}
        class{'pam3::config::other':}
      }
      RedHat5:  { 
        class{'pam3::config::systemauth':}
        class{'pam3::config::passwordauth':}
      }
      RedHat6:  { 
        class{'pam3::config::systemauth':}
        class{'pam3::config::passwordauth':}
      }
    }


}