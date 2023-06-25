
source 'https://github.com/CocoaPods/Specs.git'
#source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
# source 'https://xmgit.ixm5.cn/client/iOS/XMBundleL0.git'

use_frameworks!

platform :ios, '12.0'

target 'MOONCIFilter' do
  
  pod 'DoraemonKit/Core', '~> 3.0.4', configurations: %w[Debug] # 必选
  
  # pod 'SnapKit'
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end
