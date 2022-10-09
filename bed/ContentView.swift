//
//  ContentView.swift
//  bed
//
//  Created by Chris McElroy on 10/9/22.
//

import SwiftUI

enum Mode {
	case pre, night, sleep, morning
}

struct ContentView: View {
	@State var nightTime: Int = 0
	@State var sleepTime: Int = 0
	@State var morningTime: Int = 0
	@State var startTime: Int = 0
	@State var timer: Timer? = nil
	@State var ready: Bool = false
	@State var showTimes: Bool = false
	@State var mode: Mode = .pre
	
	// TODO save this shit so even if it gets rebooted i don't lose it
	// TODO add in something to save what time i wake up
	
	var body: some View {
		VStack {
			Spacer().frame(height: 100)
//			Button("start/stop") {
//				if timer == nil {
//					startTimer()
//				} else {
//					stopTimer()
//				}
//			}
//			Button("reset") {
//				timer?.invalidate()
//				timer = nil
//				nightTime = 0
//				sleepTime = 0
//				morningTime = 0
//				startTime = 0
//				mode = .pre
//			}
			Spacer()
			Text(String(format: "%01d:%02d:%02d", nightTime/3600, nightTime/60 % 60, nightTime % 60))
				.font(.system(size: mode == .night ? 100 : 50))
			Text(String(format: "%01d:%02d:%02d", sleepTime/3600, sleepTime/60 % 60, sleepTime % 60))
				.font(.system(size: mode == .sleep ? 100 : 50))
			Text(String(format: "%01d:%02d:%02d", morningTime/3600, morningTime/60 % 60, morningTime % 60))
				.font(.system(size: mode == .morning ? 100 : 50))
			Spacer()
			
			Button("next mode") {
				switch mode {
				case .pre: startTimer(); mode = .night
				case .night: mode = .sleep
				case .sleep: mode = .morning
				case .morning: stopTimer(); mode = .pre
				}
				startTime = Date.s
			}
			Spacer().frame(height: 150)
		}
		.frame(minWidth: 240, idealWidth: 1000, maxWidth: 1000, minHeight: 240, idealHeight: 1000, maxHeight: 1000)
		.background(Rectangle().foregroundColor(.black))
		.ignoresSafeArea()
		.foregroundColor(.white)
		.background(Rectangle().foregroundColor(.black))
	}
	
	func startTimer() {
		switch mode {
		case .pre: break
		case .night: startTime = (Date.s - nightTime)
		case .sleep: startTime = (Date.s - sleepTime)
		case .morning: startTime = (Date.s - morningTime)
		}
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true, block: { _ in
			switch mode {
			case .pre: break
			case .night: nightTime = (Date.s - startTime)
			case .sleep: sleepTime = (Date.s - startTime)
			case .morning: morningTime = (Date.s - startTime)
			}
		})
	}
	
	func stopTimer() {
		timer?.invalidate()
		timer = nil
	}
}


extension Date {
	static var now: TimeInterval {
		timeIntervalSinceReferenceDate
	}
	
	static var s: Int {
		Int(now)
	}
}
