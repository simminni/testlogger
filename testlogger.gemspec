Gem::Specification.new do |s|
  s.name        = "testlogger"
  s.version     = "0.0.2"
  s.summary     = "log your test results into an xml file using testlogger."
  s.date        = "2013-09-11"
  s.description = "log your test results into an xml file using testlogger. Special support for nodes like test-script test-case test-step for QA Automation."
  s.authors     = ["Shiva Krishna Imminni"]
  s.email       = ["shivausum@gmail.org"]
  s.homepage    = "http://questionselenium.com/"
  s.files       = ["lib/testlogger.rb","conf.rb"]
	s.add_runtime_dependency 'nokogiri', ">= 0"
	s.license = 'MIT'
end