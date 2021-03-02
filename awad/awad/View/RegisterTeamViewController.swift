//
//  SelectTeamViewController.swift
//  awad
//
//  Created by tomoya tanaka on 2021/03/02.
//

import UIKit

class RegisterTeamViewController: UIViewController {
	let background: BackgroundUIImageView = BackgroundUIImageView(imageName: "registerBackground")
	let titleLabel: UILabel = UILabel()
	let teams: [[String]] = [["A", "B"], ["C", "D"], ["E", "F"]]
	let parentStackView: UIStackView = UIStackView()
    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupView()
		self.addConstraints()
		print(parentStackView.arrangedSubviews)
    }
	
	@objc
	func didSelectButton(_ sender: UIButton) {
		let vc = RegisterMemberViewController()
		vc.team = sender.currentTitle!
		print(sender.currentTitle!)
		self.navigationController?.pushViewController(vc, animated: true)
			
	}

}

extension RegisterTeamViewController {
	func setupView() {
		background.activateConstraint(parent: view)
		titleLabel.text = "チームを選んでください！"
		parentStackView.distribution = .fillEqually
		parentStackView.axis = .vertical
		parentStackView.spacing = 30
	}
	
	func addConstraints() {
		view.addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150)
		])
		
		view.addSubview(parentStackView)
		parentStackView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			parentStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
//			parentStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),
			parentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			parentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
		
		for teamRow in teams {
			let stackView: UIStackView = UIStackView()
			stackView.axis = .horizontal
			stackView.distribution = .fillEqually
			stackView.spacing = 15
			for team in teamRow {
				let button: RegisterViewButton = RegisterViewButton(text: team)
				stackView.addArrangedSubview(button)
				button.addTarget(self, action: #selector(didSelectButton(_:)), for: .touchUpInside)
			}
			parentStackView.addArrangedSubview(stackView)
		}
		view.addSubview(parentStackView)
		
	}
}
