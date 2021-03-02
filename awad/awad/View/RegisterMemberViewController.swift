//
//  RegisterViewController.swift
//  awad
//
//  Created by tomoya tanaka on 2021/02/22.
//

import UIKit

class RegisterMemberViewController: UIViewController {
	
	let background: BackgroundUIImageView = BackgroundUIImageView(imageName: "registerBackground")
	var team: String?

    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupView()
		self.addConstraints()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		print(team)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(true)
		print(team)
	}
}

extension RegisterMemberViewController {
	func setupView() {
		background.activateConstraint(parent: view)
	}
	
	func addConstraints() {
		
	}
}
