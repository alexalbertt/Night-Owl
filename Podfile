# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Night Owl' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Night Owl
  pod 'Firebase/Storage'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'JSQMessagesViewController'
  pod 'FSPagerView'
  pod 'TextFieldEffects'
  
  
  post_install do |installer|
	  installer.pods_project.build_configurations.each do |config|
		  config.build_settings.delete('CODE_SIGNING_ALLOWED')
		  config.build_settings.delete('CODE_SIGNING_REQUIRED')
	  end
  end
end
