
source 'https://github.com/CocoaPods/Specs.git'
#source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
# source 'https://xmgit.ixm5.cn/client/iOS/XMBundleL0.git'

use_frameworks!

platform :ios, '12.0'

target 'MountingAndFraming' do

  pod 'JPCrop', git: 'ssh://git@xmgit.ixm5.cn:10022/client/iOS/GitHub/JPCrop.git', tag: '0.0.4'
  pod 'SLClip', git: 'ssh://git@xmgit.ixm5.cn:10022/client/iOS/GitHub/SLClip.git', commit: 'f4da08cdd2f265ace6702bdac72eb99fc08c11ce'
  pod 'SOZOChromoplast', git: 'ssh://git@xmgit.ixm5.cn:10022/client/iOS/GitHub/SOZOChromoplast.git', tag: '0.0.4'

  pod 'SnapKit', git: 'ssh://git@xmgit.ixm5.cn:10022/client/iOS/GitHub/SnapKit.git', tag: '0.0.4'
  pod 'SDWebImage', git: 'ssh://git@xmgit.ixm5.cn:10022/client/iOS/GitHub/SDWebImage.git', tag: '0.0.4'
  pod 'lottie-ios', git: 'ssh://git@xmgit.ixm5.cn:10022/client/iOS/GitHub/lottie-ios.git', tag: '0.0.4'
  pod 'Toast-Swift', git: 'ssh://git@xmgit.ixm5.cn:10022/client/iOS/GitHub/Toast-Swift.git', tag: '0.0.4'
  pod 'TZImagePickerController', git: 'ssh://git@xmgit.ixm5.cn:10022/client/iOS/GitHub/TZImagePickerController.git', tag: '0.0.4'
  
  pod 'DoraemonKit/Core', '~> 3.0.4', configurations: %w[Debug] # 必选
  
  # pod 'swix', '1.0.11'
  
  pod 'Surge', '2.3.2'
  pod 'Highlightr'
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end
