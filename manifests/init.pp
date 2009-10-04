define geminstall($version) {
	exec { "geminstall-exec-$version":
		require => [
			Exec["geminstall-extract"],
			Sourceinstall["ruby-$version"]
		],
		cwd => "/root/rubygems-1.3.5",
		command => "/opt/ruby-$version/bin/ruby setup.rb",
		unless => "test 1.3.5 = $(/opt/ruby-$version/bin/gem --version)",
	}
}

define gem($name, $version) {
	exec { "gem-exec-$name-$version":
		require => Geminstall["rubygems-1.3.5-$version"],
		command => "/opt/ruby-$version/bin/gem install $name",
	}
}

class ruby {
	include ruby::ruby_1_9_1
	include ruby::ruby_1_8_7

	file { "/root/rubygems-1.3.5.tgz":
		source => "puppet://$servername/ruby/rubygems-1.3.5.tgz",
		ensure => present,
	}
	exec { "geminstall-extract":
		require => File["/root/rubygems-1.3.5.tgz"],
		cwd => "/root",
		command => "tar xf /root/rubygems-1.3.5.tgz",
		creates => "/root/rubygems-1.3.5",
		#unless => "UNLESS WHAT???",
	}
	# If anything happened in order, each geminstall would go here
	exec { "geminstall-remove":
		require => [
			Geminstall["geminstall-1.9.1-p243"],
			Geminstall["geminstall-1.8.7-p174"]
		],
		command => "rm -rf /root/rubygems-1.3.5*",
	}

	file { "/usr/local/bin/pick-ruby":
		source => "puppet://$servername/ruby/pick-ruby",
		ensure => present,
	}

}

class ruby::ruby_1_9_1 {
	$version = "1.9.1-p243"
	sourceinstall { "ruby-$version":
		tarball => "ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-$version.tar.bz2",
		prefix => "/opt/ruby-$version",
		flags => "",
	}
	geminstall { "geminstall-$version": version => "$version" }
}

class ruby::ruby_1_8_7 {
	$version = "1.8.7-p174"
	sourceinstall { "ruby-$version":
		tarball => "ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-$version.tar.bz2",
		prefix => "/opt/ruby-$version",
		flags => "",
	}
	geminstall { "geminstall-$version": version => "$version" }
}
