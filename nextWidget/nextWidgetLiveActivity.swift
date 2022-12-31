//
//  nextWidgetLiveActivity.swift
//  nextWidget
//
//  Created by Chris McElroy on 12/26/22.
//

import ActivityKit
import WidgetKit
import SwiftUI

@main
struct LiveActivityDynamicIsland: Widget {
	let limit: TimeInterval = 12*3600
	
	var body: some WidgetConfiguration {
		ActivityConfiguration(for: TimerAttributes.self) { context in
			Text(timerInterval: context.state.start...(context.state.start.advanced(by: limit)), countsDown: false)
				.multilineTextAlignment(.center)
		} dynamicIsland: { context in
			DynamicIsland {
				DynamicIslandExpandedRegion(.center) {
					Text(timerInterval: context.state.start...(context.state.start.advanced(by: limit)), countsDown: false)
						.multilineTextAlignment(.center)
				}
			} compactLeading: {
				Image(systemName: "arrowshape.right.fill")
			} compactTrailing: {
				Text(timerInterval: context.state.start...(context.state.start.advanced(by: limit)), countsDown: false)
					.multilineTextAlignment(.center)
					.frame(width: 58)
			} minimal: {
				Image(systemName: "arrowshape.right.fill")
			}
		}
	}
}
