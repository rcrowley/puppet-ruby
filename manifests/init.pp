define geminstall($version) {
	exec { "install-gem-1.3.5-$version":
		require => Exec["extract-gem-1.3.5"],
		before => Exec["remove-gem-1.3.5"],
		cwd => "/root/rubygems-1.3.5",
		command => "/opt/ruby-$version/bin/ruby setup.rb --prefix=/opt/ruby-$version",
		creates => "/opt/ruby-$version/bin/gem",
		onlyif => "test -d /opt/ruby-$version",
	}
}

class ruby {
	include ruby::ruby_1_9_1
	include ruby::ruby_1_8_7

	file { "/opt/rubygems-1.3.5.tgz":
		require => [
			Sourceinstall["ruby-1.9.1-p243"],
			Sourceinstall["ruby-1.8.7-p174"]
		],
		before => Exec["extract-gem-1.3.5"],
		source => "puppet://$servername/ruby/rubygems-1.3.5.tgz",
		ensure => present,
	}

	exec { "extract-gem-1.3.5":
		require => File["/opt/rubygems-1.3.5.tgz"],
		before => [
			Geminstall["gem-1.3.5-1.9.1-p243"],
			Geminstall["gem-1.3.5-1.8.7-p174"]
		],
		cwd => "/root",
		command => "tar xf /opt/rubygems-1.3.5.tgz",
		creates => "/root/rubygems-1.3.5",
		#unless => "UNLESS WHAT???",
	}

	# If anything happened in order, each pipinstall would go here

	exec { "remove-gem-1.3.5":
		cwd => "/root",
		command => "rm -rf rubygems-1.3.5",
		onlyif => "test -d /root/rubygems-1.3.5",
	}

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
	geminstall { "gem-1.3.5-$version": version => "$version" }
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
	geminstall { "gem-1.3.5-$version": version => "$version" }
}
