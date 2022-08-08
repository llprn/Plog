# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Plog' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Plog

  target 'PlogTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PlogUITests' do
    # Pods for testing
  end


pod 'IQKeyboardManagerSwift'
pod 'KakaoSDK'
post_install do |installer| installer.pods_project.targets.each do |target| target.build_configurations.each do |config| config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES' end end end


end
