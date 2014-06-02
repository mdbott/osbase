# == Classification: Unclassified (provisional)
#
define access3::allowgroup (
  $ensure="present",
  $hosts = "ALL",
  $priority = '15',
){
  access3::line{$name: origin=>$hosts,priority=>$priority, group => true}
}
