//
//  RegisterViewController.swift
//  awad
//
//  Created by tomoya tanaka on 2021/02/22.
//

import UIKit

class RegisterMemberViewController: UIViewController {
	
	let background: BackgroundUIImageView = BackgroundUIImageView(imageName: "registerBackground")
	let titleLabel: UILabel = UILabel()
	var team: String?
	var members: [String] = [] {
		didSet {
			displayMemberButton()
		}
	}
	let parentStackView: UIStackView = UIStackView()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupView()
		self.addConstraints()
		self.fetchTeamMember()
		self.navigationItem.title = self.team!
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
	}
	
	@objc
	func didSelectButton(_ sender: UIButton) {
		let vc: RegisterConfirmViewController = RegisterConfirmViewController()
		vc.member = sender.currentTitle!
		vc.team = team
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	func fetchTeamMember() {
		FirestoreManager.shared.db.collection("teams").document(self.team!).collection("members").getDocuments { (querySnapshot, err) in
			if let err: Error = err {
				print("Error getting documents: \(err)")
			} else {
				var result: [String] = []
				for document in querySnapshot!.documents {
					print(document.data()["name"])
					result.append(document.data()["name"] as! String)
				}
				self.members = result
			}
		}
	}
}

extension RegisterMemberViewController {
	func setupView() {
		background.activateConstraint(parent: view)
		titleLabel.text = "お前は誰だ！"
		titleLabel.minimumScaleFactor = 0.5
		parentStackView.distribution = .fillEqually
		parentStackView.axis = .vertical
		parentStackView.spacing = 30
	}
	
	func displayMemberButton() {
		let chunkedMembers: [[String]] = members.chunked(by: 2)
		for memberRow in chunkedMembers {
			let stackView: UIStackView = UIStackView()
			stackView.axis = .horizontal
			stackView.distribution = .fillEqually
			stackView.spacing = 15
			for member in memberRow {
				let button: RegisterViewButton = RegisterViewButton(text: member)
				stackView.addArrangedSubview(button)
				button.addTarget(self, action: #selector(self.didSelectButton(_:)), for: .touchUpInside)
			}
			parentStackView.addArrangedSubview(stackView)
		}
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
			parentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			parentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
}
