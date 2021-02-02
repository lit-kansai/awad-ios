//
//  MissionViewController.swift
//  awad
//
//  Created by tomoya tanaka on 2021/01/05.
//

import UIKit

class MissionViewController: UIViewController {

	let titleHeader: Header = Header(imageName: "mission")
	let background: BackgroundUIImageView = BackgroundUIImageView(imageName: "missionBackground")
	let missionBackground: UIImageView = UIImageView(image: #imageLiteral(resourceName: "missionContentBackground"))
	let doneButton: UIImageView = UIImageView(image: #imageLiteral(resourceName: "doneButton"))
	let cancelButton: UIImageView = UIImageView(image: #imageLiteral(resourceName: "cancelButton"))
	
    override func viewDidLoad() {
        super.viewDidLoad()
		background.activateConstraint(parent: view)
		titleHeader.activateConstraint(parent: view)
//		MenuBar.shared.activate(parent: self)

		view.addSubview(missionBackground)
		view.addSubview(doneButton)
		view.addSubview(cancelButton)
		
		missionBackground.translatesAutoresizingMaskIntoConstraints = false
		missionBackground.contentMode = .scaleAspectFill
		NSLayoutConstraint.activate([
			missionBackground.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
			missionBackground.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
			missionBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			missionBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.3)
		])
		
		doneButton.contentMode = .scaleAspectFill
		doneButton.translatesAutoresizingMaskIntoConstraints = false
		doneButton.frame.size = CGSize(width: 67, height: 67)
		NSLayoutConstraint.activate([
			doneButton.topAnchor.constraint(equalTo: missionBackground.bottomAnchor, constant: 40),
			doneButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 30),
		])
		
		cancelButton.translatesAutoresizingMaskIntoConstraints = false
		cancelButton.frame.size = CGSize(width: 67, height: 67)
		NSLayoutConstraint.activate([
			cancelButton.topAnchor.constraint(equalTo: missionBackground.bottomAnchor, constant: 40),
			cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -30)
		])
		
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(false)
		titleHeader.setupForAnimation()
//		MenuBar.shared.openMenu()
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
