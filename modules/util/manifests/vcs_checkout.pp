# == Classification: Unclassified (provisional)
#
# Checkouts the specified vcs repos to the given destination path
#
# Parameters:
#   $repos                - An array of url to the repositories to checkout.
#   $dest_dir             - The local destination directory to checkout to.
#   $vcs_user             - The user which has access to the repo.
#   $vcs_password         - The password used to access the repo.
#   $owner                - The owner of the checkout files
#   $group                - The group which owns the checkout files
#   $force                - Whether to force checkout
#   $provider             - The provider of the repository, eg. svn, hg, etc.
#
define util::vcs_checkout(
  $repo,
  $dest_dir,
  $vcs_user,
  $vcs_password,
  $owner = "root",
  $group = "root",
  $force = true,
  $provider = "svn",
) {
 
# vcsrepo { "/var/www/happymeal/core":
#    ensure              => present,
#    force               => true,
#    provider            => "svn",
#    source              => $core_urls,
#    basic_auth_username => "cps2al-dsd",
#    basic_auth_password => "CPS2-alpha-007",
#    owner               => $owner,
#    group               => $group,
# }
  # Checkout all the $repos to $dest_dir
 vcsrepo { $dest_dir:
    ensure              => present,
    force               => $force,
    provider            => $provider,
    source              => $repo,
    basic_auth_username => $vcs_user,
    basic_auth_password => $vcs_password,
    owner               => $owner,
    group               => $group,
  }
#  file { "/var/www/happymeal/core/colossaldonut2/config":
#    ensure => directory,
#    mode => 777,
#  }
}

