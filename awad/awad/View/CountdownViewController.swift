//
//  CountdownViewController.swift
//  awad
//
//  Created by tomoya tanaka on 2021/03/05.
//

import UIKit

class CountdownViewController: UIViewController {
	let background: BackgroundUIImageView = BackgroundUIImageView(imageName: "registerBackground")
//	let EVENT_DATE: Date = DateComponents(calendar: .current, year: 2_021, month: 3, day: 11, hour: 10, minute: 30).date!
	let EVENT_DATE: Date = Date() + 60
	let headerLabel: UILabel = UILabel()
	let countdownStackView: UIStackView = UIStackView()
	let countdownHeaderLabel: UILabel = UILabel()
	let countdownLabel: UILabel = UILabel()
	let startEventButton: UIButton = RegisterViewButton(text: " 開始！")
	var countdownTimer: Timer?
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		addConstraint()
		countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
	}
	
	@objc
	func countdown() {
		let now: Date = Date()
		let offset: String = EVENT_DATE.offset(from: now)
		if offset == "0秒" {
			removeCountdownLabel()
			revealButton()
		} else {
			countdownLabel.text = EVENT_DATE.offset(from: now)
		}
	}
	
	@objc
	func transitionToHome() {
		AppDelegate.rootVC.transitionToHome()
	}
}

extension CountdownViewController {
	func setupView() {
		background.activateConstraint(parent: view)
		headerLabel.text = "イベント開始までお待ち下さい！"
		countdownStackView.axis = .vertical
		countdownStackView.spacing = 20
		countdownStackView.distribution = .fillEqually
		countdownHeaderLabel.text = "開始まで"
		countdownHeaderLabel.textAlignment = .center
		countdownLabel.textAlignment = .center
		countdownLabel.font = UIFont(name: "Keifont", size: 28)
		countdownStackView.addArrangedSubview(countdownHeaderLabel)
		countdownStackView.addArrangedSubview(countdownLabel)
		
		startEventButton.layer.opacity = 0
		startEventButton.addTarget(self, action: #selector(transitionToHome), for: .touchUpInside)
	}
	
	func addConstraint() {
		view.addSubview(headerLabel)
		headerLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
			headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
		
		view.addSubview(countdownStackView)
		countdownStackView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			countdownStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			countdownStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
	
	func revealButton() {
		countdownStackView.addArrangedSubview(startEventButton)
		UIView.animate(withDuration: 0.5, animations: {
			self.startEventButton.layer.opacity = 1
		})
	}
	
	func removeCountdownLabel() {
		countdownLabel.removeFromSuperview()
		countdownHeaderLabel.removeFromSuperview()
	}
}
