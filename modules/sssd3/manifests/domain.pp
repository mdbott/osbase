# == Classification: Unclassified (provisional)
#
# == Define: sssd::domain
# This type is used to define one or more domains which SSSD
# will authenticate against.
#
# Only LDAP simple bind is currently supported.
# You REALLY should use TLS.
#
# Currently only supports a default set of providers.
# And only tested with Active Directory.
# id_provider     = ldap
# auth_provider   = krb5
# chpass_provider = krb5
# access_provider = simple
#
# This type has a LOT of parameter options. Most of them are
# passed directly through to the sssd.conf template file.
# So you can also use the sssd.conf reference for this module.
#
# === Parameters
# [*ldap_domain*]
# Optional. String. Fully-qualified DNS name of your LDAP domain.
# Defaults to using the name parameter.
#
# [*ldap_uri*]
# Required. String.
# By default, sssd will use DNS service discovery to find LDAP servers.
# However, you may define a specific ldap server for sssd to use.
# If you are using TLS, the hostname(s) specified here must match the CN
# in the TLS certificate.
#
# [*ldap_search_base*]
# Required. String.
# In most cases, SSSD will automatically use the defaultNamingContext
# specified in the RootDSE as the search base. If that isn't working,
# you will need to specify it manually here.
#
# [*ldap_user_search_base*]
# Optional. String.
# An optional base DN to restrict user searches to a specific subtree.
#
# [*ldap_group_search_base*]
# Optional. String.
# An optional base DN to restrict group searches to a specific subtree.
#
# [*krb5_realm*]
# Required. String.
# This setting is only used if "krb5" is one of the providers.
# SSSD does not use the settings from /etc/krb5.conf.
#
# [*ldap_default_bind_dn*]
# Required. String.
# Distinguished name of an account to use for LDAP simple bind.
#
# [*ldap_default_authtok*]
# Required. String.
# Password associated with account used for LDAP simple bind.
#
# ==== LDAP user schema
# [*ldap_user_object_class*]
# Optional. String. Defaults to "user".
# Depending on what kind of LDAP server you're using, you may need to customize
# the attribute maps. This is especially true for Active Directory, and it
# depends on which version of MS SFU (Services for unix) you have implemented.
#
# [*ldap_user_name*]
# Optional. String. Defaults to "sAMAccountName".
# The ldap_user_name is critical for mapping the logon username to an
# entry in LDAP. This must be set correctly for lookups to succeed.
# In Active Directory, the user name is stored in sAMAccountName.
# In other LDAP servers, the uid attribute is normally used.
#
# [*ldap_user_principal*]
# Optional. String. Defaults to "userPrincipalName".
# The LDAP attribute that contains the user's Kerberos User Principle.
#
# [*ldap_user_uid_number*]
# Optional. String. Defaults to "uidNumber".
#
# [*ldap_user_gid_number*]
# Optional. String. Defaults to "gidNumber".
#
# [*ldap_user_gecos*]
# Optional. String. Defaults to "gecos".
#
# [*ldap_user_shell*]
# Optional. String. Defaults to "loginShell".
#
# [*ldap_user_home_directory*]
# Optional. String. Defaults to "unixHomeDirectory".
#
# ==== LDAP group schema
# [*ldap_group_object_class*]
# Optional. String. Defaults to "group".
#
# [*ldap_group_name*]
# Optional. String. Defaults to "cn".
#
# [*ldap_group_member*]
# Optional. String. Defaults to "gidNumber".
#
# [*ldap_group_gid_number*]
# Optional. String. Defaults to "gidNumber".
#
# ==== Other LDAP parameters
# [*ldap_id_use_start_tls*]
# (true|false) Optional. Boolean. Defaults to true.
# START TLS ensures that all passwords sent to the LDAP server are encrypted.
# TLS encryption is maybe handled by OpenLDAP, I think.
#
# [*ldap_tls_reqcert*]
# (demand|hard) Optional. String. Defaults to "demand".
# How should sssd treat bad certificates from the server? In almost all cases,
# sssd should demand a trusted certificate, otherwise terminate the connection.
#
# [*ldap_tls_cacert*]
# Optional. Not yet implemented.
# If desired, you can specify a file containing trusted Certificate Authorities.
# Otherwise, sssd will use the OpenLDAP defaults in /etc/openldap/ldap.conf
#
# [*ldap_default_authtok_type*]
# (password|obfuscated_password) Optional. String. Defaults to "password".
#
# [*ldap_schema*]
# (rfc2307|rfc2307bis|ipa|ad) Optional. String. Default is "rfc2307bis".
# Three LDAP schemas are currently supported: rfc2307, rfc2307bis, IPA
# The schema mainly affects how group membership is recorded in attributes.
# Active Directory uses rfc2307bis.
#
# [*enumerate*]
# (true|false) Optional. Boolean. Defaults to false.
# When enumeration is enabled, SSSd will periodically query the LDAP
# server for information about all users and groups. This is never
# recommended in large environments.
#
# [*ldap_force_upper_case_realm*]
# (true|false) Optional. Boolean. Defaults to true.
# Some directory servers, for example Active Directory, might deliver the realm
# part of the UPN in lower case, which might cause the authentication to fail.
# Set this option to true if you want to use an upper-case realm.
#
# [*ldap_referrals*]
# (true|false) Optional. Boolean. Defaults to false.
# LDAP referrals are sometimes important in multi-domain setups
# so that responses can provide referrals to a different server.
# However, this doesn't work well in SSSD so it's disabled.
# We might need to reconsider that in the future.
#
# [*cache_credentials*]
# (true|false) Optional. Boolean. Defaults to false.
# Specify whether to store user credentials in the local LDB cache
#
# [*min_id*]
# Optional. Integer. Defaults to 1000, depending on platform.
# UID and GID limits for the domain. If a domain contains an entry that is
# outside these limits, it is ignored. For users, this affects the primary
# GID limit. The user will not be returned to NSS if either the UID or the
# primary GID is outside the range. For non-primary group memberships, those
# that are in range will be reported as expected. Typically...
# uid < 1000 = system account
# uid >= 1000 = directory account or local user
#
# [*entry_cache_timeout*]
# Optional. Integer. Defaults to 60 seconds.
# You may force sssd to always consult the backend by setting a short entry
# cache timeout. But to improve performance, allow sssd to use caching.
# Specified in seconds.
#
# [*krb5_canonicalize*]
# (true|false) Optional. Boolean. Defaults to false.
# When using Kerberos with Active Directory, canonicalization should be set
# to false so that cached credentials work properly.
#
# === Requires
# - [ripienaar/concat]
# - [puppetlab/stdlib]
#
# === Example
# sssd::domain { 'mydomain.local':
#   ldap_uri             => 'ldap://mydomain.local',
#   ldap_search_base     => 'DC=mydomain,DC=local',
#   krb5_realm           => 'MYDOMAIN.LOCAL',
#   ldap_default_bind_dn => 'CN=SssdService,DC=mydomain,DC=local',
#   ldap_default_authtok => 'My ultra-secret password',
#   simple_allow_groups  => 'SssdAdmins',
# }
#
# === Authors
# Nicholas Waller <code@nicwaller.com>
#
# === Copyright
# Copyright 2013 Nicholas Waller, unless otherwise noted.
#
define sssd3::domain (
  $id_provider = undef,
  $auth_provider = undef,
  $chpass_provider = undef,
  $sudo_provider = undef,
  $access_provider = undef,
  $ldap_uri = undef,
  $ldap_search_base= undef,
  $ldap_user_search_base=undef,
  $ldap_group_search_base=undef,
  $ldap_netgroup_search_base=undef,
  $ldap_sudo_search_base=undef,
  $krb5_realm=undef,

  $ldap_default_bind_dn=undef,
  $ldap_default_authtok=undef,

  $simple_allow_groups=undef,

  $ldap_user_object_class = undef,
  $ldap_user_name = undef,
  $ldap_user_principal = undef,
  $ldap_user_uid_number = undef,
  $ldap_user_gid_number = undef,
  $ldap_user_gecos = undef,
  $ldap_user_shell = undef,
  $ldap_user_home_directory = undef,

  $ldap_group_object_class = undef,
  $ldap_group_name = undef,
  $ldap_group_member = undef,
  $ldap_group_gid_number = undef,

  $ldap_id_use_start_tls = undef,
  $ldap_id_mapping = undef,
  $ldap_tls_reqcert = undef,
  $ldap_tls_cacert = undef,
  $ldap_tls_cacertdir = undef,
  $ldap_default_authtok_type = undef,
  $ldap_schema = undef,
  $enumerate = undef,
  $ldap_force_upper_case_realm = undef,
  $ldap_referrals = undef,
  $cache_credentials = undef,
  $min_id = undef,
  $entry_cache_timeout = undef,
  $krb5_canonicalize = undef,
  $ldap_chpass_update_last_change = undef,
  $ldap_account_expire_policy = undef,
  $ldap_rfc2307_fallback_to_local_users = undef
) {

  
  include sssd3::params
#  if $min_id == undef {
#    $real_min_id = $sssd3::params::dist_uid_min
#  } else {
#    $real_min_id = $min_id
#  }

  concat::fragment { "sssd_domain_${name}":
    target  => '/etc/sssd/sssd.conf',
    content => template('sssd3/domain.conf.erb'),
    order   => 20,
  }
}
