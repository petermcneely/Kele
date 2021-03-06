Gem::Specification.new do |s|
	s.name 			= 'kele'
	s.version 		= '0.0.1'
	s.date 			= '2016-08-03'
	s.summary 		= 'Kele API Client'
	s.description 	= 'A client for the Bloc API'
	s.authors		= ['Peter McNeely']
	s.email 		= 'pete.mcneely@gmail.com'
	s.files 		= `git ls-files`.split($/)
	s.require_paths = ["lib"]
	s.homepage 		= 
		'http://rubygems.org/gems/kele'
	s.license 		= 'MIT'
	s.add_runtime_dependency 'httparty', '~> 0.13'
	s.add_runtime_dependency 'json', '1.8.3'
	s.add_development_dependency 'rspec', '~>3.5'
	s.add_development_dependency 'vcr', '~> 3.0'
end