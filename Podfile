# Podfile
use_frameworks!

target 'Katanga' do
    pod 'RxSwift',    '3.0.0-beta.1'
    pod 'RxCocoa',    '3.0.0-beta.1'
    pod 'RxAlamofire', '3.0.0-beta.1'
end

target 'KatangaTests' do
    pod 'RxBlocking', '3.0.0-beta.1'
    pod 'RxTests',    '3.0.0-beta.1'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
