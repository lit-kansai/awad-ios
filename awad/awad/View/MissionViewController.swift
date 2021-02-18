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
		self.setupView()
		self.addConstraints()
		
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(false)
		titleHeader.animate()
		// アニメーション
		UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
			self.view.layoutIfNeeded()
		}, completion: nil)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	 }

}

extension MissionViewController {
	func setupView() {
		background.activateConstraint(parent: view)
		titleHeader.activateConstraint(parent: view)
		view.addSubview(missionBackground)
		view.addSubview(doneButton)
		view.addSubview(cancelButton)
		
		missionBackground.contentMode = .scaleAspectFill
		doneButton.contentMode = .scaleAspectFill
		doneButton.frame.size = CGSize(width: 67, height: 67)
		cancelButton.frame.size = CGSize(width: 67, height: 67)
	}
	
	func addConstraints() {
		missionBackground.translatesAutoresizingMaskIntoConstraints = false
		doneButton.translatesAutoresizingMaskIntoConstraints = false
		cancelButton.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			missionBackground.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
			missionBackground.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
			missionBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			missionBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.3),
			
			doneButton.topAnchor.constraint(equalTo: missionBackground.bottomAnchor, constant: 40),
			doneButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 30),
			
			cancelButton.topAnchor.constraint(equalTo: missionBackground.bottomAnchor, constant: 40),
			cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -30)
		])
	}
}
