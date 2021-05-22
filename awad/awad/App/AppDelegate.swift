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
		FirebaseApp.configure()
		// UI周り
		UILabel.appearance().font = UIFont(name: "Keifont", size: 20)
		UILabel.appearance().textColor = UIColor.turquoiseColor()
		let team: String? = UserDefaults.standard.string(forKey: "team")
		if let team: String = team {
			FirestoreManager.shared.setTeam(team: team)
		}
		if UserDefaults.standard.object(forKey: "isRegistered") == nil {
			UserDefaults.standard.set(false, forKey: "isRegistered")
		}
		
		if UserDefaults.standard.object(forKey: "isPassed") == nil {
			UserDefaults.standard.set(false, forKey: "isPassed")
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

extension AppDelegate {
	/// AppDelegateのシングルトン
	static var shared: SceneDelegate {
		return UIApplication.shared.connectedScenes
			.first!.delegate as! SceneDelegate
	}
	/// rootViewControllerは常にRootVC
	static var rootVC: RootViewController {
		AppDelegate.shared.window!.rootViewController as! RootViewController
	}
}
