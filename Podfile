workspace 'SpeedTest'
platform :ios, '15.0'
project 'SpeedTest.xcodeproj'
source 'https://github.com/CocoaPods/Specs.git'
inhibit_all_warnings!
use_frameworks!

target "SpeedTestTests" do
    project 'SpeedTest.xcodeproj'
    pod 'RxSwift', '~> 5.0'
    pod 'RxSwiftAwait', :path => '../RxSwift'
end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
            end
        end
    end
end
