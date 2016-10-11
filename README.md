# 3degrees

## Build Environment


**IDE**: Xcode 7.3.1 (7D1014)

**Programming language**: Swift 2.2 built-in to the Xcode 7.3.1

**Dependency manager**: [Cocoapods] (https://cocoapods.org) v1.0.1

In order to compile and run the app, please follow these steps:

0. [Install](https://guides.cocoapods.org/using/getting-started.html) Cocoapods v1.0.1 
1. Run `pod install` in terminal in the project root folder where the `Podfile` is and wait untill it will complete install dependencies.
2. Run from within the same folder `open 3Degrees.xcworkspace`
3. Now you can choose any device in `Target-Device` menu in Xcode top bar and run app on it.

## Fabric & Crashlytics

Project contains as a dependency crash reporting tool `Crashlytics`, it is a part of `Twitter Fabric` platform. 
Here is some info about Fabric and Crashlytics set up:

1. To distribute builds via Fabric you need to download Fabric.app from this [link](https://fabric.io/downloads/apple)
2. Follow the instructions from the website, then run it on your mac and sign in to your account.
3. You should see the list of active apps you have access to. 
4. Fabric and Crashlytics frameworks were added to the project as a depndencies with Cocoapods(check out Podfile). 
5. Also for project `3Degrees` target settings under the `Build Phases` tab you should see `Run Script` phase(it is the last in the list). So here is a bash script and xcode runs it each time when project is built. This script needed to update project Info.plist file with unique key which is used during the app run to authorize with web service and upload reports about any crashes happened.
6. Fabric and Crashlytics are initialized in `AppController.swift` file in `func handleAppStart(launchOptions: [NSObject: AnyObject]?)` method.

In order to learn how to distribute builds via Fabric, please read this [guide](https://docs.fabric.io/apple/beta/beta-walkthrough.html). In order to learn how to `Archive` the app please continue reading.

## App Store submission

There is a comprehensive [Document from Apple](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/Introduction/Introduction.html) on how to distribute build and upload them to App Store.

Basic steps: 

1. Make sure you have set right team for your app in xcode in target settings(click on project, choose 3Degrees target, General tab). 
2. Signing profiles for `Debug` and `Release` modes are set as Automatic, so xcode should pick up right signing identities and certificates.
3. Choose in `Target-Device` menu in Xcode top bar `3Degrees` target and `Generic iOS Device ` as a device, then from Xcode application context menu(status bar menu in OS X) choose `Product` menu and click on `Archive`. 

Anyway, you must read above mentioned doc if you are not familiar with Xcode and App Distribution. It describes how to download provisioning profile from Xcode, how to archive the app and etc.

There are 2 different types of provisioning profiles for build distribution: *AdHoc* and *AppStore*. *AdHoc* profile contains list of UUIDs of devices where a build signed with this profile could be installed. And *AppStore* profile doesn't contain any info about devices and you cannot sign a build with it and distribute it through Fabric or Diawi, App Store build could only be uloaded to [iTunesConnect](itunesconnect.apple.com) and distributed via TestFlight or submitted to App Store.

## To distribute a test version

1. Go to 3Degrees => General and set the Version and Build
2. Ensure that the Team is correct
3. Product => Archive
4. Wait...
5. Export build as AdHoc
6. Save locally
7. Switch to Fabric
8. Choose Distributions => Archives => new build => Distribute
9. Choose users to invite
