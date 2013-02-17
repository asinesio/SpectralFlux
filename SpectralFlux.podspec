#
# Be sure to run `pod spec lint SpectralFlux.podspec' to ensure this is a
# valid spec.
#
# Remove all comments before submitting the spec. Optional attributes are commented.
#
# For details see: https://github.com/CocoaPods/CocoaPods/wiki/The-podspec-format
#
Pod::Spec.new do |s|
  s.name         = "Spectral Flux"
  s.version      = "0.0.1"
  s.summary      = "Detect beats in songs from the user's music library."
  s.description  = <<-DESC
                     Spectral Flux takes a song from the user's music library and scans through it, detecting beats.
                      * Asynchronous using blocks
                      * Can be used to render artwork from a song prior to playing it
                      * Supports any non-DRM music file in user's music library
                    DESC
  s.homepage     = "http://precognitiveresearch.com/content/SpectralFlux"

  s.license      = 'MIT'

  s.author       = { "Andy Sinesio" => "andy@precognitiveresearch.com" }
  
  s.source       = { :git => "http://github.com/asinesio/SpectralFlux/SpectralFlux.git", :tag => "0.0.1" }
  
  s.platform     = :ios, '5.0'
  
  s.source_files = 'Classes', 'Classes/**/*.{h,m}'

  #s.public_header_files = 'Classes/**/SpectralFlux.h'

  # Specify a list of frameworks that the application needs to link
  # against for this Pod to work.
  #
  # s.framework  = 'SomeFramework'
  s.frameworks = 'AVFoundation', 'Accelerate', 'AudioToolbox', 'MediaPlayer', 'CoreData'

  # Specify a list of libraries that the application needs to link
  # against for this Pod to work.
  #
  # s.library   = 'iconv'
  # s.libraries = 'iconv', 'xml2'

  # If this Pod uses ARC, specify it like so.
  #
  # s.requires_arc = true

  # If you need to specify any other build settings, add them to the
  # xcconfig hash.
  #
  # s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }

  # Finally, specify any Pods that this Pod depends on.
  #
  # s.dependency 'JSONKit', '~> 1.4'
end
