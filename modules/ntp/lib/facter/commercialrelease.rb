# Classification: Unclassified (provisional)
Facter.add(:commercialrelease) do
    confine :operatingsystem => "Solaris"
    setcode do
      full_release = File.readlines("/etc/release").to_s.match(/[Oracle]? Solaris (\w+ )?[\w\/]+ ([^_]+_[^_]+)/).to_a.last.to_s.chomp("wos")
      if full_release =~ /^s(\d+)\w(_\w\d)+/
        $1 + $2
      else
        full_release
      end
    end
end
