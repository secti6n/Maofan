project 'Maofan.xcodeproj'

# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'Maofan' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!

  # Pods for Maofan
  
    pod 'YYText'
    pod 'YYWebImage'
    pod 'SwiftyJSON'
    pod 'OAuthSwift'
    
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
