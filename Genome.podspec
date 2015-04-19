Pod::Spec.new do |spec|
  spec.name         = 'Genome'
  spec.version      = '0.1'
  spec.license      = 'MIT'
  spec.homepage     = 'https://github.com/LoganWright/Genome'
  spec.authors      = { 'Logan Wright' => 'logan.william.wright@gmail.com' }
  spec.summary      = 'A set of classes for mapping JSON responses to modeled objects'
  spec.source       = { :git => 'https://github.com/LoganWright/Genome.git', :tag => '0.1' }
  spec.source_files = 'Genome/Source/*.{h,m}'
  spec.requires_arc = true
  spec.social_media_url = 'https://twitter.com/logmaestro'
end
