# Uncomment the next line to define a global platform for your project

platform :ios, '12.0'

target 'smartPOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for smartPOS
	
  pod 'SlideMenuControllerSwift'
  pod "BouncyLayout"
  pod 'SwiftEntryKit', '1.2.7'
  
  
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
end
