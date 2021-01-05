//
//  CompassViewController.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/13.
//

import UIKit
import CoreLocation

class CompassViewController: UIViewController {
	private var presenter: CompassPresenterInput?
	func inject(presenter: CompassPresenterInput) {
		self.presenter = presenter
	}
	
	let needleImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "needle"))
	let distanceTextLabel: UILabel = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.overrideUserInterfaceStyle = .light
		
		if CLLocationManager.locationServicesEnabled() {
			UserLocationManager.shared.delegate = self
			UserLocationManager.shared.initOriginDegree()
		}
		
		let distance: Int = 1_000
		distanceTextLabel.font = UIFont(name: "HiraginoSans-W6", size: 24)
		distanceTextLabel.frame.size = CGSize(width: view.frame.width / 2, height: 100)
		distanceTextLabel.center = CGPoint(x: view.frame.width / 2, y: 200)
		distanceTextLabel.textAlignment = NSTextAlignment.center
		let attrDistanceText: NSMutableAttributedString = NSMutableAttributedString(string: "あと\(distance)m")
		attrDistanceText.addAttributes([
			.foregroundColor: UIColor.blue,
			.font: UIFont(name: "HiraginoSans-W6", size: 36) as Any
		], range: _NSRange(location: 2, length: String(distance).count))
		distanceTextLabel.attributedText = attrDistanceText
		view.addSubview(distanceTextLabel)
		
		needleImageView.frame.size = CGSize(width: view.frame.width * 0.7, height: view.frame.width * 0.7)
		needleImageView.contentMode = .scaleAspectFit
		needleImageView.center = view.center
		view.addSubview(needleImageView)
		
		let button: UIButton = UIButton()
		button.frame.size = CGSize(width: 200, height: 50)
		button.center = CGPoint(x: view.frame.maxX - 50, y: 100)
		button.setTitle("閉じる", for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.backgroundColor = .white
		button.addTarget(nil, action: #selector(closeCompass), for: .touchUpInside)
		view.addSubview(button)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
//		if CLLocationManager.locationServicesEnabled() {
//			UserLocationManager.shared.stopUpdatingHeading()
//		}
	}
	
	@objc
	func closeCompass() {
		dismiss(animated: true, completion: nil)
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
