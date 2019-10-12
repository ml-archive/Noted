# coding: utf-8

Pod::Spec.new do |spec|

  spec.name         = "Noted"
  spec.version      = "2.2.2"
  spec.summary      = "A minimalistic and effective replacement for NSNotificationCenter, that promotes the observer pattern and keeps weak references to it's observers."
  spec.homepage     = "https://github.com/nodes-ios/Noted"

  spec.author       = { 'Name' => 'chco@nodes.dk' }
  spec.license      = { :type => 'MIT', :file => './LICENSE' }

  spec.platform     = :ios
  spec.source       = { :git => "https://github.com/nodes-ios/Noted.git", :tag => "#{spec.version}" }

  spec.ios.deployment_target = '8'
  spec.ios.vendored_frameworks = 'Noted.framework'

  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }

  spec.subspec 'Noted' do |subspec|
    subspec.ios.source_files = 'Noted/Classes/**/*.swift'
  end
end
