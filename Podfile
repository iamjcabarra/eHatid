platform :ios, '9.0'

target 'eHatid' do
  use_frameworks!
  inhibit_all_warnings!

  target 'eHatidTests' do
    inherit! :search_paths
    pod 'Nimble', '8.0.2'
    pod 'Quick', '2.1.0'
  end

pod "KRProgressHUD", '3.4.2'
pod 'Moya', '13.0.1'
pod 'netfox', '1.18.0'
pod 'PromiseKit', '6.8.3'
pod 'SDWebImage', '5.0'
pod 'SnapKit', '4.2.0'
pod 'SwiftLint', '0.39.1'
pod 'XCGLogger', '6.1.0'

  post_install do |installer|         
    installer.pods_project.build_configurations.each do |config|             
  	  config.build_settings.delete('CODE_SIGNING_ALLOWED')             
  	  config.build_settings.delete('CODE_SIGNING_REQUIRED')             
  	  config.build_settings['ENABLE_BITCODE'] = 'NO'         
      config.build_settings['SWIFT_VERSION'] = '4.2'         
    end     
              
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.2'
      end
    end
  end

end

