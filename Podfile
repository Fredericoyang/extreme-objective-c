platform:ios,'12.0'
#use_frameworks!
def pods
    pod 'AFNetworking', '~>4.0.0'
    pod 'FMDB', '~>2.7.0'
    pod 'JSONModel', '~>1.8.0'
    pod 'SDAutoLayout', '~> 2.2.0'
    pod 'MJRefresh', '~> 3.4.0'
    pod 'SVProgressHUD', '~>2.2.0'
    pod 'SDWebImage', '~>5.8.0'
end
target 'extreme' do
   pods
end
target 'ExtremeFramework' do
   pods
end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      target.build_settings(config.name)['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
    end
  end
end
