platform :ios, '9.0'
use_frameworks!

def main_pods
    	pod 'FBSDKCoreKit', '4.11'
        pod 'FBSDKLoginKit', '4.11'
        pod 'Bond', '4.3.1'
	pod 'AwesomeCache', '3.0.1'
        pod 'IQKeyboardManager', '4.0.2'
        pod 'SVProgressHUD', '2.0.3'
        pod 'DynamicBlurView', '1.1.1'
        pod 'ImagePicker', '1.4.1'
        pod 'FLTextView', :git => 'https://github.com/freeletics/FLTextView.git'
        pod 'Kingfisher', '2.4.0'
        pod 'DualSlideMenu', '1.7.1'
        pod 'SlackTextViewController', '1.9.2'
        pod 'DZNEmptyDataSet', '1.8'
        pod 'LKAlertController', '1.9.1'
	pod 'R.swift', '2.4.0'
	pod 'ThreeDegreesClient', :git => 'https://github.com/3degreesapp/3degrees-swift-client.git'
	pod 'SwiftPaginator', '1.0.1'
	pod 'PureLayout', '3.0.2'
	pod 'JTAppleCalendar', '5.0.1'
	pod 'SwiftMoment', '0.5.1'
	pod 'UIImageView-Letters', '1.1.4'
	pod 'Router', '1.0.0'
	pod 'Fabric'
	pod 'Crashlytics'
	pod 'TSMarkdownParser', '2.1.1'
end

def testing_pods
    pod 'Quick', '0.9.3' 
    pod 'Nimble', '4.1.0'
end

target '3Degrees' do
	main_pods
end

target '3DegreesTests' do
	main_pods
	testing_pods
end
