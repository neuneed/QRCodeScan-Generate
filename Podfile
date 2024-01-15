source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!
inhibit_all_warnings!


def objc_pods
    pod 'Bugly'
    pod 'SVProgressHUD'
    pod 'Onboard'
end


target 'QRCode' do
    pod 'SnapKit', '~> 3.0.0'
    pod 'PKHUD', '~> 4.0'
    pod 'JSQWebViewController'
    pod 'SwiftyUserDefaults'
    objc_pods
#    pod 'RealmSwift'
end


#post_install do |installer|
#    installer.pods_project.targets.each do |target|
#        target.build_configurations.each do |config|
#            config.build_settings['SWIFT_VERSION'] = '3.0'
#        end
#    end
#end
