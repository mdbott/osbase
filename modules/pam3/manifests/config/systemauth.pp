# == Classification: Unclassified (provisional)
#
class pam3::config::systemauth(
  $pam_entries ={}
) {
  include concat::setup
  
  $pamfile = '/etc/pam.d/system-auth-ac'
  concat{$pamfile:}
  concat::fragment{"${pamfile}_pam_header":
    target  => $pamfile,
    order   => 01,
    content => "#%PAM-1.0\n# This file is managed by Puppet\n# User changes will be destroyed the next time puppet runs.\n"
  }
  
  $base_sysauth_config = {
    "${pamfile}_auth_env"          => {target => $pamfile,   type=>'auth',     control=>'required',   modulepath=>'pam_env.so',priority=>'110'},
    "${pamfile}_auth_unix"         => {target => $pamfile,   type=>'auth',     control=>'sufficient', modulepath=>'pam_unix.so',moduleargs=>'nullok try_first_pass',priority=>'120'},
    "${pamfile}_auth_succeed"      => {target => $pamfile,   type=>'auth',     control=>'requisite',  modulepath=>'pam_succeed_if.so',moduleargs=>'uid >= 349',priority=>'130'},
    "${pamfile}_auth_deny"         => {target => $pamfile,   type=>'auth',     control=>'required',   modulepath=>'pam_deny.so',priority=>'140'},

    "${pamfile}_acc_unix"          => {target => $pamfile,   type=>'account',  control=>'required',  modulepath=>'pam_unix.so',moduleargs=>'broken_shadow',priority=>'180'},
    "${pamfile}_acc_local"         => {target => $pamfile,   type=>'account',  control=>'sufficient',modulepath=>'pam_localuser.so',priority=>'190'},
    "${pamfile}_acc_succeed"       => {target => $pamfile,   type=>'account',  control=>'sufficient',modulepath=>'pam_succeed_if.so',moduleargs=>'uid < 500 quiet',priority=>'200'},
    "${pamfile}_acc_permit"        => {target => $pamfile,   type=>'account',  control=>'required',  modulepath=>'pam_permit.so',priority=>'210'},

    "${pamfile}_pass_cracklib"     => {target => $pamfile,   type=>'password', control=>'requisite', modulepath=>'pam_cracklib.so',moduleargs=>'try_first_pass retry=3 type= minlen=14 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1 difok=4',priority=>'240'},
    "${pamfile}_pass_unix"         => {target => $pamfile,   type=>'password', control=>'sufficient',modulepath=>'pam_unix.so',moduleargs=>'sha512 shadow  try_first_pass use_authtok remember=24',priority=>'250'},
    "${pamfile}_pass_deny"         => {target => $pamfile,   type=>'password', control=>'required',  modulepath=>'pam_deny.so',priority=>'260'},

    "${pamfile}_sess_keyinit"      => {target => $pamfile,   type=>'session',  control=>'optional',  modulepath=>'pam_keyinit.so',moduleargs=>'revoke',priority=>'300'},
    "${pamfile}_sess_limits"       => {target => $pamfile,   type=>'session',  control=>'required',  modulepath=>'pam_limits.so',priority=>'310'},
    "${pamfile}_sess_succeed"      => {target => $pamfile,   type=>'session',  control=>'[success=1 default=ignore]',modulepath=>'pam_succeed_if.so',moduleargs=>'service in crond quiet use_uid',priority=>'320'},
    "${pamfile}_sess_unix"         => {target => $pamfile,   type=>'session',  control=>'required',  modulepath=>'pam_unix.so',priority=>'330'}
  }

  pam3::space{"${pamfile}_auth_space": target => $pamfile,priority=>'160'}
  pam3::space{"${pamfile}_acc_space": target => $pamfile,priority=>'230'}
  pam3::space{"${pamfile}_pass_space": target => $pamfile,priority=>'280'}
  
  case $pam3::params::sys_auth {
    
    'local': {
      $auth_sysauth_config = {}
    }
 
    'ldap':  {
      $auth_sysauth_config = {
          "${pamfile}_auth_ldap"    => {target => $pamfile,   type=>'auth',     control=>'sufficient', modulepath=>'pam_ldap.so',moduleargs=>'use_first_pass',priority=>'135'},
          "${pamfile}_acc_ldap"     => {target => $pamfile,   type=>'account',  control=>'[default=bad success=ok user_unknown=ignore]',modulepath=>'pam_ldap.so',priority=>'205'},
          "${pamfile}_pass_ldap"    => {target => $pamfile,   type=>'password', control=>'sufficient',modulepath=>'pam_ldap.so',moduleargs=>'use_authtok',priority=>'255'},
          "${pamfile}_sess_ldap"    => {target => $pamfile,   type=>'session',  control=>'optional',  modulepath=>'pam_ldap.so',priority=>'340'}
      }
    }
    
    'sss':  {
      $auth_sysauth_config = {
          "${pamfile}_auth_sss"     => {target => $pamfile,   type=>'auth',     control=>'sufficient', modulepath=>'pam_sss.so',moduleargs=>'use_first_pass',priority=>'135'},
          "${pamfile}_acc_sss"      => {target => $pamfile,   type=>'account',  control=>'[default=bad success=ok user_unknown=ignore]',modulepath=>'pam_sss.so',priority=>'205'},
          "${pamfile}_pass_sss"     => {target => $pamfile,   type=>'password', control=>'sufficient',modulepath=>'pam_sss.so',moduleargs=>'use_authtok',priority=>'255'},
          "${pamfile}_sess_sss"     => {target => $pamfile,   type=>'session',  control=>'optional',  modulepath=>'pam_sss.so',priority=>'340'}
      }
    }
            
    'vas':  {
      $auth_sysauth_config = {
          "${pamfile}_auth_vas3"    => {target => $pamfile,   type=>'auth',     control=>'sufficient', modulepath=>'pam_vas3.so',moduleargs=>'use_first_pass',priority=>'135'},
          "${pamfile}_acc_vas3"     => {target => $pamfile,   type=>'account',  control=>'[default=bad success=ok user_unknown=ignore]',modulepath=>'pam_vas3.so',priority=>'205'},
          "${pamfile}_pass_vas3"    => {target => $pamfile,   type=>'password', control=>'sufficient',modulepath=>'pam_vas3.so',moduleargs=>'use_authtok',priority=>'255'},
          "${pamfile}_sess_vas3"    => {target => $pamfile,   type=>'session',  control=>'optional',  modulepath=>'pam_vas3.so',priority=>'340'}
      }
    }
                
    'winbind':  {
      $auth_sysauth_config = {
    
          "${pamfile}_auth_winbind" => {target => $pamfile,   type=>'auth',     control=>'sufficient', modulepath=>'pam_winbind.so',moduleargs=>'use_first_pass',priority=>'135'},
          "${pamfile}_acc_winbind"  => {target => $pamfile,   type=>'account',  control=>'[default=bad success=ok user_unknown=ignore]',modulepath=>'pam_winbind.so',priority=>'205'},
          "${pamfile}_pass_winbind" => {target => $pamfile,   type=>'password', control=>'sufficient',modulepath=>'pam_winbind.so',moduleargs=>'use_authtok',priority=>'255'},
          "${pamfile}_sess_winbind" => {target => $pamfile,   type=>'session',  control=>'optional',  modulepath=>'pam_winbind.so',priority=>'340'}
      }
    }
    
    'ipa':  {}
  }
  
  case $pam3::params::accesscontrol {
  true: {
    $access_sysauth_config = {
      "${pamfile}_acc_access"        => {target => $pamfile,   type=>'account',  control=>'required',  modulepath=>'pam_access.so',priority=>'170'}
    }
  }
  false: {
    $access_sysauth_config = {}
  }
  default: {}
 }
  
  $merged_sysauth_config = merge($base_sysauth_config,$auth_sysauth_config)
  $merged2_sysauth_config = merge($merged_sysauth_config,$access_sysauth_config)
  $final_sysauth_config = merge($merged2_sysauth_config,$pam_entries)
  # Deploy custom entries from hiera
  create_resources(pam3::line,$final_sysauth_config)

}