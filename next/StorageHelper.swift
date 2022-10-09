//
//  StorageHelper.swift
//  next
//
//  Created by Chris McElroy on 10/9/22.
//

import Foundation

class Storage {
	static func dictionary(_ key: Key) -> [String: Any]? {
		UserDefaults.standard.dictionary(forKey: key.rawValue)
	}
	
	static func int(_ key: Key) -> Int {
		UserDefaults.standard.integer(forKey: key.rawValue)
	}
	
	static func string(_ key: Key) -> String? {
		UserDefaults.standard.string(forKey: key.rawValue)
	}
	
	static func set(_ value: Any?, for key: Key) {
		UserDefaults.standard.setValue(value, forKey: key.rawValue)
	}
}

enum Key: String {
	case night = "night"
	case sleep = "sleep"
	case wake = "wake"
	case morning = "morning"
	case start = "start"
	case mode = "mode"
}
