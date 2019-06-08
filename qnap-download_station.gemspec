Gem::Specification.new do |s|
	s.name         = "qnap-download_station"
	s.version      = "0.0.4"
	s.summary      = "Interface to the Download Station API"
	s.description  = "Manage your downloads in Download Station"
	s.authors      = "cyclotron3k"
	s.files        = ["lib/qnap/download_station.rb", "Rakefile", "qnap-download_station.gemspec", "README.md"]
	s.test_files   = ["test/test_download_station.rb"]
	s.homepage     = "https://github.com/cyclotron3k/qnap-download_station"
	s.license      = "MIT"
	s.required_ruby_version = ">= 1.9.0"
end
