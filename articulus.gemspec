# -*- encoding: utf-8 -*-
require File.expand_path('../lib/articulus/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Rick Button"]
  gem.email         = ["rickb@extemprep.com"]
  gem.description   = %q{Article Downloading and Parsing Library}
  gem.summary       = %q{Downloads and parses news articles in a clean format}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "articulus"
  gem.require_paths = ["lib"]
  gem.version       = Articulus::VERSION
end
