# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'runkick-dev' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for runkick-dev

pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'RevealingSplashView'
pod 'Firebase/Analytics'
pod 'Firebase/Storage'
pod 'Firebase/Messaging'
pod 'Firebase/Functions'
pod 'ActiveLabel'
pod 'IQKeyboardManagerSwift'
pod 'Kingfisher'
pod 'CodableFirebase'
pod 'Stripe'
pod 'Alamofire'
pod 'Gallery'
pod 'InstantSearchClient'
pod 'EmptyDataSet-Swift'
pod 'NVActivityIndicatorView/AppExtension'
pod 'JGProgressHUD'
pod 'PayPal-iOS-SDK'


    post_install do |installer|
     installer.pods_project.targets.each do |target|
         target.build_configurations.each do |config|
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 9.0
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
            end
         end
     end
  end


end
