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
	let missionButtonBackground: UIImageView = UIImageView(image: #imageLiteral(resourceName: "missionButtonBackground"))
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		background.activateConstraint(parent: view)
		titleHeader.activateConstraint(parent: view)
		MenuBar.shared.activate(parent: self)
		view.addSubview(achieveRatioTitleLabel)
		view.addSubview(movementDistanceTitleLabel)
		view.addSubview(totalPlayTimeTitleLabel)
		view.addSubview(achieveRatioLabel)
		view.addSubview(movementDistanceLabel)
		view.addSubview(totalPlayTimeLabel)
		view.addSubview(missionButtonBackground)
		
		achieveRatioTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		achieveRatioTitleLabel.text = "ミッション達成率"
		achieveRatioTitleLabel.font = UIFont(name: "Keifont", size: 20)
		achieveRatioTitleLabel.textColor = UIColor.turquoiseColor()
		NSLayoutConstraint.activate([
			achieveRatioTitleLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
			achieveRatioTitleLabel.topAnchor.constraint(equalTo: missionButtonBackground.bottomAnchor, constant: 80)
		])
		
		achieveRatioLabel.translatesAutoresizingMaskIntoConstraints = false
		achieveRatioLabel.font = UIFont(name: "Keifont", size: 20)
		achieveRatioLabel.textColor = UIColor.turquoiseColor()
		achieveRatioLabel.textAlignment = .center
		NSLayoutConstraint.activate([
			achieveRatioLabel.leadingAnchor.constraint(equalTo: achieveRatioTitleLabel.trailingAnchor, constant: 10),
			achieveRatioLabel.bottomAnchor.constraint(equalTo: achieveRatioTitleLabel.bottomAnchor, constant: 0),
			achieveRatioLabel.heightAnchor.constraint(equalTo: achieveRatioTitleLabel.heightAnchor),
			achieveRatioLabel.widthAnchor.constraint(equalToConstant: 100)
		])
		
		movementDistanceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		movementDistanceTitleLabel.text = "移動距離"
		movementDistanceTitleLabel.font = UIFont(name: "Keifont", size: 20)
		movementDistanceTitleLabel.textColor = UIColor.turquoiseColor()
		NSLayoutConstraint.activate([
			movementDistanceTitleLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
			movementDistanceTitleLabel.topAnchor.constraint(equalTo: achieveRatioTitleLabel.bottomAnchor, constant: 35)
		])
		
		movementDistanceLabel.translatesAutoresizingMaskIntoConstraints = false
		movementDistanceLabel.font = UIFont(name: "Keifont", size: 20)
		movementDistanceLabel.textColor = UIColor.turquoiseColor()
		movementDistanceLabel.textAlignment = .center
		NSLayoutConstraint.activate([
			movementDistanceLabel.leadingAnchor.constraint(equalTo: movementDistanceTitleLabel.trailingAnchor, constant: 10),
			movementDistanceLabel.bottomAnchor.constraint(equalTo: movementDistanceTitleLabel.bottomAnchor, constant: 0),
			movementDistanceLabel.heightAnchor.constraint(equalTo: movementDistanceTitleLabel.heightAnchor),
			movementDistanceLabel.widthAnchor.constraint(equalToConstant: 100)
		])
		
		totalPlayTimeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		totalPlayTimeTitleLabel.text = "プレイ時間"
		totalPlayTimeTitleLabel.font = UIFont(name: "Keifont", size: 20)
		totalPlayTimeTitleLabel.textColor = UIColor.turquoiseColor()
		NSLayoutConstraint.activate([
			totalPlayTimeTitleLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
			totalPlayTimeTitleLabel.topAnchor.constraint(equalTo: movementDistanceTitleLabel.bottomAnchor, constant: 35)
		])
		
		totalPlayTimeLabel.translatesAutoresizingMaskIntoConstraints = false
		totalPlayTimeLabel.font = UIFont(name: "Keifont", size: 20)
		totalPlayTimeLabel.textColor = UIColor.turquoiseColor()
		totalPlayTimeLabel.textAlignment = .center
		NSLayoutConstraint.activate([
			totalPlayTimeLabel.leadingAnchor.constraint(equalTo: totalPlayTimeTitleLabel.trailingAnchor, constant: 10),
			totalPlayTimeLabel.bottomAnchor.constraint(equalTo: totalPlayTimeTitleLabel.bottomAnchor, constant: 0),
			totalPlayTimeLabel.heightAnchor.constraint(equalTo: totalPlayTimeTitleLabel.heightAnchor),
			totalPlayTimeLabel.widthAnchor.constraint(equalToConstant: 100)
		])
		
		missionButtonBackground.translatesAutoresizingMaskIntoConstraints = false
		
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
	
	override func viewDidLayoutSubviews() {
		achieveRatioLabel.addBorder(width: 1, color: UIColor.turquoiseColor(), position: .bottom)
		movementDistanceLabel.addBorder(width: 1, color: UIColor.turquoiseColor(), position: .bottom)
		totalPlayTimeLabel.addBorder(width: 1, color: UIColor.turquoiseColor(), position: .bottom)
		
//		self.label.addBorder(width: 0.5, color: UIColor.black, position: .bottom)
//		self.label.addBorder(width: 0.5, color: UIColor.black, position: .top)
//		self.label.addBorder(width: 0.5, color: UIColor.black, position: .left)
	}
	
}
