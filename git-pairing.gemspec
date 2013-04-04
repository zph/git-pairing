spec = Gem::Specification.new do |s| 
  s.name = 'git-pairing'
  s.version = "0.2.4"
  s.author = "Steve Quince"
  s.email = 'steve.quince@gmail.com'
  s.homepage = 'https://github.com/squince/git-pairing'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Configures git to attribute code commits to multiple authors.'
  s.description = 'Keeps track of co-authors of git commits'

  # Add other files here as they are created in the project

  s.files = Dir.glob("{bin,lib}/**/*")
  s.require_paths << 'lib'
  s.has_rdoc = false
  s.bindir = 'bin'
  s.executables   = 'git-pair'

  # List dependencies here
  s.add_dependency('awesome_print')
  s.add_dependency('highline')
  s.add_dependency('win32console') if ($platform.to_s =~ /win32|mswin|mingw|cygwin/ || $platform.to_s == 'ruby')
  s.add_development_dependency('rake')
  s.add_runtime_dependency('gli','2.5.4')
end
