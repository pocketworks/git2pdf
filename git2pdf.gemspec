# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "git2pdf"
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tobin Harris"]
  s.date = "2014-07-01"
  s.description = "For those that use Kanban or Scrum and want to print their cards so they can stick em on the wall"
  s.email = "tobin@pocketworks.co.uk"
  s.executables = ["git2pdf"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/git2pdf",
    "git2pdf.gemspec",
    "lib/assets/fonts/Lato-Black.ttf",
    "lib/assets/fonts/Lato-BlackItalic.ttf",
    "lib/assets/fonts/Lato-Bold.ttf",
    "lib/assets/fonts/Lato-BoldItalic.ttf",
    "lib/assets/fonts/Lato-Hairline.ttf",
    "lib/assets/fonts/Lato-HairlineItalic.ttf",
    "lib/assets/fonts/Lato-Italic.ttf",
    "lib/assets/fonts/Lato-Light.ttf",
    "lib/assets/fonts/Lato-LightItalic.ttf",
    "lib/assets/fonts/Lato-Regular.ttf",
    "lib/assets/images/pocketworks.png",
    "lib/git2pdf.rb",
    "test/helper.rb",
    "test/test_git2pdf.rb"
  ]
  s.homepage = "http://github.com/pocketworks/git2pdf"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Bash util to print sexy cards from your github issues"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<prawn>, [">= 0"])
      s.add_runtime_dependency(%q<thor>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<prawn>, [">= 0"])
      s.add_dependency(%q<thor>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<prawn>, [">= 0"])
    s.add_dependency(%q<thor>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end

