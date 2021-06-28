Pod::Spec.new do |s|
  s.name         = "RealmWrapper"
  s.version      = "1.4.3"
  s.summary      = "Simple wrapper for RealmSwift"
  s.description  = "This is simple wrapper that wrapper is easy to use transaction synchronous processing and realm notifications."
  s.homepage     = "https://github.com/k-lpmg/RealmWrapper"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "DongHee Kang" => "kanglpmg@gmail.com" }
  s.source       = { :git => "https://github.com/k-lpmg/RealmWrapper.git", :tag => s.version.to_s }
  s.documentation_url = "https://github.com/k-lpmg/RealmWrapper/blob/master/README.md"

  s.ios.source_files  = "Sources/**/*.swift"
  s.ios.deployment_target = "9.0"

  s.swift_version = '5.0'

  s.dependency 'RealmSwift'
end
