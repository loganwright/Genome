Pod::Spec.new do |spec|
  spec.name         = 'Genome'
  spec.version      = '2.0.0-beta1'
  spec.license      = 'MIT'
  spec.homepage     = 'https://github.com/LoganWright/Genome'
  spec.authors      = { 'Logan Wright' => 'logan.william.wright@gmail.com' }
  spec.summary      = 'A simple, type safe, failure driven mapping library for serializing json to models in Swift'
  spec.source       = { :git => 'https://github.com/LoganWright/Genome.git', :tag => "#{spec.version}" }
  spec.source_files = 'Genome.playground/Sources/**/*.{swift}'
  spec.ios.deployment_target = "8.0"
  spec.osx.deployment_target = "10.9"
  spec.watchos.deployment_target = "2.0"
  spec.tvos.deployment_target = "9.0"
  spec.requires_arc = true
  spec.social_media_url = 'https://twitter.com/logmaestro'
end
