workspace 'SpeedTest'
platform :ios, '15.6'
project 'SpeedTest.xcodeproj'
source 'https://github.com/CocoaPods/Specs.git'
inhibit_all_warnings!
use_frameworks!

target 'SpeedTest' do
    project 'SpeedTest.xcodeproj'
    pod 'RxSwift', '~> 5.0'
    pod 'RxSwiftAwait', :path => '../RxSwift'
    pod 'RxSwiftUnfair', :path => '../RxSwiftOSUnfairLock'
end

target 'SpeedTestCmd' do
    platform :osx, '10.15'

    project 'SpeedTest.xcodeproj'
    pod 'RxSwift', '~> 5.0'
    pod 'RxSwiftAwait', :path => '../RxSwift'
    pod 'RxSwiftUnfair', :path => '../RxSwiftOSUnfairLock'
end

target "SpeedTestTests" do
    project 'SpeedTest.xcodeproj'
    pod 'RxSwift', '~> 5.0'
    pod 'RxSwiftAwait', :path => '../RxSwift'
    pod 'RxSwiftUnfair', :path => '../RxSwiftOSUnfairLock'
end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.6'
                config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.15'
                config.build_settings['MACH_O_TYPE'] = 'staticlib'
            end
        end
    end
end
