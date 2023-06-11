# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'

target 'SmoothTennis' do
  use_frameworks!
  pod 'Appirater'
  pod 'Firebase/Core'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Auth'
  pod 'Firebase/Analytics'
  pod 'SDWebImage'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end