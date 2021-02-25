//
//  SceneDelegate.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/05.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?
	
	var navigationController: UINavigationController?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		
		if scene as? UIWindowScene != nil {
			let windowScene: UIWindowScene = (scene as? UIWindowScene)!
			let view: UIViewController = HomeViewController()
			navigationController = UINavigationController(rootViewController: view)
			self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
			self.navigationController?.navigationBar.isHidden = true
			self.navigationController?.navigationBar.tintColor = UIColor.turquoiseColor()
			self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
			self.navigationController?.navigationBar.shadowImage = UIImage()
			self.navigationController?.navigationBar.topItem?.title = ""
			window = UIWindow(frame: UIScreen.main.bounds)
			window?.rootViewController = navigationController
			window?.makeKeyAndVisible()
			window?.windowScene = windowScene
		} else {
			return
		}
		
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
	}

	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
		// to restore the scene back to its current state.
	}

}
