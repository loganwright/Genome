Pod::Spec.new do |spec|
  spec.name         = 'Genome'
  spec.version      = '42.0.0'
  spec.license      = 'MIT'
  spec.homepage     = 'https://github.com/LoganWright/Genome'
  spec.authors      = { 'Logan Wright' => 'logan.william.wright@gmail.com' }
  spec.summary      = 'A simple, type safe, failure driven mapping library for serializing json to models in Swift'
  spec.source       = { :git => 'https://github.com/LoganWright/Genome.git', :tag => "#{spec.version}" }
  spec.ios.deployment_target = "0.0"
  spec.osx.deployment_target = "10.9"
  spec.watchos.deployment_target = "2.0"
  spec.tvos.deployment_target = "9.0"
  spec.requires_arc = true
  spec.social_media_url = 'https://twitter.com/logmaestro'
  spec.default_subspec = "Default"

  spec.subspec "Default" do |ds|
    ds.dependency 'Genome/Node'
  end

  spec.subspec "Node" do |n|
    n.source_files = 'Packages/Node-*/Sources/Node/**/*.{swift}'
    n.exclude_files = 'Packages/Node-*/Sources/Node/**/exports.{swift}'
  end

  # spec.subspec "Foundation" do |fs|
  #   fs.source_files = 'Sources/Genome/Foundation/**/*.{swift}'
  #   fs.dependency 'Genome/Core'
  # end
  #
  # spec.subspec "PureJson" do |js|
  #   js.source_files = 'Sources/Genome/Json/**/*.{swift}'
  #   js.dependency 'Genome/Core'
  #   js.dependency 'PureJsonSerializer'
  # end
  #
  # spec.subspec "Default" do |ds|
  #   ds.dependency 'Genome/PureJson'
  #   ds.dependency 'Genome/Foundation'
  # end
  #
  # spec.subspec "CoreData" do |cd|
  #   cd.source_files = 'Sources/Genome/CoreData/**/*.{swift}'
  #   cd.dependency 'Genome/Core'
  #   cd.dependency 'Genome/Foundation'
  #   cd.frameworks = 'CoreData'
  # end
end
