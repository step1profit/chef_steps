# -*- encoding: utf-8 -*-
# stub: chef_steps 0.0.1.20160519230913 ruby lib

Gem::Specification.new do |s|
  s.name = "chef_steps"
  s.version = "0.0.1.20160519230913"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Step1Profit"]
  s.date = "2016-05-20"
  s.description = "Removes all duplicates from an unsorted list of email addresses; leaving the resulting list in the original order (same as the input)"
  s.email = ["sales@step1profit.com"]
  s.executables = ["chef_steps"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.md", "README.txt", "History.txt"]
  s.files = ["Gemfile", "History.txt", "LICENSE", "Manifest.txt", "README.md", "README.txt", "Rakefile", "bin/chef_steps", "lib/chef_steps.rb", "lib/chef_steps/parser.rb", "lib/chef_steps/version.rb", "lib/core_ext/array/extract_options.rb", "test/files/email_output.txt", "test/files/emails.txt", "test/parser_test.rb", "test/test_helper.rb"]
  s.homepage = "https://github.com/step1profit/chef_steps"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--title", "ChefSteps", "--markup", "markdown", "--quiet"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "2.4.5.1"
  s.summary = "Removes all duplicates from an unsorted list of email addresses; leaving the resulting list in the original order (same as the input)"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe-yard>, [">= 0.1.2"])
      s.add_development_dependency(%q<hoe-bundler>, [">= 1.2"])
      s.add_development_dependency(%q<hoe-gemspec>, [">= 1.0"])
      s.add_development_dependency(%q<hoe-git>, [">= 1.6"])
      s.add_development_dependency(%q<minitest>, ["~> 5.9.0"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
      s.add_development_dependency(%q<redcarpet>, ["~> 3.3"])
      s.add_development_dependency(%q<hoe>, ["~> 3.15"])
    else
      s.add_dependency(%q<hoe-yard>, [">= 0.1.2"])
      s.add_dependency(%q<hoe-bundler>, [">= 1.2"])
      s.add_dependency(%q<hoe-gemspec>, [">= 1.0"])
      s.add_dependency(%q<hoe-git>, [">= 1.6"])
      s.add_dependency(%q<minitest>, ["~> 5.9.0"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
      s.add_dependency(%q<redcarpet>, ["~> 3.3"])
      s.add_dependency(%q<hoe>, ["~> 3.15"])
    end
  else
    s.add_dependency(%q<hoe-yard>, [">= 0.1.2"])
    s.add_dependency(%q<hoe-bundler>, [">= 1.2"])
    s.add_dependency(%q<hoe-gemspec>, [">= 1.0"])
    s.add_dependency(%q<hoe-git>, [">= 1.6"])
    s.add_dependency(%q<minitest>, ["~> 5.9.0"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
    s.add_dependency(%q<redcarpet>, ["~> 3.3"])
    s.add_dependency(%q<hoe>, ["~> 3.15"])
  end
end
