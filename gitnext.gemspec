Gem::Specification.new do |s|
  s.name     = 'gitnext'
  s.version  = '0.1.2'
  s.summary  = 'Use next or previous to navigate through a git repository'
  s.description = "A simple command line tool to use when doing presentations."
  s.platform = Gem::Platform::RUBY
  s.authors  = ["Nigel"]
  s.email    = ["nigelr@brisbanerails.com"]
  s.homepage = "http://github.com/nigelr/gitnext"
  s.has_rdoc = false

  s.files    = Dir.glob("{spec,lib}/**/*.rb") +
      Dir.glob("bin/*") +
      %w(gitnext.gemspec    )

  s.bindir       = 'bin'
  s.require_path = 'lib'
  s.executables << %q{gitnext}

  s.add_development_dependency 'rspec', '~> 2.1.0'
  s.add_dependency 'git', '1.2.5'
end
