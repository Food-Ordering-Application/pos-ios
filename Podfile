# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'smartPOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for smartPOS
  
  pod 'QRCodeReader.swift', '~> 10.1.0'
  pod 'SlideMenuControllerSwift'
  pod "BouncyLayout"
  pod 'SwiftEntryKit', '1.2.7'
  pod 'EmptyDataSet-Swift', '~> 5.0.0'
  pod 'PromiseKit'
  pod 'Moya'
  pod 'SkeletonView'
  pod 'SnapKit'
  pod 'NumPad'
  pod 'ReachabilitySwift'
  pod 'SwiftEventBus', :tag => '5.1.0', :git => 'https://github.com/cesarferreira/SwiftEventBus.git'
  pod 'CoreStore', '~> 8.0'
  pod 'IQKeyboardManagerSwift'
  pod 'AnimatedField'
  pod 'TextFieldEffects'
  pod 'Schedule', '~> 2.0'
  pod 'SwiftDate', '~> 5.0'
  pod 'PushNotifications'
  pod 'loady'
  pod 'PusherSwift'
  pod 'Kingfisher'

  target 'smartPOSTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'smartPOSUITests' do
    # Pods for testing
  end

end
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    # Workaround for CocoaPods issue: https://github.com/CocoaPods/CocoaPods/issues/7606
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
    
    # Do not need debug information for pods
    config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
    
    # Disable Code Coverage for Pods projects - only exclude ObjC pods
    config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
    config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = ['$(FRAMEWORK_SEARCH_PATHS)']
    
    config.build_settings['SWIFT_VERSION'] = '4.0'
  end
  
  installer.pods_project.targets.each do |target|
      if ['SlideMenuControllerSwift', 'NumPad'].include? target.name
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '4.0'
        end
      end
    end
end
