//
//  CompassViewController.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/13.
//

import UIKit
import CoreLocation

class CompassViewController: UIViewController {
	let needleImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "2Dneedle"))
	let distanceTextLabel: UILabel = UILabel()
	let background: BackgroundUIImageView = BackgroundUIImageView(imageName: "2Dbackground")
	let titleHeader: Header = Header(imageName: "compass")
	let missionButton: Button = Button(image: #imageLiteral(resourceName: "missionButton"))
	let errorMessage: UILabel = UILabel()
	var distance: Int?

	let distanceLabelBackground: UIImageView = UIImageView(image: #imageLiteral(resourceName: "tag"))
	
	private var presenter: CompassPresenterInput?
	let model: CompassModelInput = CompassModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupView()
		self.addConstraints()
		self.presenter = CompassPresenter(view: self, model: model)
		
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		MenuBar.shared.activate(parent: self)
		revealView()
		self.navigationController?.removePreviousController()
		presenter?.updateCheckpointDistance()
		NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
		if CLLocationManager.locationServicesEnabled() {
			UserLocationManager.shared.delegate = self
			UserLocationManager.shared.initOriginDegree()
		}
	}
	
	@objc
	func willEnterForegroundNotification() {
		print("willEnterForegroundNotification")
		presenter?.updateCheckpointDistance()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(false)
		titleHeader.animate()
		MenuBar.shared.animate()
		// アニメーション
		UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
			self.view.layoutIfNeeded()
		}, completion: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		MenuBar.shared.layer.opacity = 0
		titleHeader.resetForAnimation()
		self.hideView()
	}
	
	func checkIfUserArrived() {
		guard let distance = distance else {
			return
		}
		if UserLocationManager.shared.currentDestinationInformation != nil && distance <= 50 {
			UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
				self.missionButton.layer.opacity = 1
			}, completion: nil)
			UserLocationManager.shared.isArrived = true
		}
	}
	
	func revealView() {
		if UserLocationManager.shared.currentDestinationInformation != nil {
			needleImageView.layer.opacity = 1
			distanceTextLabel.layer.opacity = 1
			checkIfUserArrived()
		} else {
			errorMessage.layer.opacity = 1
		}
	}
	
	func hideView() {
		needleImageView.layer.opacity = 0
		distanceTextLabel.layer.opacity = 0
		errorMessage.layer.opacity = 0
		missionButton.layer.opacity = 0
	}
}

extension CompassViewController: UserLocationManagerDelegate {
	func locationDidUpdateToLocation(location: CLLocation) {
		presenter?.updateCheckpointDistance()
		self.checkIfUserArrived()
	}
	
	func locationDidUpdateHeading(newHeading: CLHeading) {
		presenter?.updateCheckpointDirection(degree: newHeading.magneticHeading)
	}
}

extension CompassViewController: CompassPresenterOutput {
	func changeCheckpointDistanceLabel(distance: Int) {
		self.distance = distance
		let formattedDistance: String = String(distance)
		let attrDistanceText: NSMutableAttributedString = NSMutableAttributedString(string: "あと\(formattedDistance)m")
		attrDistanceText.addAttributes([
			.font: UIFont(name: "Keifont", size: 36) as Any
		], range: _NSRange(location: 2, length: String(formattedDistance).count))
		distanceTextLabel.attributedText = attrDistanceText
	}
	
	func changeNeedleDirection(radian: Double) {
		needleImageView.transform = CGAffineTransform(rotationAngle: CGFloat(radian))
	}
}

extension CompassViewController {
	@objc
	func transitionToMissionViewController() {
		self.navigationItem.title = "Mission"
		let missionViewController: MissionViewController = MissionViewController()
		self.navigationController?.pushViewController(missionViewController, animated: true)
	}
	
	func setupView() {
		background.activateConstraint(parent: view)
		titleHeader.activateConstraint(parent: view)
		
		view.addSubview(distanceLabelBackground)
		view.addSubview(distanceTextLabel)
		view.addSubview(needleImageView)
		view.addSubview(missionButton)
		view.addSubview(errorMessage)
		
		distanceLabelBackground.contentMode = .scaleAspectFill
		
		distanceTextLabel.font = UIFont(name: "Keifont", size: 30)
		distanceTextLabel.frame.size = CGSize(width: view.frame.width / 2, height: 100)
		distanceTextLabel.center = CGPoint(x: view.frame.width / 2, y: 200)
		distanceTextLabel.textAlignment = NSTextAlignment.center
		distanceTextLabel.textColor = UIColor.distanceLabelColor()
		if let distance = distance {
			let attrDistanceText: NSMutableAttributedString = NSMutableAttributedString(string: "あと\(distance)m")
			attrDistanceText.addAttributes([
				.font: UIFont(name: "Keifont", size: 36) as Any
			], range: _NSRange(location: 2, length: String(distance).count))
			distanceTextLabel.attributedText = attrDistanceText
		}
		
		needleImageView.contentMode = .scaleAspectFit
		missionButton.imageView?.contentMode = .scaleAspectFill
		missionButton.addTarget(self, action: #selector(transitionToMissionViewController), for: .touchUpInside)
		
		missionButton.layer.opacity = 0
		// 透明度
		needleImageView.layer.opacity = 0
		distanceTextLabel.layer.opacity = 0
		errorMessage.layer.opacity = 0
		errorMessage.text = "目的地が設定されていません"
		errorMessage.frame.size = CGSize(width: view.frame.width / 2, height: 100)
		errorMessage.textAlignment = NSTextAlignment.center
	}
	
	func addConstraints() {
		distanceLabelBackground.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			distanceLabelBackground.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
			distanceLabelBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			distanceLabelBackground.topAnchor.constraint(equalTo: titleHeader.bottomAnchor, constant: 10)
		])
		
		distanceTextLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			distanceTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
			distanceTextLabel.centerYAnchor.constraint(equalTo: distanceLabelBackground.centerYAnchor)
		])
		
		needleImageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			needleImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			needleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			needleImageView.widthAnchor.constraint(equalToConstant: 150),
			needleImageView.heightAnchor.constraint(equalToConstant: 150)
		])
		
		errorMessage.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			errorMessage.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
			errorMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
		
		missionButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			missionButton.bottomAnchor.constraint(equalTo: needleImageView.topAnchor, constant: 30),
			missionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			missionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
			missionButton.heightAnchor.constraint(equalTo: missionButton.widthAnchor, multiplier: 0.6)
		])
	}
}
