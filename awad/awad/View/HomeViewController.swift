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
	let achieveRatioTitleLabel: UILabel = UILabel()
	let achieveRatioLabel: UILabel = UILabel()
	let movementDistanceTitleLabel: UILabel = UILabel()
	let movementDistanceLabel: UILabel = UILabel()
	let totalPlayTimeTitleLabel: UILabel = UILabel()
	let totalPlayTimeLabel: UILabel = UILabel()
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
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(false)
		titleHeader.animate()
		MenuBar.shared.openMenu()
		
		UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
			self.view.layoutIfNeeded()
		}, completion: {_ in
		print(self.titleHeader.frame)
	   })
	}
	
	override func viewDidLayoutSubviews() {
		achieveRatioLabel.addBorder(width: 1, color: UIColor.turquoiseColor(), position: .bottom)
		movementDistanceLabel.addBorder(width: 1, color: UIColor.turquoiseColor(), position: .bottom)
		totalPlayTimeLabel.addBorder(width: 1, color: UIColor.turquoiseColor(), position: .bottom)
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
		view.addSubview(achieveRatioTitleLabel)
		view.addSubview(movementDistanceTitleLabel)
		view.addSubview(totalPlayTimeTitleLabel)
		view.addSubview(achieveRatioLabel)
		view.addSubview(movementDistanceLabel)
		view.addSubview(totalPlayTimeLabel)
		view.addSubview(missionButton)
		
		achieveRatioTitleLabel.text = "ミッション達成率"
		movementDistanceTitleLabel.text = "移動距離"
		totalPlayTimeTitleLabel.text = "プレイ時間"
		achieveRatioLabel.textAlignment = .center
		movementDistanceLabel.textAlignment = .center
		totalPlayTimeLabel.textAlignment = .center
		
		missionButton.setImage(#imageLiteral(resourceName: "missionButtonEnable"), for: .normal)
		missionButton.setImage(#imageLiteral(resourceName: "missionButtonBackground"), for: .disabled)
		missionButton.imageView?.contentMode = .scaleAspectFit
		missionButton.isEnabled = false
		missionButton.addTarget(self, action: #selector(transitionToMissionViewController), for: .touchUpInside)
	}
	
	// 制約
	func addConstraints() {
		achieveRatioTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			achieveRatioTitleLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
			achieveRatioTitleLabel.topAnchor.constraint(equalTo: missionButton.bottomAnchor, constant: 80)
		])
		
		achieveRatioLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			achieveRatioLabel.leadingAnchor.constraint(equalTo: achieveRatioTitleLabel.trailingAnchor, constant: 10),
			achieveRatioLabel.bottomAnchor.constraint(equalTo: achieveRatioTitleLabel.bottomAnchor, constant: 0),
			achieveRatioLabel.heightAnchor.constraint(equalTo: achieveRatioTitleLabel.heightAnchor),
			achieveRatioLabel.widthAnchor.constraint(equalToConstant: 100)
		])
		
		movementDistanceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			movementDistanceTitleLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
			movementDistanceTitleLabel.topAnchor.constraint(equalTo: achieveRatioTitleLabel.bottomAnchor, constant: 35)
		])
		
		movementDistanceLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			movementDistanceLabel.leadingAnchor.constraint(equalTo: movementDistanceTitleLabel.trailingAnchor, constant: 10),
			movementDistanceLabel.bottomAnchor.constraint(equalTo: movementDistanceTitleLabel.bottomAnchor, constant: 0),
			movementDistanceLabel.heightAnchor.constraint(equalTo: movementDistanceTitleLabel.heightAnchor),
			movementDistanceLabel.widthAnchor.constraint(equalToConstant: 100)
		])
		
		totalPlayTimeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			totalPlayTimeTitleLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
			totalPlayTimeTitleLabel.topAnchor.constraint(equalTo: movementDistanceTitleLabel.bottomAnchor, constant: 35)
		])
		
		totalPlayTimeLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			totalPlayTimeLabel.leadingAnchor.constraint(equalTo: totalPlayTimeTitleLabel.trailingAnchor, constant: 10),
			totalPlayTimeLabel.bottomAnchor.constraint(equalTo: totalPlayTimeTitleLabel.bottomAnchor, constant: 0),
			totalPlayTimeLabel.heightAnchor.constraint(equalTo: totalPlayTimeTitleLabel.heightAnchor),
			totalPlayTimeLabel.widthAnchor.constraint(equalToConstant: 100)
		])
		
		missionButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			missionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
			missionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			missionButton.topAnchor.constraint(equalTo: titleHeader.bottomAnchor, constant: 10)
		])
		
	}
}
