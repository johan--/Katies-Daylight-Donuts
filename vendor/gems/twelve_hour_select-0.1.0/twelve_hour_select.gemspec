# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{twelve_hour_select}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tim Matheson"]
  s.date = %q{2010-04-20}
  s.description = %q{Simple Time Select Helper}
  s.email = %q{me@timmatheson.com}
  s.extra_rdoc_files = ["lib/twelve_hour_select.rb", "README.rdoc"]
  s.files = ["init.rb", "lib/twelve_hour_select.rb", "Manifest", "Rakefile", "README.rdoc", "spec/lib/twelve_hour_select_spec.rb", "spec/spec_helper.rb", "twelve_hour_select.gemspec"]
  s.homepage = %q{}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Twelve_hour_select", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{twelve_hour_select}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Simple Time Select Helper}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
