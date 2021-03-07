//
//  NewMenuBar.swift
//  naruButtonExample
//
//  Created by tomoya tanaka on 2021/03/07.
//

import UIKit

class MenuBar: UIStackView {
	let stampButton: Button = Button(image: #imageLiteral(resourceName: "stampButton"))
	let compassButton: Button = Button(image: #imageLiteral(resourceName: "compassButton"))
	let mapButton: Button = Button(image: #imageLiteral(resourceName: "mapButton"))
	private var mapViewController: MapViewController = MapViewController()
	private var stampViewController: StampListViewController = StampListViewController()
	private var compassViewController: CompassViewController = CompassViewController()
	private var missionViewController: MissionViewController = MissionViewController()
	var originCenterX: CGFloat?
	private var parent: UIViewController?
	var trailingConstraint: NSLayoutConstraint?
	static let shared: MenuBar = MenuBar()
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupView()
	}
	
	func activate(parent: UIViewController) {
		self.parent = parent
		parent.view.addSubview(self)
		self.translatesAutoresizingMaskIntoConstraints = false
		trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: parent.view, attribute: .trailing, multiplier: 1.0, constant: 40)
		NSLayoutConstraint.activate([
			self.bottomAnchor.constraint(equalTo: parent.view.bottomAnchor),
			trailingConstraint!
		])
		self.layer.borderWidth = 3
		self.layer.borderColor = UIColor.systemRed.cgColor
	}
	
	func resetMenuButtonLocation() {
		print("reset")

	}
	
	func animate() {
		self.mapButton.center.x += 300
		self.compassButton.center.x += 300
		self.stampButton.center.x += 300
		self.layer.opacity = 1
		UIView.animate(withDuration: 0.5, delay: 0, options: .preferredFramesPerSecond60, animations: {
			self.mapButton.center.x -= 300
		}, completion: nil)
		
		UIView.animate(withDuration: 0.6, delay: 0, options: .preferredFramesPerSecond60, animations: {
			self.compassButton.center.x -= 300
		}, completion: nil)
		UIView.animate(withDuration: 0.7, delay: 0, options: .preferredFramesPerSecond60, animations: {
			self.stampButton.center.x -= 300
		}, completion: nil)
	}
	
	func openMenu() {
		UIView.animate(withDuration: 0.3, delay: 0, options: .preferredFramesPerSecond60, animations: {
			self.spacing = 5
			self.trailingConstraint?.constant = 40
		}, completion: nil)
	}
	
	func closeMenu() {
		UIView.animate(withDuration: 0.3, delay: 0, options: .preferredFramesPerSecond60, animations: {
			self.spacing = -30
			self.trailingConstraint?.constant = 175
		}, completion: nil)
	}
	
	@objc
	func handleSwipe(_ sender: UISwipeGestureRecognizer) {
		if sender.direction == .right {
			print("right")
			closeMenu()
		} else if sender.direction == .left {
			print("left")
			openMenu()
		}
	}
	
	@objc
	func transitionView(_ sender: UITapGestureRecognizer) {
		switch sender.view?.tag {
		case 1:
			guard parent?.navigationController?.topViewController != mapViewController else {
				return
			}
			self.layer.opacity = 0
			parent?.navigationController?.pushViewController(mapViewController, animated: true)
		case 2:
			guard parent?.navigationController?.topViewController != compassViewController else {
				return
			}
			self.layer.opacity = 0
			parent?.navigationController?.pushViewController(compassViewController, animated: true)
		case 3:
			guard parent?.navigationController?.topViewController != stampViewController else {
				return
			}
			self.layer.opacity = 0
			parent?.navigationController?.pushViewController(stampViewController, animated: true)
		default:
			print("え？")
		}
	}
}

extension MenuBar {
	private func setupView() {
		self.axis = .vertical
		self.spacing = 5
		self.alignment = .trailing
		stampButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(transitionView(_:))))
		stampButton.tag = 3
		
		compassButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(transitionView(_:))))
		compassButton.tag = 2
		
		mapButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(transitionView(_:))))
		mapButton.tag = 1
		
		let rightSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
		rightSwipe.direction = .right
		self.addGestureRecognizer(rightSwipe)
		
		let leftSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
		leftSwipe.direction = .left
		self.addGestureRecognizer(leftSwipe)
		self.addArrangedSubview(mapButton)
		self.addArrangedSubview(compassButton)
		self.addArrangedSubview(stampButton)
	}
}
