#
# Be sure to run `pod lib lint JFImageSavePanel.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JFImageSavePanel"
  s.version          = "0.1.0"
  s.summary          = "NSSavePanel wrapper for image save dialogs, similar to those in Preview.app"
  s.description      = ""
  s.homepage         = "https://github.com/jaz303/JFImageSavePanel"
  s.screenshots      = "https://github.com/sebj/JFImageSavePanel/raw/master/screenshot.png"
  s.license          = 'MIT'
  s.author           = { "Jason Frame" => "jason@onehackoranother.com" }
  s.source           = { :git => "https://github.com/jaz303/JFImageSavePanel.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/jaz303'

  s.platform     = :osx
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resources = ['Pod/Assets/*.xib']

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
