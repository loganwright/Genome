Pod::Spec.new do |spec|
  spec.name         = 'Genome'
  spec.version      = '42.0.0'
  spec.license      = 'MIT'
  spec.homepage     = 'https://github.com/LoganWright/Genome'
  spec.authors      = { 'Logan Wright' => 'logan.william.wright@gmail.com' }
  spec.summary      = 'A simple, type safe, failure driven mapping library for serializing data to models in Swift'
  spec.source       = { :git => 'https://github.com/LoganWright/Genome.git', :tag => "#{spec.version}" }
  spec.ios.deployment_target = "8.0"
  spec.osx.deployment_target = "10.9"
  spec.watchos.deployment_target = "2.0"
  spec.tvos.deployment_target = "9.0"
  spec.requires_arc = true
  spec.social_media_url = 'https://twitter.com/logmaestro'
  spec.default_subspec = "Default"

  spec.subspec "Default" do |ss|
    ss.source_files = 'Sources/Genome/**/*.{swift}'
    ss.exclude_files = 'Sources/Genome/Genome+Exports.swift'
    ss.dependency 'Genome/Core'
    ss.dependency 'Genome/Foundation'
  end

  spec.subspec "Core" do |ss|
    ss.source_files = 'Sources/Genome/Mapping/**/*.{swift}'
    ss.dependency 'Genome/Node'
  end

  spec.subspec "Node" do |ss|
    ss.source_files = 'Packages/Node-*/Sources/Node/**/*.{swift}'
    ss.exclude_files = 'Packages/Node-*/Sources/Node/Core/Node+Exports.swift'
    ss.dependency 'Genome/Polymorphic'
    ss.dependency 'Genome/PathIndexable'
  end

  spec.subspec "Polymorphic" do |ss|
    ss.source_files = 'Packages/Polymorphic-*/Sources/**/*.{swift}'
  end

  spec.subspec "PathIndexable" do |ss|
    ss.source_files = 'Packages/PathIndexable-*/Sources/**/*.{swift}'
  end

  spec.subspec "Foundation" do |ss|
    ss.source_files = 'Sources/GenomeFoundation/**/*.{swift}'
    ss.exclude_files = 'Sources/GenomeFoundation/GenomeFoundation+Exports.swift'
    ss.dependency 'Genome/Core'
  end

  spec.subspec "CoreData" do |ss|
    ss.source_files = 'Sources/GenomeCoreData/**/*.{swift}'
    ss.dependency 'Genome/Foundation'
    ss.dependency 'Genome/Core'
    ss.frameworks = 'CoreData'
  end
end
