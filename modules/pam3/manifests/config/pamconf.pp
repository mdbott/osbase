# == Classification: Unclassified (provisional)
#
class pam3::config::pamconf(
    $pam_entries ={}
) {
  include concat::setup
  
  $pamfile = '/etc/pam.conf'
  concat{$pamfile:
  }

  concat::fragment{"${pamfile}pam_header":
    target  => $pamfile,
    order   => 10,
    content => "#\n
#ident  \"@(#)pam.conf 1.31  07/12/07 SMI\"
#
# Copyright 2007 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#
# PAM configuration
#
# Unless explicitly defined, all services use the modules
# defined in the \"other\" section.
#
# Modules are defined with relative pathnames, i.e., they are
# relative to /usr/lib/security/\$ISA. Absolute path names, as
# present in this file in previous releases are still acceptable.
#
# Authentication management
#
# login service (explicit because of pam_dial_auth)
#
",
  }
  
  
  $base_pamconf_config ={
    "login_auth_pam_authtok_get.so.1"             => {target=>$pamfile, service=>"login",         type=>"auth",     control=>"requisite",  modulepath=>"pam_authtok_get.so.1",   moduleargs=>"",priority=>"100"},
    "login_auth_pam_unix_cred.so.1"               => {target=>$pamfile, service=>"login",         type=>"auth",     control=>"required",   modulepath=>"pam_unix_cred.so.1",     moduleargs=>"",priority=>"110"},
    "login_auth_pam_unix_auth.so.1"               => {target=>$pamfile, service=>"login",         type=>"auth",     control=>"binding",    modulepath=>"pam_unix_auth.so.1",     moduleargs=>"server_policy",priority=>"120"},
    
    "other_auth_pam_authtok_get.so.1"             => {target=>$pamfile, service=>"other",         type=>"auth",     control=>"requisite",  modulepath=>"pam_authtok_get.so.1",   moduleargs=>"",priority=>"160"},
    "other_auth_pam_krb5.so.1"                    => {target=>$pamfile, service=>"other",         type=>"auth",     control=>"optional",   modulepath=>"pam_krb5.so.1",          moduleargs=>"",priority=>"170"},
    "other_auth_pam_unix_auth.so.1"               => {target=>$pamfile, service=>"other",         type=>"auth",     control=>"binding",    modulepath=>"pam_unix_auth.so.1",     moduleargs=>"server_policy",priority=>"180"},
    "other_auth_pam_unix_cred.so.1"               => {target=>$pamfile, service=>"other",         type=>"auth",     control=>"required",   modulepath=>"pam_unix_cred.so.1",     moduleargs=>"",priority=>"190"},
    
    "passwd_auth_pam_passwd_auth.so.1"            => {target=>$pamfile, service=>"passwd",        type=>"auth",     control=>"required",  modulepath=>"pam_passwd_auth.so.1",    moduleargs=>"server_policy",priority=>"220"},
    
    "cron_account_pam_unix_account.so.1"          => {target=>$pamfile, service=>"cron",          type=>"account",  control=>"required",  modulepath=>"pam_unix_account.so.1",   moduleargs=>"",priority=>"250"},
    
    "other_account_pam_roles.so.1"                => {target=>$pamfile, service=>"other",         type=>"account",  control=>"requisite", modulepath=>"pam_roles.so.1",          moduleargs=>"",priority=>"280"},
    "other_account_pam_unix_account.so.1"         => {target=>$pamfile, service=>"other",         type=>"account",  control=>"binding",   modulepath=>"pam_unix_account.so.1",   moduleargs=>"server_policy",priority=>"290"},
    
    "other_session_pam_unix_session.so.1"         => {target=>$pamfile, service=>"other",         type=>"session", control=>"required",   modulepath=>"pam_unix_session.so.1",   moduleargs=>"",priority=>"310"},
    
    "other_password_pam_authtok_get.so.1"         => {target=>$pamfile, service=>"other",         type=>"password", control=>"requisite",modulepath=>"pam_authtok_get.so.1",     moduleargs=>"",priority=>"340"},
    "other_password_pam_authtok_check.so.1"       => {target=>$pamfile, service=>"other",         type=>"password", control=>"requisite",modulepath=>"pam_authtok_check.so.1",   moduleargs=>"",priority=>"350"},
    "other_password_pam_authtok_store.so.1"       => {target=>$pamfile, service=>"other",         type=>"password", control=>"required", modulepath=>"pam_authtok_store.so.1",   moduleargs=>"",priority=>"360"},
    
    "sshdpubkey_account_pam_unix_account.so.1"    => {target=>$pamfile, service=>"sshd-pubkey",   type=>"account", control=>"binding",   modulepath=>"pam_unix_account.so.1",    moduleargs=>"server_policy",priority=>"400"},
    
    "sshdgssapi_account_pam_unix_account.so.1"    => {target=>$pamfile, service=>"sshd-gssapi",   type=>"account", control=>"binding",   modulepath=>"pam_unix_account.so.1",    moduleargs=>"server_policy",priority=>"440"},
    
    "sshdkbdint_account_pam_roles.so.1"           => {target=>$pamfile, service=>"sshd-kbdint",   type=>"account", control=>"requisite", modulepath=>"pam_roles.so.1",           moduleargs=>"",priority=>"470"},
    "sshdkbdint_account_pam_projects.so.1"        => {target=>$pamfile, service=>"sshd-kbdint",   type=>"account", control=>"required",  modulepath=>"pam_projects.so.1",        moduleargs=>"",priority=>"480"},
    "sshdkbdint_account_pam_unix_account.so.1"    => {target=>$pamfile, service=>"sshd-kbdint",   type=>"account", control=>"binding",   modulepath=>"pam_unix_account.so.1",    moduleargs=>"server_policy",priority=>"500"},
    
    "sshdpassword_account_pam_roles.so.1"         => {target=>$pamfile, service=>"sshd-password", type=>"account", control=>"requisite", modulepath=>"pam_roles.so.1",           moduleargs=>"",priority=>"530"},
    "sshdpassword_account_pam_projects.so.1"      => {target=>$pamfile, service=>"sshd-password", type=>"account", control=>"required",  modulepath=>"pam_projects.so.1",        moduleargs=>"",priority=>"540"},
    "sshdpassword_account_pam_unix_account.so.1"  => {target=>$pamfile, service=>"sshd-password", type=>"account", control=>"binding",   modulepath=>"pam_unix_account.so.1",    moduleargs=>"server_policy",priority=>"560"},
    
    "xscreensaver_auth_pam_authtok_get.so.1"      => {target=>$pamfile, service=>"xscreensaver",  type=>"auth",    control=>"requisite", modulepath=>"pam_authtok_get.so.1",     moduleargs=>"",priority=>"590"},
    "xscreensaver_auth_pam_krb5.so.1"             => {target=>$pamfile, service=>"xscreensaver",  type=>"auth",    control=>"sufficient",modulepath=>"pam_krb5.so.1",            moduleargs=>"",priority=>"600"},
    "xscreensaver_auth_pam_unix_auth.so.1"        => {target=>$pamfile, service=>"xscreensaver",  type=>"auth",    control=>"required",  modulepath=>"pam_unix_auth.so.1",       moduleargs=>"",priority=>"610"}

  } 
  
  pam3::space{"${pamfile}_login_space": target => $pamfile,priority=>'150'} 
  pam3::space{"${pamfile}_other_auth_space":   target => $pamfile,priority=>'210'} 
  pam3::space{"${pamfile}_passwd_space": target => $pamfile,priority=>'240'}
  pam3::space{"${pamfile}_cron_space":         target => $pamfile,priority=>'270'}
  pam3::space{"${pamfile}_other_account_space":target => $pamfile, priority=>'300'} 
  pam3::space{"${pamfile}_other_session_space":target => $pamfile,priority=>'330'}
  pam3::space{"${pamfile}_other_passwd_space": target => $pamfile,priority=>'380'}
  pam3::space{"${pamfile}_sshdpubkey_account_space": target => $pamfile,priority=>'420'}
  pam3::space{"${pamfile}_sshdgssapi_account_space": target => $pamfile,priority=>'460'}
  pam3::space{"${pamfile}_sshdkbdint_account_space": target => $pamfile,priority=>'520'}
  pam3::space{"${pamfile}_sshdpassword_account_space": target => $pamfile,priority=>'580'}
  pam3::space{"${pamfile}_xscreensaver_auth_space": target => $pamfile,priority=>'630'}  
  
  
case $pam3::params::sys_auth {
    
    'local': {
      $auth_pamconf_config = {}
    }
 
    'ldap':  {
      $auth_pamconf_config = {
        "${pamfile}_login_auth_ldap"          => {target=>$pamfile, service=>"login",           type=>'auth',     control=>'required',  modulepath=>'pam_ldap.so.1',priority=>'130'},
        "${pamfile}_other_auth_ldap"          => {target=>$pamfile, service=>"other",           type=>'auth',     control=>'required',  modulepath=>'pam_ldap.so.1',priority=>'185'},
        "${pamfile}_passw_auth_ldap"          => {target=>$pamfile, service=>"passwd",          type=>'auth',     control=>'required',  modulepath=>'pam_ldap.so.1',priority=>'230'},
        "${pamfile}_other_acco_ldap"          => {target=>$pamfile, service=>"other",           type=>'account',  control=>'required',  modulepath=>'pam_ldap.so.1',priority=>'295'},
        "${pamfile}_sshpu_acco_ldap"          => {target=>$pamfile, service=>"sshd-pubkey",     type=>'account',  control=>'required',  modulepath=>'pam_ldap.so.1',priority=>'410'},
        "${pamfile}_sshgs_acco_ldap"          => {target=>$pamfile, service=>"sshd-gssapi",     type=>'account',  control=>'required',  modulepath=>'pam_ldap.so.1',priority=>'450'},
        "${pamfile}_sshkb_acco_ldap"          => {target=>$pamfile, service=>"sshd-kbdint",     type=>'account',  control=>'required',  modulepath=>'pam_ldap.so.1',priority=>'510'},
        "${pamfile}_sshpa_acco_ldap"          => {target=>$pamfile, service=>"sshd-password",   type=>'account',  control=>'required',  modulepath=>'pam_ldap.so.1',priority=>'570'},
        "${pamfile}_xscre_auth_ldap"          => {target=>$pamfile, service=>"xscreensaver",    type=>'auth',     control=>'sufficient',modulepath=>'pam_ldap.so.1',priority=>'605'}
      }
    }
            
    'vas':  {
      $auth_pamconf_config = {
        "${pamfile}_login_auth_vas"          => {target=>$pamfile, service=>"login",            type=>'auth',     control=>'required', modulepath=>'pam_vas3.so.1',priority=>'70'},
        "${pamfile}_other_auth_vas"          => {target=>$pamfile, service=>"other",            type=>'auth',     control=>'required', modulepath=>'pam_vas3.so.1',priority=>'160'},
        "${pamfile}_other_acco_vas"          => {target=>$pamfile, service=>"other",            type=>'account',  control=>'required', modulepath=>'pam_vas3.so.1',priority=>'340'},
        "${pamfile}_sshpu_acco_vas"          => {target=>$pamfile, service=>"sshd-pubkey",      type=>'account',  control=>'required', modulepath=>'pam_vas3.so.1',priority=>'510'},
        "${pamfile}_sshgs_acco_vas"          => {target=>$pamfile, service=>"sshd-gssapi",      type=>'account',  control=>'required', modulepath=>'pam_vas3.so.1',priority=>'580'},
        "${pamfile}_sshkb_acco_vas"          => {target=>$pamfile, service=>"sshd-kbdint",      type=>'account',  control=>'required', modulepath=>'pam_vas3.so.1',priority=>'690'},
        "${pamfile}_sshpa_acco_vas"          => {target=>$pamfile, service=>"sshd-password",    type=>'account',  control=>'required', modulepath=>'pam_vas3.so.1',priority=>'790'}
      }
    }
                
    'winbind':  {
      $auth_pamconf_config = {
        "${pamfile}_login_auth_winbind"          => {target=>$pamfile, service=>"login",        type=>'auth',     control=>'required', modulepath=>'pam_winbind.so.1',priority=>'70'},
        "${pamfile}_other_auth_winbind"          => {target=>$pamfile, service=>"other",        type=>'auth',     control=>'required', modulepath=>'pam_winbind.so.1',priority=>'160'},
        "${pamfile}_other_acco_winbind"          => {target=>$pamfile, service=>"other",        type=>'account',  control=>'required', modulepath=>'pam_winbind.so.1',priority=>'340'},
        "${pamfile}_sshpu_acco_winbind"          => {target=>$pamfile, service=>"sshd-pubkey",  type=>'account',  control=>'required', modulepath=>'pam_winbind.so.1',priority=>'510'},
        "${pamfile}_sshgs_acco_winbind"          => {target=>$pamfile, service=>"sshd-gssapi",  type=>'account',  control=>'required', modulepath=>'pam_winbind.so.1',priority=>'580'},
        "${pamfile}_sshkb_acco_winbind"          => {target=>$pamfile, service=>"sshd-kbdint",  type=>'account',  control=>'required', modulepath=>'pam_winbind.so.1',priority=>'690'},
        "${pamfile}_sshpa_acco_winbind"          => {target=>$pamfile, service=>"sshd-password",type=>'account',  control=>'required', modulepath=>'pam_winbind.so.1',priority=>'790'}
      }
    }
    
    'ipa':  {}
  }
  
case $pam3::params::accesscontrol {
  true: {
    $access_pamconf_config = {
      "sshdpubkey_account_pam_list"          => {target=>$pamfile, service=>"sshd-pubkey",    type=>"account", control=>"required",  modulepath=>"pam_list.so.1",moduleargs=>"allow=/etc/users.allow",priority=>"390"},
      "sshdgssapi_account_pam_list"          => {target=>$pamfile, service=>"sshd-gssapi",    type=>"account", control=>"required",  modulepath=>"pam_list.so.1",moduleargs=>"allow=/etc/users.allow",priority=>"430"},
      "sshdkbdint_account_pam_list"          => {target=>$pamfile, service=>"sshd-kbdint",    type=>"account", control=>"required",  modulepath=>"pam_list.so.1",moduleargs=>"allow=/etc/users.allow",priority=>"490"},
      "sshdpasswd_account_pam_list"          => {target=>$pamfile, service=>"sshd-password",  type=>"account", control=>"required",  modulepath=>"pam_list.so.1",moduleargs=>"allow=/etc/users.allow",priority=>"550"}
    }
  }
  false: {
    $access_pamconf_config = {}
  }
  default: {}
}
  $merged_pamconf_config = merge($base_pamconf_config,$auth_pamconf_config)
  $merged2_pamconf_config = merge($merged_pamconf_config,$access_pamconf_config)
  $final_pamconf_config = merge($merged2_pamconf_config,$pam_entries)
  # Deploy custom entries from hiera
  create_resources(pam3::line,$final_pamconf_config)


}