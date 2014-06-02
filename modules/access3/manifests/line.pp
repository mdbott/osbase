# == Classification: Unclassified (provisional)
#
define access3::line (
  $ensure = present,
  $permission="+",
  $origin="ALL",
  $priority = '10',
  $group = false,
   )
 {
   if $content == "" {
     $content = "${permission}:${title}:${origin}\n"
   }
 
  concat::fragment{$title:
    ensure => $ensure,
    target => $access3::params::accessfile, 
    content => template($access3::params::accesslinetemplate),
    order => $priority,
   }
 }

