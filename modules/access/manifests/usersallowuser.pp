# == Classification: Unclassified (provisional)

define access::usersallowuser (
  $ensure
) 
{
	access::usersallowline { $name:
    	ensure   => $ensure,
    	group    => false,
 	}
}