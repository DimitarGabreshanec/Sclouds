# Samscloud-App-iOS

This is the repository for Samscloud iOS App.
This README would normally document whatever steps are necessary to get the
application up and running.

Supported OS & SDK Versions
-----------------------------

* Supported build target - iOS 11.0 and later / Mac OS 10.14 (18A391), Xcode 10.1 (10B61)


Build & Run Project
-----------------------------


Step 1: Pull the latest source code from the Samscloud repository.


Step 2: Setup CocoaPods (CocoaPods manages library dependencies for your Xcode projects)

Update Ruby gem. Open Terminal and type the following command:

sudo gem update --system

Install CocoaPods. Type this command:

sudo gem install cocoapods

Setup CocoaPods. Type this command:

pod setup


Step 3: Install library dependencies for Xcode project

Change directory to Samscloud XCode project root directory (where Samscloud.xcodeproj file is placed). Type this command on terminal:

pod install


Step 4: Open the new workspace created by CocoaPods. From now on, you will need to open the workspace instead of the project. Just double click the Samscloud.xcworkspace file, or type:

open Samscloud.xcworkspace


Step 5: Build and run app.

