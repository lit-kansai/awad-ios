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
	
	static let shared: FirestoreManager = FirestoreManager()
	
	// チームを登録
	func setTeam(team: String) {
		self.team = db.collection("teams").document(team)
	}
	
	// 目的地を取得
	func getCurrentDestination() {
		
	}
	
	// 目的地を登録
	func setDestination() {
		
	}
	
	// ミッション終わり
	func completedMission() {
		
	}
	
	func startListeningDestination() {
		
	}
}
