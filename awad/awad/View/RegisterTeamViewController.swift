//
//  SelectTeamViewController.swift
//  awad
//
//  Created by tomoya tanaka on 2021/03/02.
//

import UIKit
import FirebaseFirestoreSwift
import FirebaseFirestore

class RegisterTeamViewController: UIViewController {
	let background: BackgroundUIImageView = BackgroundUIImageView(imageName: "registerBackground")
	let titleLabel: UILabel = UILabel()
	let debugButton: Button = Button(image: #imageLiteral(resourceName: "informationButton"))
	var teams: [String] = [] {
		didSet {
			displayTeamButton()
		}
	}
	let parentStackView: UIStackView = UIStackView()
    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupView()
		self.addConstraints()
		self.fetchTeams()
    }
	
	@objc
	func didSelectButton(_ sender: UIButton) {
		let vc: RegisterMemberViewController = RegisterMemberViewController()
		vc.team = sender.currentTitle!
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	func fetchTeams() {
		FirestoreManager.shared.db.collection("teams").getDocuments { (querySnapshot, err) in
			if let err: Error = err {
				print("Error getting documents: \(err)")
			} else {
				var result: [String] = []
				for document in querySnapshot!.documents {
					if document.documentID != "debug" {
						result.append(document.documentID)
					}
				}
				self.teams = result
			}
		}
	}
	
	@objc
	func openModal() {
		var alertTextField: UITextField?

		let alert: UIAlertController = UIAlertController(
			title: "パスコードを入力してください",
			message: "デバッグ用のパスワードを入力してください",
			preferredStyle: UIAlertController.Style.alert)
		alert.addTextField(
			configurationHandler: {(textField: UITextField!) in
				alertTextField = textField
				 textField.placeholder = "パスワードをここに入力"
				 textField.isSecureTextEntry = true
			})
		alert.addAction(
			UIAlertAction(
				title: "Cancel",
				style: UIAlertAction.Style.cancel,
				handler: nil))
		alert.addAction(
			UIAlertAction(
				title: "OK",
				style: UIAlertAction.Style.default) { _ in
				if let text: String = alertTextField?.text {
					print("success")
					if text == "Awad2020311" {
						UserDefaults.standard.set("debug", forKey: "team")
						UserDefaults.standard.set("テスト", forKey: "userName")
						UserDefaults.standard.set(true, forKey: "isRegistered")
						UserDefaults.standard.set(true, forKey: "isPassed")
						FirestoreManager.shared.setTeam(team: "debug")
						AppDelegate.rootVC.transitionToHome()
					} else {
						print("error")
					}
				}
			}
		)

		self.present(alert, animated: true, completion: nil)
	}
	
}

extension RegisterTeamViewController {
	func setupView() {
		self.navigationItem.title = "チームの選択"
		background.activateConstraint(parent: view)
		titleLabel.text = "チームを選んでください！"
		parentStackView.distribution = .fillEqually
		parentStackView.axis = .vertical
		parentStackView.spacing = 30
		
		debugButton.addTarget(self, action: #selector(openModal), for: .touchUpInside)
	}
	
	func displayTeamButton() {
		let chunkedTeams: [[String]] = teams.chunked(by: 2)
		for teamRow in chunkedTeams {
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
		
		view.addSubview(debugButton)
		debugButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			debugButton.widthAnchor.constraint(equalToConstant: 30),
			debugButton.heightAnchor.constraint(equalToConstant: 30),
			debugButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
			debugButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
		])
		
	}
}
