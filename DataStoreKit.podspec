#
# Be sure to run `pod lib lint DataStoreKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DataStoreKit"
  s.version          = "1.1.1"
  s.summary          = "Consistent interface for accessing data across different ios storage components"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
    DataStoreKit is a light-weight collection of classes providing the tools for modelling and interacting with data collections and objects. It is designed to work with a variety of data storage mediums(CoreData,Network,File,NSUserDefaults), and provide a consistent interface for accessing data across different storage components
DESC

  s.homepage         = "https://github.com/poolmyride/DataStoreKit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Rajat Talwar" => "cuterajat26@gmail.com" }
  s.source           = { :git => "https://github.com/poolmyride/DataStoreKit.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/rtalwar26'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'DataStoreKit' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit', 'CoreData'
  # s.dependency 'AFNetworking', '~> 2.3'
end
