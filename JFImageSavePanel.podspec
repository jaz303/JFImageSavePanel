Pod::Spec.new do |s|
  s.name             = "JFImageSavePanel"
  s.version          = "1.0.2"
  s.summary          = "NSSavePanel wrapper for image save dialogs"
  s.description      = "An NSSavePanel wrapper for use with images, similar to Preview.app. Includes image type selector and, where applicable, output quality settings"
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
