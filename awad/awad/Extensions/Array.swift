//
//  Array.swift
//  awad
//
//  Created by tomoya tanaka on 2021/03/04.
//

import Foundation

extension Array {
	func chunked(by chunkSize: Int) -> [[Element]] {
		return stride(from: 0, to: self.count, by: chunkSize).map {
			Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
		}
	}
}
