require 'rake/testtask'

Rake::TestTask.new do |test|
  test.pattern = 'test/**/*_test.rb'
  test.libs << 'test'
end


begin
  require 'jeweler'

  Jeweler::Tasks.new do |gem|
    gem.name = 'ksk'
    gem.summary = 'CMS for bhf'
    gem.description = 'Fast and friendly'
    gem.email = 'anton.pawlik@gmail.com'
    gem.authors = ['Anton Pawlik']
    gem.files = Dir["{lib}/**/*", "{app}/**/*", "{config}/**/*", "vendor/assets/**/*"]
    gem.homepage = 'http://github.com/antpaw/ksk'
    gem.rubyforge_project = 'nowarning'
    gem.add_dependency 'bhf', '>= 0.5.0'
    gem.add_dependency 'stringex'
  end

  Jeweler::GemcutterTasks.new
end
