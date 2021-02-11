//
//  CompassViewController.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/13.
//

import UIKit
import CoreLocation

class CompassViewController: UIViewController {
	let needleImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "needle"))
	let distanceTextLabel: UILabel = UILabel()
	let background: BackgroundUIImageView = BackgroundUIImageView(imageName: "compassBackground")
	let titleHeader: Header = Header(imageName: "compass")
	let missionButton: UIImageView = UIImageView(image: #imageLiteral(resourceName: "missionButton"))
	
	let distanceLabelBackground: UIImageView = UIImageView(image: #imageLiteral(resourceName: "tag"))
	
	private var presenter: CompassPresenterInput?
	let model: CompassModelInput = CompassModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		background.activateConstraint(parent: view)
		titleHeader.activateConstraint(parent: view)
		MenuBar.shared.activate(parent: self)
		
		distanceLabelBackground.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(distanceLabelBackground)
		distanceLabelBackground.contentMode = .scaleAspectFill
		NSLayoutConstraint.activate([
			distanceLabelBackground.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
			distanceLabelBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			distanceLabelBackground.topAnchor.constraint(equalTo: titleHeader.bottomAnchor, constant: 10)
		])
		
		self.presenter = CompassPresenter(view: self, model: model)
		if CLLocationManager.locationServicesEnabled() {
			UserLocationManager.shared.delegate = self
			UserLocationManager.shared.initOriginDegree()
		}
		
		let distance: Int = 1_000
		distanceTextLabel.font = UIFont(name: "Keifont", size: 30)
		distanceTextLabel.frame.size = CGSize(width: view.frame.width / 2, height: 100)
		distanceTextLabel.center = CGPoint(x: view.frame.width / 2, y: 200)
		distanceTextLabel.textAlignment = NSTextAlignment.center
		distanceTextLabel.textColor = UIColor.distanceLabelColor()
		let attrDistanceText: NSMutableAttributedString = NSMutableAttributedString(string: "あと\(distance)m")
		attrDistanceText.addAttributes([
			.font: UIFont(name: "Keifont", size: 36) as Any
		], range: _NSRange(location: 2, length: String(distance).count))
		distanceTextLabel.attributedText = attrDistanceText
		view.addSubview(distanceTextLabel)
		distanceTextLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			distanceTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
			distanceTextLabel.centerYAnchor.constraint(equalTo: distanceLabelBackground.centerYAnchor)
		])
		
		view.addSubview(needleImageView)
		needleImageView.contentMode = .scaleAspectFit
		needleImageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			needleImageView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 10),
			needleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
		
		view.addSubview(missionButton)
		missionButton.translatesAutoresizingMaskIntoConstraints = false
		missionButton.contentMode = .scaleAspectFill
		NSLayoutConstraint.activate([
			missionButton.bottomAnchor.constraint(equalTo: needleImageView.topAnchor, constant: 30),
			missionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			missionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
			missionButton.heightAnchor.constraint(equalTo: missionButton.widthAnchor, multiplier: 0.6)
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

extension CompassViewController: UserLocationManagerDelegate {
	func locationDidUpdateToLocation(location: CLLocation) {
		presenter?.updateCheckpointDistance()
		let distance: Double = UserLocationManager.shared.calcDistanceToDestination()
		if distance < 50 {
			guard let destinationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MissionViewController") as? MissionViewController
			else { return }
			destinationViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
			present(destinationViewController, animated: true, completion: nil)
		}
	}
	
	func locationDidUpdateHeading(newHeading: CLHeading) {
		presenter?.updateCheckpointDirection(degree: newHeading.magneticHeading)
	}
}

extension CompassViewController: CompassPresenterOutput {
	func changeCheckpointDistance(distance: Double) {
		let formattedDistance: String = String(format: "%.0f", distance)
		let attrDistanceText: NSMutableAttributedString = NSMutableAttributedString(string: "あと\(formattedDistance)m")
		attrDistanceText.addAttributes([
			.foregroundColor: UIColor.blue,
			.font: UIFont(name: "HiraginoSans-W6", size: 36) as Any
		], range: _NSRange(location: 2, length: String(formattedDistance).count))
		distanceTextLabel.attributedText = attrDistanceText
	}
	
	func changeNeedleDirection(radian: Double) {
		needleImageView.transform = CGAffineTransform(rotationAngle: CGFloat(radian))
	}
}
