//
//  AppDelegate.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/05.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// NOTE: 後で消す
		let appDomain: String? = Bundle.main.bundleIdentifier
		UserDefaults.standard.removePersistentDomain(forName: appDomain!)
		
		UILabel.appearance().font = UIFont(name: "Keifont", size: 20)
		UILabel.appearance().textColor = UIColor.turquoiseColor()
		FirebaseApp.configure()
		if UserDefaults.standard.string(forKey: "team") != nil {
			print("AppDelegate set team")
			FirestoreManager.shared.setTeam(team: "A")
		}
		if !UserDefaults.standard.bool(forKey: "isRegistered") {
			UserDefaults.standard.set(false, forKey: "isRegistered")
		}
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}

}
