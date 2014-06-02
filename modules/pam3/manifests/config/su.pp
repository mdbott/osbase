# == Classification: Unclassified (provisional)
#
class pam3::config::su(
  $pam_entries ={}
) {
  include concat::setup
  
  $pamfile = '/etc/pam.d/su'
  concat{$pamfile:}
  concat::fragment{"${pamfile}_pam_header":
    target  => $pamfile,
    order   => 01,
    content => "#%PAM-1.0\n# This file is managed by Puppet\n# User changes will be destroyed the next time puppet runs.\n"
  }
  
  $base_sysauth_config = {
    "${pamfile}_auth_rootok"       => {target => $pamfile,   type=>'auth',     control=>'sufficient',   modulepath=>'pam_rootok.so',priority=>'110'},
    "${pamfile}_auth_system"         => {target => $pamfile,   type=>'auth',     control=>'include', modulepath=>'system-auth',priority=>'120'},
    
    "${pamfile}_acc_succeed"      => {target => $pamfile,   type=>'auth',     control=>'requisite',  modulepath=>'pam_succeed_if.so',moduleargs=>'uid >= 349',priority=>'140'},
    "${pamfile}_auth_deny"         => {target => $pamfile,   type=>'auth',     control=>'required',   modulepath=>'pam_deny.so',priority=>'150'},

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
  pam3::space{"${pamfile}_acc_space":  target => $pamfile,priority=>'230'}
  pam3::space{"${pamfile}_pass_space": target => $pamfile,priority=>'280'}
  
}