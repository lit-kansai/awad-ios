//
//  FireStoreManager.swift
//  awad
//
//  Created by tomoya tanaka on 2021/02/21.
//

import Foundation
import Firebase
final class FirestoreManager {
	
	var team: DocumentReference?
	let db: Firestore = Firestore.firestore()
	var currentTeam: String?
	
	static let shared: FirestoreManager = FirestoreManager()
	
	// チームを登録
	func setTeam(team: String) {
		currentTeam = team
		self.team = db.collection("teams").document(team)
	}
	
}
