# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{nice_password}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kevin Skoglund", "Matthew Bergman"]
  s.date = %q{2010-07-06}
  s.description = %q{NicePassword creates easy-to-remember, reasonably-secure passwords by mixing dictionary words and random numbers.}
  s.email = %q{kevin@novafabrica.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "Gemfile",
     "MIT-LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/nice_password.rb",
     "lib/nice_password/core_ext.rb",
     "lib/nice_password/dictionaries/en.yml",
     "lib/nice_password/dictionaries/es.yml",
     "lib/nice_password/dictionaries/fr.yml",
     "lib/nice_password/errors.rb",
     "lib/nice_password/nice_password.rb",
     "rails/init.rb",
     "spec/nice_password/nice_password_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/novafabrica/nice_password}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Generate easy to read/remember passwords}
  s.test_files = [
    "spec/nice_password/nice_password_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

