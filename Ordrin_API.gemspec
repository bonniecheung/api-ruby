# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "Ordrin_API"
  s.version = "0.9.27"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Bates - OrdrIn"]
  s.date = "2011-09-13"
  s.description = "OrdrIn Ruby Wrapper for the API"
  s.email = ""
  s.extra_rdoc_files = ["README.md", "lib/ordrin.rb"]
  s.files = ["Manifest", "Ordrin_API.gemspec", "README.md", "Rakefile", "lib/ordrin.rb"]
  s.homepage = "http://ordr.in"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Ordrin_API", "--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "ordrin_api"
  s.rubygems_version = "1.8.10"
  s.summary = "OrdrIn Ruby Wrapper for the API"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

