#
# Be sure to run `pod lib lint DataStoreKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name = 'DataStoreKit'
s.version = '3.0.5'
s.license = 'MIT'
s.summary = 'Consistent interface for accessing data across different ios storage and networking layers'
s.homepage = 'https://github.com/poolmyride/DataStoreKit'

s.authors = { 'Pool My Ride' => 'cuterajat26@gmail.com' }
s.source           = { :git => "https://github.com/poolmyride/DataStoreKit.git", :tag => s.version.to_s }

s.ios.deployment_target = '8.0'
s.osx.deployment_target = '10.10'
s.tvos.deployment_target = '9.0'
s.watchos.deployment_target = '2.0'

s.source_files = 'Pod/Classes/**/*.swift'

end
