# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'ShopAppLaza' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

pod 'SideMenu'
pod 'CreditCardForm'

end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
               end
          end
   end
end