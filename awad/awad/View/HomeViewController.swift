//
//  HomeViewController.swift
//  awad
//
//  Created by tomoya tanaka on 2021/01/30.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {
	let parentStackView: UIStackView = UIStackView()
	// team
	let teamStackView: UIStackView = UIStackView()
	let teamHeaderLabel: UILabel = UILabel()
	let teamLabel: UILabel = UILabel()
	// user
	let memberStackView: UIStackView = UIStackView()
	let memberHeaderLabel: UILabel = UILabel()
	let memberLabel: UILabel = UILabel()
	
	let titleHeader: Header = Header(imageName: "home")
	let background: BackgroundUIImageView = BackgroundUIImageView(imageName: "homeBackground")
	let missionButton: UIButton = UIButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setUpView()
		self.addConstraints()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		MenuBar.shared.activate(parent: self)
		MenuBar.shared.resetMenuButtonLocation()
		UserLocationManager.shared.delegate = self
		if UserDefaults.standard.bool(forKey: "isRegistered") == false {
			UserDefaults.standard.set(true, forKey: "isRegistered")
			self.navigationController?.viewControllers = [self]
		} else {
			self.navigationController?.removePreviousController()
		}
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(false)
		titleHeader.animate()
		MenuBar.shared.openMenu()
		
		UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
			self.view.layoutIfNeeded()
		}, completion: {_ in
		})
		if UserLocationManager.shared.isArrived {
			missionButton.isEnabled = true
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		titleHeader.resetForAnimation()
	}
}

extension HomeViewController: UserLocationManagerDelegate {
	
	func locationDidUpdateToLocation(location: CLLocation) {
	}
	
	func locationDidUpdateHeading(newHeading: CLHeading) {
	}
}

extension HomeViewController {
	@objc
	func transitionToMissionViewController() {
		let missionViewController: MissionViewController = MissionViewController()
		self.navigationController?.pushViewController(missionViewController, animated: true)
	}
	
	// UIの設定
	func setUpView() {
		background.activateConstraint(parent: view)
		titleHeader.activateConstraint(parent: view)
		view.addSubview(missionButton)
		
		missionButton.setImage(#imageLiteral(resourceName: "missionButtonEnable"), for: .normal)
		missionButton.setImage(#imageLiteral(resourceName: "missionButtonBackground"), for: .disabled)
		missionButton.imageView?.contentMode = .scaleAspectFit
		missionButton.isEnabled = false
		missionButton.addTarget(self, action: #selector(transitionToMissionViewController), for: .touchUpInside)
		
		parentStackView.distribution = .fillEqually
		parentStackView.axis = .vertical
		parentStackView.spacing = 30
		
		teamStackView.spacing = 20
		teamStackView.distribution = .fillEqually
		teamHeaderLabel.text = "チーム名："
		teamHeaderLabel.font = UIFont(name: "Keifont", size: 24)
		teamHeaderLabel.textAlignment = .right
		teamLabel.text = UserDefaults.standard.string(forKey: "team")
		teamStackView.addArrangedSubview(teamHeaderLabel)
		teamStackView.addArrangedSubview(teamLabel)
		
		memberStackView.spacing = 20
		memberStackView.distribution = .fillEqually
		memberHeaderLabel.text = "名前："
		memberHeaderLabel.font = UIFont(name: "Keifont", size: 24)
		memberHeaderLabel.textAlignment = .right
		memberLabel.text = UserDefaults.standard.string(forKey: "userName")
		memberStackView.addArrangedSubview(memberHeaderLabel)
		memberStackView.addArrangedSubview(memberLabel)
		
		parentStackView.addArrangedSubview(teamStackView)
		parentStackView.addArrangedSubview(memberStackView)
		
		view.addSubview(parentStackView)
	}
	
	// 制約
	func addConstraints() {
		missionButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			missionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
			missionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			missionButton.topAnchor.constraint(equalTo: titleHeader.bottomAnchor, constant: 10)
		])
		
		parentStackView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			parentStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
			parentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			parentStackView.topAnchor.constraint(equalTo: missionButton.bottomAnchor, constant: 80)
			
		])
		
	}
}
