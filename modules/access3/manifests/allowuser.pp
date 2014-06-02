# == Classification: Unclassified (provisional)

define access3::allowuser (
  $ensure="present",
  $hosts = "ALL",
  $priority = '10',
){
  access3::line{$name: origin=>$hosts,priority=>$priority}
}