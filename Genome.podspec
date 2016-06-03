Pod::Spec.new do |spec|
  spec.name         = 'Genome'
  spec.version      = '3.0.0-beta'
  spec.license      = 'MIT'
  spec.homepage     = 'https://github.com/LoganWright/Genome'
  spec.authors      = { 'Logan Wright' => 'logan.william.wright@gmail.com' }
  spec.summary      = 'A simple, type safe, failure driven mapping library for serializing json to models in Swift'
  spec.source       = { :git => 'https://github.com/LoganWright/Genome.git', :tag => "#{spec.version}" }
  spec.ios.deployment_target = "8.0"
  spec.osx.deployment_target = "10.9"
  spec.watchos.deployment_target = "2.0"
  spec.tvos.deployment_target = "9.0"
  spec.requires_arc = true
  spec.social_media_url = 'https://twitter.com/logmaestro'
  spec.default_subspec = "Default"

  spec.subspec "Core" do |cs|
    cs.source_files = 'Sources/Genome/**/*.{swift}'
  end

  spec.subspec "Foundation" do |fs|
    fs.source_files = 'Sources/GenomeFoundation/**/*.{swift}'
    fs.dependency 'Genome/Core'
  end

  spec.subspec "Serialization" do |ss|
    ss.source_files = 'Sources/GenomeSerialization/**/*.{swift}'
    ss.dependency 'Genome/Core'
  end

  spec.subspec "Default" do |ds|
    ds.dependency 'Genome/Serialization'
    ds.dependency 'Genome/Foundation'
  end

  spec.subspec "CoreData" do |cd|
    cd.source_files = 'Sources/Genome/CoreData/**/*.{swift}'
    cd.dependency 'Genome/Core'
    cd.dependency 'Genome/Foundation'
    cd.frameworks = 'CoreData'
  end
end
