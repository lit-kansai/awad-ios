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
	let doneButton: Button = Button(image: #imageLiteral(resourceName: "doneButton"))
	let cancelButton: Button = Button(image: #imageLiteral(resourceName: "cancelButton"))
	let missionLabel: UILabel = UILabel()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupView()
		self.addConstraints()
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.removePreviousController()
	 }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(false)
		titleHeader.animate()
		// アニメーション
		UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
			self.view.layoutIfNeeded()
		}, completion: nil)
		self.navigationController?.navigationBar.isHidden = false
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		titleHeader.resetForAnimation()
		self.navigationController?.navigationBar.isHidden = true
	}
	@objc
	func completeMission() {
		self.navigationController?.pushViewController(HomeViewController(), animated: true)
		
		let destination: Checkpoint? = UserLocationManager.shared.currentDestinationInformation
		FirestoreManager.shared.team?.collection("stamps").addDocument(data: [
			"name": destination?.checkpointName as Any,
			"image": destination?.stampImageName as Any,
			"description": "\(destination!.checkpointName)でゲットした" as Any
		], completion: { err in
			if let err: Error = err {
				print("Error adding document: \(err)")
			} else {
				UserLocationManager.shared.resetDestination()
			}
		})
	}
}

extension MissionViewController {
	func setupView() {
		background.activateConstraint(parent: view)
		titleHeader.activateConstraint(parent: view)
		view.addSubview(missionBackground)
		view.addSubview(doneButton)
		view.addSubview(cancelButton)
		view.addSubview(missionLabel)
		missionLabel.text = UserLocationManager.shared.currentDestinationInformation?.mission
		missionLabel.numberOfLines = 0
		missionLabel.font = UIFont(name: "Keifont", size: 20)
		missionBackground.contentMode = .scaleAspectFill
		doneButton.contentMode = .scaleAspectFill
		doneButton.frame.size = CGSize(width: 67, height: 67)
		cancelButton.frame.size = CGSize(width: 67, height: 67)
		doneButton.addTarget(self, action: #selector(completeMission), for: .touchUpInside)
	}
	
	func addConstraints() {
		missionBackground.translatesAutoresizingMaskIntoConstraints = false
		doneButton.translatesAutoresizingMaskIntoConstraints = false
		cancelButton.translatesAutoresizingMaskIntoConstraints = false
		missionLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			missionBackground.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
			missionBackground.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
			missionBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			missionBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.3),
			
			doneButton.topAnchor.constraint(equalTo: missionBackground.bottomAnchor, constant: 40),
			doneButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 30),
			
			cancelButton.topAnchor.constraint(equalTo: missionBackground.bottomAnchor, constant: 40),
			cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
			
			missionLabel.centerXAnchor.constraint(equalTo: missionBackground.centerXAnchor),
			missionLabel.centerYAnchor.constraint(equalTo: missionBackground.centerYAnchor, constant: -50),
			missionLabel.widthAnchor.constraint(equalTo: missionBackground.widthAnchor, multiplier: 0.8),
			missionLabel.heightAnchor.constraint(equalTo: missionBackground.heightAnchor, multiplier: 0.7)
		])
	}
}
