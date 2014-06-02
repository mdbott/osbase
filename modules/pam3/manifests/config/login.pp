# == Classification: Unclassified (provisional)
#
class pam3::config::login {
  include concat::setup
  
  $pamfile = '/etc/pam.d/login.test'
  concat{$pamfile:
  }

  concat::fragment{"${pamfile}pam_header":
    target  => $pamfile,
    order   => 01,
    content => "#%PAM-1.0\n# This file is managed by Puppet\n# User changes will be destroyed the next time puppet runs.\n"
  }


  
  pam3::line{
  "auth_env":         target => $pamfile,   type=>'auth',     control=>'required',   modulepath=>'pam_env.so',priority=>'05';
  #"pam_auth_fprintd": target => $pamfile,   type=>'auth',control=>'sufficient', modulepath=>'pam_fprintd.so',priority=>'10';
  "auth_unix":        target => $pamfile,   type=>'auth',     control=>'sufficient', modulepath=>'pam_unix.so',moduleargs=>'nullok try_first_pass',priority=>'15';
  "auth_succeed":     target => $pamfile,   type=>'auth',     control=>'requisite',  modulepath=>'pam_succeed_if.so',moduleargs=>'uid >= 349',priority=>'20';
  "auth_ldap":        target => $pamfile,   type=>'auth',     control=>'sufficient', modulepath=>'pam_ldap.so',moduleargs=>'use_first_pass',priority=>'22';
  "auth_deny":        target => $pamfile,   type=>'auth',     control=>'required',   modulepath=>'pam_deny.so',priority=>'25'}
  pam3::space{"auth_space": target => $pamfile,priority=>'30'}
  pam3::line{
  "acc_access":       target => $pamfile,   type=>'account',  control=>'required',  modulepath=>'pam_access.so',priority=>'32';
  "acc_unix":         target => $pamfile,   type=>'account',  control=>'required',  modulepath=>'pam_unix.so',moduleargs=>'broken_shadow',priority=>'35';
  "acc_local":        target => $pamfile,   type=>'account',  control=>'sufficient',modulepath=>'pam_localuser.so',priority=>'40';
  "acc_succeed":      target => $pamfile,   type=>'account',  control=>'sufficient',modulepath=>'pam_succeed_if.so',moduleargs=>'uid < 500 quiet',priority=>'45';
  "acc_ldap":         target => $pamfile,   type=>'account',  control=>'[default=bad success=ok user_unknown=ignore]',modulepath=>'pam_ldap.so',priority=>'47';
  "acc_permit":       target => $pamfile,   type=>'account',  control=>'required',  modulepath=>'pam_permit.so',priority=>'50'}
  pam3::space{"acc_space": target => $pamfile,priority=>'55'}
  pam3::line{
  "pass_cracklib":    target => $pamfile,   type=>'password', control=>'requisite', modulepath=>'pam_cracklib.so',moduleargs=>'try_first_pass retry=3 type=',priority=>'60';
  "pass_unix":        target => $pamfile,   type=>'password', control=>'sufficient',modulepath=>'pam_unix.so',moduleargs=>'sha512 shadow nullok try_first_pass use_authtok',priority=>'65';
  "pass_ldap":        target => $pamfile,   type=>'password', control=>'sufficient',modulepath=>'pam_ldap.so',moduleargs=>'use_authtok',priority=>'67';
  "pass_deny":        target => $pamfile,   type=>'password', control=>'required',  modulepath=>'pam_deny.so',priority=>'70'}
  pam3::space{"pass_space": target => $pamfile,priority=>'75'}
  pam3::line{
  "sess_keyinit":     target => $pamfile,   type=>'session',  control=>'optional',  modulepath=>'pam_keyinit.so',moduleargs=>'revoke',priority=>'80';
  "sess_limits":      target => $pamfile,   type=>'session',  control=>'required',  modulepath=>'pam_limits.so',priority=>'85';
  "sess_succeed":     target => $pamfile,   type=>'session',  control=>'[success=1 default=ignore]',modulepath=>'pam_succeed_if.so',moduleargs=>'service in crond quiet use_uid',priority=>'90';
  "sess_unix":        target => $pamfile,   type=>'session',  control=>'required',  modulepath=>'pam_unix.so',priority=>'95';
  "sess_ldap":        target => $pamfile,   type=>'session',  control=>'optional',  modulepath=>'pam_ldap.so',priority=>'97'}
  
  
  $useoddjob = false
  
  if $useoddjob == true {
    pam3::line{"sess_oddjob": target => $pamfile,type=>'session',control=>'optional',modulepath=>'pam_oddjob_mkhomedir.so',priority=>'86'}  
    }
}