//
//  RootViewController.swift
//  awad
//
//  Created by tomoya tanaka on 2021/03/06.
//

import UIKit

final class RootViewController: UIViewController {
	// 現在表示しているViewControllerを示します
	private var current: UIViewController?
	let countdownVC: CountdownViewController = CountdownViewController()
	let homeVC: UINavigationController = UINavigationController(rootViewController: HomeViewController())
	let registerVC: UINavigationController = UINavigationController(rootViewController: RegisterTeamViewController())
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		if UserDefaults.standard.bool(forKey: "isRegistered") {
			current = homeVC
		} else {
			current = registerVC
		}
		guard let view = view else {
			fatalError("アンタ、何者だ...?")
		}
		// ViewControllerをRootVCの子VCとして追加
		addChild(current!)
		current?.view.frame = view.bounds
		view.addSubview(current!.view)
		current?.didMove(toParent: self)
	}

	/// RootVCの子VCを入れ替える＝ルートの画面を切り替える
	func transition(to vc: UIViewController) {
		// 新しい子VCを追加
		addChild(vc)
		vc.view.frame = view.bounds
		view.addSubview(vc.view)
		vc.didMove(toParent: self)
		// 現在のVCを削除する準備
		current?.willMove(toParent: nil)
		// Superviewから現在のViewを削除
		current?.view.removeFromSuperview()
		// RootVCから現在のVCを削除
		current?.removeFromParent()
		// 現在のVCを更新
		current = vc
	}
	
	// 移動したいViewControllerごとに用意しておくと簡単に使用できる
	func transitionToHome() {
		animateFadeTransition(to: homeVC)
	}
	
	func transitionToRegister() {
		animateFadeTransition(to: registerVC)
	}
	
	func transitionToCountdown() {
		animateFadeTransition(to: countdownVC)
	}
	
	private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
		current?.willMove(toParent: nil)
		addChild(new)
	   
		transition(from: current!, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut],
		animations: {}) { _ in
			self.current?.removeFromParent()
			new.didMove(toParent: self)
			self.current = new
			completion?()  //1
		}
	}
	
	func setupView() {
		// 切り替えたい先のViewControllerを用意
		homeVC.interactivePopGestureRecognizer?.isEnabled = true
		homeVC.navigationBar.tintColor = UIColor.turquoiseColor()
		homeVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
		homeVC.navigationBar.shadowImage = UIImage()
		homeVC.navigationBar.titleTextAttributes = [
			.foregroundColor: UIColor.turquoiseColor(),
			.font: UIFont(name: "Keifont", size: 24)!
		]
		
		registerVC.interactivePopGestureRecognizer?.isEnabled = true
		registerVC.navigationBar.tintColor = UIColor.turquoiseColor()
		registerVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
		registerVC.navigationBar.shadowImage = UIImage()
		registerVC.navigationBar.titleTextAttributes = [
			.foregroundColor: UIColor.turquoiseColor(),
			.font: UIFont(name: "Keifont", size: 24)!
		]
	}
}
