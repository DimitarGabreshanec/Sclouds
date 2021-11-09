# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Samscloud' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for Samscloud
  pod 'KeychainSwift', '~> 18.0.0'
  pod 'TPKeyboardAvoiding'
  pod 'Alamofire', '~> 4.5'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'NVActivityIndicatorView'
  pod 'SDWebImage'
  pod 'Firebase/Core'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'SnapKit'
  pod 'FirebaseInstanceID', '2.0.0'
  #pod 'SocketRocket'
  pod 'Starscream', '~> 3.1.1'
  pod 'LFLiveKit'
  pod 'GoogleWebRTC'
  target 'SamscloudTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'SamscloudUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
          end
      end
  end
end
