class ruby {
	include ruby::ruby_1_9_1
	include ruby::ruby_1_8_7
}

class ruby::ruby_1_9_1 {
	$version = "1.9.1-p243"
	sourceinstall { "ruby-$version":
		package => "ruby",
		version => "$version",
		tarball => "puppet://$servername/ruby/ruby-$version.tar.bz2",
		flags => "",
		bin => "ruby",
	}
}

class ruby::ruby_1_8_7 {
	$version = "1.8.7-p174"
	sourceinstall { "ruby-$version":
		package => "ruby",
		version => "$version",
		tarball => "puppet://$servername/ruby/ruby-$version.tar.bz2",
		flags => "",
		bin => "ruby",
	}
}
