# == Classification: Unclassified (provisional)
#
define pam3::space (
    $ensure = present,
  $target,
  $priority
) {
  concat::fragment{$title:
    ensure  => $ensure,
    target  => $target,
    order   => $priority,
    content => "\n"
  }
}
  
