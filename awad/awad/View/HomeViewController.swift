//
//  HomeViewController.swift
//  awad
//
//  Created by tomoya tanaka on 2021/01/30.
//

import UIKit

class HomeViewController: UIViewController {
	
	var mapButtonConstraint: NSLayoutConstraint?
	var compassButtonConstraint: NSLayoutConstraint?
	var stampButtonConstraint: NSLayoutConstraint?
	
	let titleHeader: Header = Header(imageName: "home")
	let background: BackgroundUIImageView = BackgroundUIImageView(imageName: "homeBackground")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		background.activateConstraint(parent: view)
		titleHeader.activateConstraint(parent: view)
		MenuBar.shared.activate(parent: self)
		
		let missionButtonBackground: UIImageView = UIImageView(image: #imageLiteral(resourceName: "missionButtonBackground"))
		missionButtonBackground.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(missionButtonBackground)
		missionButtonBackground.contentMode = .scaleAspectFill
		NSLayoutConstraint.activate([
			missionButtonBackground.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
			missionButtonBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			missionButtonBackground.topAnchor.constraint(equalTo: titleHeader.bottomAnchor, constant: 10)
		])
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(false)
		titleHeader.setupForAnimation()
		MenuBar.shared.openMenu()
		// アニメーション
		UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
			self.view.layoutIfNeeded()
		}, completion: nil)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		MenuBar.shared.activate(parent: self)
	 }
	
}
