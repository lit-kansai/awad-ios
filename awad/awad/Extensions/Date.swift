//
//  File.swift
//  awad
//
//  Created by tomoya tanaka on 2021/03/05.
//

import Foundation

extension Date {
	/// Returns the amount of days from another date
	func days(from date: Date) -> Int {
		return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
	}
	/// Returns the amount of hours from another date
	func hours(from date: Date) -> Int {
		return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
	}
	/// Returns the amount of minutes from another date
	func minutes(from date: Date) -> Int {
		return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
	}
	/// Returns the amount of seconds from another date
	func seconds(from date: Date) -> Int {
		return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
	}
	/// Returns the a custom time interval description from another date
	func offset(from date: Date) -> String {
		var result: [String] = []
		if minutes(from: date) > 0 {
			result.append("\(seconds(from: date) % 60)秒")
			
		} else {
			result.append("\(seconds(from: date) % 60)秒")
			return result.reversed().joined()
		}
		
		if hours(from: date) > 0 {
			result.append("\(minutes(from: date) % 60)分")
			
		} else {
			result.append("\(minutes(from: date) % 60)分")
			return result.reversed().joined()
		}
		
		if days(from: date) > 0 {
			result.append("\(hours(from: date) % 24)時間")
			result.append("\(days(from: date))日")
			
		} else {
			result.append("\(hours(from: date) % 24)時間")
			
			return result.reversed().joined()
		}
		
		return result.reversed().joined()
	}
}
