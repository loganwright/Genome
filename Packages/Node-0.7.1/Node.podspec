Pod::Spec.new do |spec|
  spec.name         = 'Node'
  spec.version      = '0.0.0'
  spec.license      = 'MIT'
  spec.homepage     = 'https://github.com/qutheory/node'
  spec.authors      = { 'Qutheory Team' => 'team@qutheory.io' }
  spec.summary      = 'A formatted data encapsulation meant to facilitate the transformation from one object to another'
  spec.source       = { :git => 'https://github.com/qutheory/node.git', :tag => "#{spec.version}" }
  spec.ios.deployment_target = "8.0"
  spec.osx.deployment_target = "10.9"
  spec.watchos.deployment_target = "2.0"
  spec.tvos.deployment_target = "9.0"
  spec.requires_arc = true
  spec.social_media_url = 'https://twitter.com/qutheory'
  spec.default_subspec = "Default"

  spec.subspec "Default" do |ds|
    ds.source_files = 'Sources/Node/**/*.{swift}'
  end

end
