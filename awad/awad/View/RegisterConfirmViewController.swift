//
//  RegisterConfirmViewController.swift
//  awad
//
//  Created by tomoya tanaka on 2021/03/04.
//

import UIKit

class RegisterConfirmViewController: UIViewController {
	var team: String? = ""
	var member: String? = ""
	let background: BackgroundUIImageView = BackgroundUIImageView(imageName: "registerBackground")
	let parentStackView: UIStackView = UIStackView()
	let confirmLabel: UILabel = UILabel()
	// team
	let teamStackView: UIStackView = UIStackView()
	let teamHeaderLabel: UILabel = UILabel()
	let teamLabel: UILabel = UILabel()
	// user
	let memberStackView: UIStackView = UIStackView()
	let memberHeaderLabel: UILabel = UILabel()
	let memberLabel: UILabel = UILabel()
	let buttonStackView: UIStackView = UIStackView()
	let cancelButton: RegisterViewButton = RegisterViewButton(text: "キャンセル")
	let acceptButton: RegisterViewButton = RegisterViewButton(text: "OK!")
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupView()
		self.addConstraints()
    }
	
	@objc
	func cancel() {
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc
	func accept() {
		UserDefaults.standard.set(team!, forKey: "team")
		UserDefaults.standard.set(member!, forKey: "userName")
		let vc: HomeViewController = HomeViewController()
		self.navigationController?.pushViewController(vc, animated: true)
	}

}

extension RegisterConfirmViewController {
	func setupView() {
		self.navigationItem.title = "確認"
		
		parentStackView.distribution = .fillEqually
		parentStackView.axis = .vertical
		parentStackView.spacing = 40
		parentStackView.alignment = .center
		
		confirmLabel.text = "これで良い？"
		parentStackView.addArrangedSubview(confirmLabel)
		
		teamStackView.distribution = .fillEqually
		teamStackView.axis = .vertical
		teamStackView.spacing = 10
		teamStackView.alignment = .center
		teamHeaderLabel.text = "チーム"
		teamHeaderLabel.font = UIFont(name: "Keifont", size: 32)
		teamLabel.text = team!
		teamStackView.addArrangedSubview(teamHeaderLabel)
		teamStackView.addArrangedSubview(teamLabel)
		
		memberStackView.distribution = .fillEqually
		memberStackView.axis = .vertical
		memberStackView.spacing = 10
		memberStackView.alignment = .center
		memberHeaderLabel.text = "ユーザー名"
		memberHeaderLabel.font = UIFont(name: "Keifont", size: 32)
		memberLabel.text = member!
		memberStackView.addArrangedSubview(memberHeaderLabel)
		memberStackView.addArrangedSubview(memberLabel)
		
		buttonStackView.distribution = .fillEqually
		buttonStackView.axis = .horizontal
		buttonStackView.spacing = 10
		
		cancelButton.titleLabel?.font = UIFont(name: "Keifont", size: 24)
		cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
		acceptButton.titleLabel?.font = UIFont(name: "Keifont", size: 24)
		acceptButton.addTarget(self, action: #selector(accept), for: .touchUpInside)
		buttonStackView.addArrangedSubview(cancelButton)
		buttonStackView.addArrangedSubview(acceptButton)
		
		parentStackView.addArrangedSubview(teamStackView)
		parentStackView.addArrangedSubview(memberStackView)
		parentStackView.addArrangedSubview(buttonStackView)
		
		background.activateConstraint(parent: view)
		view.addSubview(parentStackView)
	}
	
	func addConstraints() {
		parentStackView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			parentStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
			parentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			parentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
		])
	}
}
