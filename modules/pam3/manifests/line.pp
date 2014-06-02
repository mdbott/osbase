# == Classification: Unclassified (provisional)
#
define pam3::line (
  $ensure = present,
  $target,
  $service="",
  $type,
  $control,
  $modulepath,
  $moduleargs="",
  $priority
) {
  concat::fragment{$title:
    ensure  => $ensure,
    target  => $target,
    order   => $priority,
    content => template('pam3/pam.line.erb'),
  }
}