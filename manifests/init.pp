define geminstall($version) {
	exec { "geminstall-exec-$version":
		require => [
			Sourceinstall["ruby-$version"],
			Exec["geminstall-extract"]
		],
		cwd => "/tmp/rubygems-1.3.5",
		command => "/opt/ruby-$version/bin/ruby setup.rb",
		unless => "test 1.3.5 = $(/opt/ruby-$version/bin/gem --version)",
	}
}

define gem($package, $version) {
	exec { "gem-exec-$package-$version":
		require => Geminstall["geminstall-$version"],
		command => "/opt/ruby-$version/bin/gem install $package",
		timeout => "-1",
	}
}

class ruby {
	include ruby::ruby_1_9_1
	include ruby::ruby_1_8_7

	exec { "geminstall-fetch":
		cwd => "/tmp",
		command => "wget http://rubyforge.org/frs/download.php/60718/rubygems-1.3.5.tgz",
	}
	exec { "geminstall-extract":
		require => Exec["geminstall-fetch"],
		cwd => "/tmp",
		command => "tar xf /tmp/rubygems-1.3.5.tgz",
		creates => "/tmp/rubygems-1.3.5",
		#unless => "UNLESS WHAT???",
	}
	# If anything happened in order, each geminstall would go here
	exec { "geminstall-remove":
		require => [
			Geminstall["geminstall-1.9.1-p243"],
			Geminstall["geminstall-1.8.7-p174"]
		],
		command => "rm -rf /tmp/rubygems-1.3.5*",
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
		bootstrap => "sh -c 'echo -e fcntl\\\\\\\\nopenssl\\\\\\\\nreadline\\\\\\\\nzlib >ext/Setup'",
	}
	geminstall { "geminstall-$version": version => "$version" }
	gem { "rip-$version":
		package => "rip",
		version => "$version",
	}
	gem { "rails-$version":
		package => "rails",
		version => "$version",
	}
	gem { "sqlite3-ruby-$version":
		require => Package["libsqlite3-dev"],
		package => "sqlite3-ruby",
		version => "$version",
	}
}

class ruby::ruby_1_8_7 {
	$version = "1.8.7-p174"
	sourceinstall { "ruby-$version":
		tarball => "ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-$version.tar.bz2",
		prefix => "/opt/ruby-$version",
		flags => "",
		bootstrap => "sh -c 'echo -e fcntl\\\\\\\\nopenssl\\\\\\\\nreadline\\\\\\\\nzlib >ext/Setup'",
	}
	geminstall { "geminstall-$version": version => "$version" }
	gem { "rip-$version":
		package => "rip",
		version => "$version",
	}
	gem { "rails-$version":
		package => "rails",
		version => "$version",
	}
	gem { "sqlite3-ruby-$version":
		require => Package["libsqlite3-dev"],
		package => "sqlite3-ruby",
		version => "$version",
	}
}
