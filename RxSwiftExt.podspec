Pod::Spec.new do |s|
  s.name         = "RxSwiftExt"
  s.version      = "2.1.0"
  s.summary      = "RxSwift operators not found in the core distribtion"
  s.description  = <<-DESC
    A collection of operators for RxSwift adding commonly requested operations not found in the core distribution
    of RxSwift.
                   DESC
  s.homepage     = "https://github.com/RxSwiftCommunity/RxSwiftExt"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "RxSwiftCommunity" => "https://github.com/RxSwiftCommunity" }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.source       = { :git => "https://github.com/RxSwiftCommunity/RxSwiftExt.git", :tag => s.version }
  s.source_files  = "Source/*.swift"
  s.frameworks  = "Foundation"
  s.dependency "RxSwift", '~> 3.0'
end
