#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint lottie_thorvg.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'lottie_thorvg'
  s.version          = '0.0.2'
  s.summary          = 'Lottie for Flutter powered by ThorVG'
  s.description      = <<-DESC
This Lottie for Flutter uses ThorVG as a renderer, provides a high performance and compact size.
                      DESC
  s.homepage         = 'https://github.com/tinyjin/lottie-thorvg'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Jinny You' => 'baram991103@gmail.com' }

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source           = { :path => '.' }
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.libraries = ["c++", "z"]
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.vendored_libraries = 'Frameworks/libthorvg.dylib'

  s.swift_version = '5.0'
end
