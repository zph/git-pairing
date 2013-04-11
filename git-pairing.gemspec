# $platform global variable. In all other cases, we figure it out from RUBY_PLATFORM.
$platform ||= RUBY_PLATFORM

Gem::Specification.new do |s|
  s.name = 'git-pairing'
  s.version = "0.3.5"
  s.author = "Steve Quince"
  s.email = 'steve.quince@gmail.com'
  s.homepage = 'https://github.com/squince/git-pairing'
  s.platform = Gem::Platform::RUBY
  s.summary = ''
  s.description = 'Allows you to attribute code commits to multiple authors'
  s.requirements << 'git must be installed'

  # Add other files here as they are created in the project
  s.files = Dir.glob("{bin,lib}/**/*")
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.md']
  s.rdoc_options << '--title' << 'git-pairing' << '--main' << 'README.md'
  s.bindir = 'bin'
  s.executables   = ['git-pair', 'git-solo', 'git-whoami', 'git-who']

  # List dependencies here
  s.add_dependency('trollop', '>= 2.0')
  s.add_dependency('paint', '>= 0.8.5')
  s.add_dependency('awesome_print', '>= 1.1.0')
  s.add_dependency('highline', '>= 1.6.15')
  s.add_dependency('win32console') if ($platform.to_s =~ /win32|mswin|mingw|cygwin/ || $platform.to_s == 'ruby')
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
end
