//
//  Background.swift
//  awad
//
//  Created by tomoya tanaka on 2021/01/31.
//

import UIKit

class MenuBar: UIView {

	let stampButton: Button = Button(image: #imageLiteral(resourceName: "stampButton"))
	let compassButton: Button = Button(image: #imageLiteral(resourceName: "compassButton"))
	let mapButton: Button = Button(image: #imageLiteral(resourceName: "mapButton"))
	private var mapViewController: MapViewController = MapViewController()
	private var stampViewController: StampListViewController = StampListViewController()
	private var compassViewController: CompassViewController = CompassViewController()
	private var missionViewController: MissionViewController = MissionViewController()
	var stampButtonBottomConstraint: NSLayoutConstraint?
	var compassButtonBottomConstraint: NSLayoutConstraint?
	var mapButtonBottomConstraint: NSLayoutConstraint?
	private var parent: UIViewController?
	static let shared: MenuBar = MenuBar()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupView()
	}

	private func setupView() {
		self.frame.size = CGSize(width: 400, height: 400)
		self.translatesAutoresizingMaskIntoConstraints = false
		
		stampButton.activateConstraint(parent: self)
		stampButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(transitionView(_:))))
		stampButton.tag = 3
		stampButtonBottomConstraint = NSLayoutConstraint(item: stampButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -30)
		self.addConstraint(stampButtonBottomConstraint!)
		
		compassButton.activateConstraint(parent: self)
		compassButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(transitionView(_:))))
		compassButton.tag = 2
		compassButtonBottomConstraint = NSLayoutConstraint(item: compassButton, attribute: .bottom, relatedBy: .equal, toItem: stampButton, attribute: .top, multiplier: 1.0, constant: 0)
		self.addConstraint(compassButtonBottomConstraint!)
		
		mapButton.activateConstraint(parent: self)
		mapButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(transitionView(_:))))
		mapButton.tag = 1
		mapButtonBottomConstraint = NSLayoutConstraint(item: mapButton, attribute: .bottom, relatedBy: .equal, toItem: compassButton, attribute: .top, multiplier: 1.0, constant: 0)
		self.addConstraint(mapButtonBottomConstraint!)
		
		let rightSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
		rightSwipe.direction = .right
		self.addGestureRecognizer(rightSwipe)
		
		let leftSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
		leftSwipe.direction = .left
		self.addGestureRecognizer(leftSwipe)
		
	}
	
	func activate(parent: UIViewController) {
		self.parent = parent
		parent.view.addSubview(self)
		NSLayoutConstraint.activate([
			self.trailingAnchor.constraint(equalTo: parent.view.trailingAnchor),
			self.bottomAnchor.constraint(equalTo: parent.view.bottomAnchor),
			self.widthAnchor.constraint(equalTo: parent.view.widthAnchor, multiplier: 0.7),
			self.heightAnchor.constraint(equalTo: parent.view.heightAnchor, multiplier: 0.4)
		])
	}
	
	@objc
	func handleSwipe(_ sender: UISwipeGestureRecognizer) {
		if sender.direction == .right {
			mapButton.setupForAnimation(constant: mapButton.frame.width * 0.7)
			compassButton.setupForAnimation(constant: compassButton.frame.width * 0.7)
			stampButton.setupForAnimation(constant: stampButton.frame.width * 0.8)
			compassButtonBottomConstraint?.constant = 30
			mapButtonBottomConstraint?.constant = 30
			
		} else if sender.direction == .left {
			stampButton.setupForAnimation(constant: 50)
			compassButton.setupForAnimation(constant: 20)
			mapButton.setupForAnimation(constant: 10)
			compassButtonBottomConstraint?.constant = 0
			mapButtonBottomConstraint?.constant = 0
		}
		UIView.animate(withDuration: 0.3, delay: 0, options: .preferredFramesPerSecond60, animations: {
			self.mapButton.updateConstraints()
		}, completion: nil)
	}
	
	func closeMenuBar() {
		mapButton.setupForAnimation(constant: mapButton.frame.width * 0.7)
		compassButton.setupForAnimation(constant: compassButton.frame.width * 0.7)
		stampButton.setupForAnimation(constant: stampButton.frame.width * 0.8)
		UIView.animate(withDuration: 0.1, delay: 0, options: .preferredFramesPerSecond60, animations: {
			self.layoutIfNeeded()
		}, completion: nil)
	}
	
	func resetMenuButtonLocation() {
		stampButton.resetLocation()
		compassButton.resetLocation()
		mapButton.resetLocation()
	}
	
	func openMenu() {
		// NOTE: 後で定数から変える
		stampButton.setupForAnimation(constant: 50)
		UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
			self.layoutIfNeeded()
		}, completion: nil)
		
		compassButton.setupForAnimation(constant: 20)
		UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
			self.layoutIfNeeded()
		}, completion: nil)
		
		mapButton.setupForAnimation(constant: 10)
		UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
			self.layoutIfNeeded()
		}, completion: nil)
	}
	
	@objc
	func transitionView(_ sender: UITapGestureRecognizer) {
		sender.view?.alpha = 0.7
		UIView.animate(withDuration: 0.3, animations: {
			sender.view?.alpha = 1
		})
		// NOTE: ゴミなので、書き直しましょう
		switch sender.view?.tag {
		case 1:
			guard parent?.navigationController?.topViewController != mapViewController else {
				return
			}
			self.resetMenuButtonLocation()
			parent?.navigationController?.pushViewController(mapViewController, animated: true)
		case 2:
			guard parent?.navigationController?.topViewController != compassViewController else {
				return
			}
			self.resetMenuButtonLocation()
			parent?.navigationController?.pushViewController(compassViewController, animated: true)
		case 3:
			// NOTE: 後にstampに変える
			guard parent?.navigationController?.topViewController != stampViewController else {
				return
			}
			self.resetMenuButtonLocation()
			parent?.navigationController?.pushViewController(stampViewController, animated: true)
		default:
			print("え？")
		}

	}
	
}
