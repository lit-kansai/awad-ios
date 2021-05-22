//
//  CountdownViewController.swift
//  awad
//
//  Created by tomoya tanaka on 2021/03/05.
//

import UIKit

class CountdownViewController: UIViewController {
	let background: BackgroundUIImageView = BackgroundUIImageView(imageName: "RegisterBackground")
	let EVENT_DATE: Date = DateComponents(calendar: .current, year: 2_021, month: 3, day: 11, hour: 10, minute: 30).date!
	let headerLabel: UILabel = UILabel()
	let countdownStackView: UIStackView = UIStackView()
	let countdownHeaderLabel: UILabel = UILabel()
	let countdownLabel: UILabel = UILabel()
	let startEventButton: UIButton = RegisterViewButton(text: " 開始！")
	var countdownTimer: Timer?
	var isPassed: Bool {
		return EVENT_DATE.seconds(from: Date()) <= 0
	}
	
	var offset: String {
		return EVENT_DATE.offset(from: Date())
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		addConstraint()
		if isPassed {
			didPassDate()
		} else {
			countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
		}
	}
	
	@objc
	func countdown() {
		if isPassed {
			didPassDate()
			countdownTimer?.invalidate()
		} else {
			countdownLabel.text = offset
		}
	}
	
	@objc
	func transitionToHome() {
		UserDefaults.standard.set(true, forKey: "isPassed")
		AppDelegate.rootVC.transitionToHome()
	}
	
	func didPassDate() {
		removeCountdownLabel()
		revealButton()
		headerLabel.text = "お待たせしました！"
	}
	
}

extension CountdownViewController {
	func setupView() {
		background.activateConstraint(parent: view)
		if !isPassed {
			headerLabel.text = "イベント開始までお待ち下さい！"
			countdownStackView.axis = .vertical
			countdownStackView.spacing = 20
			countdownStackView.distribution = .fillEqually
			countdownHeaderLabel.text = "開始まで"
			countdownHeaderLabel.textAlignment = .center
			countdownLabel.text = offset
			countdownLabel.textAlignment = .center
			countdownLabel.font = UIFont(name: "Keifont", size: 28)
			countdownStackView.addArrangedSubview(countdownHeaderLabel)
			countdownStackView.addArrangedSubview(countdownLabel)
		}
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
