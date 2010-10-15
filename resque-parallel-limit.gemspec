spec = Gem::Specification.new do |s|
  s.name              = 'resque-parallel-limit'
  s.version           = '0.0.1'
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = 'A Resque plugin; impose a parallel processing limit on jobs, based on their arguments.'
  s.homepage          = 'http://github.com/lantins/resque-parallel-limit'
  s.authors           = ['Luke Antins']
  s.email             = 'luke@lividpenguin.com'
  s.has_rdoc          = false

  s.files             = %w(LICENSE Rakefile README.md HISTORY.md)
  s.files            += Dir.glob('{test/*,lib/**/*}')
  s.require_paths     = ['lib']

  s.add_dependency('resque', '>= 1.8.0')
  s.add_development_dependency('test-unit')
  s.add_development_dependency('rr', '>= 1.0.0')
  s.add_development_dependency('yard')
  s.add_development_dependency('simplecov', '>= 0.3.0')

  s.description       = <<-EOL
  resque-parallel-limit is a [Resque][re] plugin, it allows you to impose a
  parallel processing limit on multiple jobs, based on their arguments.
  EOL
end