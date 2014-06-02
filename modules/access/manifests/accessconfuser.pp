# == Classification: Unclassified (provisional)

define access::accessconfuser (
  $ensure,
  $hosts = "ALL"
) 
{
	access::accessconfline { $name:
    	ensure   => $ensure,
    	group    => false,
        hosts    => $hosts,
 	}
}
