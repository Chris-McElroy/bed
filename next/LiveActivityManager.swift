//
//  LiveActivityManager.swift
//  next
//
//  Created by Chris McElroy on 12/31/22.
//

import ActivityKit
import SwiftUI

struct TimerAttributes: ActivityAttributes {
	public struct ContentState: Codable, Hashable {
		var start: Date
	}
}


class LiveActivityManager {
	static func startActivity(with startTime: Int) {
		let startDate = Date(timeIntervalSinceReferenceDate: Double(startTime))
		print("date", startDate, startTime)
		_ = try? Activity.request(attributes: TimerAttributes(), content: ActivityContent(state: .init(start: startDate), staleDate: nil))
	}
	
	static func endAllActivities() async {
		for activity in Activity<TimerAttributes>.activities {
			await activity.end(activity.content, dismissalPolicy: .immediate)
		}
	}
}
