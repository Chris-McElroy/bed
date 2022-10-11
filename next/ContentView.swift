//
//  ContentView.swift
//  next
//
//  Created by Chris McElroy on 10/9/22.
//

import SwiftUI

enum Mode: Int {
	case pre, night, sleep, morning
}

struct ContentView: View {
	@State var nightTime: Int = 0
	@State var sleepTime: Int = 0
	@State var morningTime: Int = 0
	@State var startTime: Int = 0
	@State var wakeTime: Int = 0
	@State var timer: Timer? = nil
	@State var mode: Mode = .pre
	
	// TODO save this shit so even if it gets rebooted i don't lose it
	
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
			// TODO add an undo button up here
			Spacer()
			Text(String(format: "%01d.%02d", nightTime/3600, (nightTime*100)/3600 % 100))
				.font(.system(size: mode == .night ? 100 : 50))
			Text(String(format: "%01d.%02d", sleepTime/3600, (sleepTime*100)/3600 % 100))
				.font(.system(size: mode == .sleep ? 100 : 50))
			Text(String(format: "%01d.%02d", wakeTime/3600, (wakeTime*100)/3600 % 100))
				.font(.system(size: 50))
			Text(String(format: "%01d.%02d", morningTime/3600, (morningTime*100)/3600 % 100))
				.font(.system(size: mode == .morning ? 100 : 50))
			Spacer()
			
			Button("next mode") {
				switch mode {
				case .pre:
					reset()
					startTimer()
					setMode(.night)
				case .night:
					setMode(.sleep)
				case .sleep:
					setWakeTime(-Int(Calendar.current.startOfDay(for: Date()).timeIntervalSinceNow))
					setMode(.morning)
				case .morning:
					stopTimer()
					setMode(.pre)
				}
				setStartTime(Date.s)
			}
			Spacer().frame(height: 150)
		}
		.frame(minWidth: 240, idealWidth: 1000, maxWidth: 1000, minHeight: 240, idealHeight: 1000, maxHeight: 1000)
		.background(Rectangle().foregroundColor(.black))
		.ignoresSafeArea()
		.foregroundColor(.white)
		.background(Rectangle().foregroundColor(.black))
		.onAppear(perform: reloadValues)
	}
	
	func reloadValues() {
		nightTime = Storage.int(.night)
		sleepTime = Storage.int(.sleep)
		wakeTime = Storage.int(.wake)
		morningTime = Storage.int(.morning)
		startTime = Storage.int(.start)
		mode = Mode(rawValue: Storage.int(.mode)) ?? .pre
		startTimer()
	}
	
	func reset() {
		timer?.invalidate()
		timer = nil
		setNightTime(0)
		setSleepTime(0)
		setWakeTime(0)
		setMorningTime(0)
		setStartTime(0)
		setMode(.pre)
	}
	
	func setNightTime(_ v: Int) {
		nightTime = v
		Storage.set(v, for: .night)
	}
	
	func setSleepTime(_ v: Int) {
		sleepTime = v
		Storage.set(v, for: .sleep)
	}
	
	func setWakeTime(_ v: Int) {
		wakeTime = v
		Storage.set(v, for: .wake)
	}
	
	func setMorningTime(_ v: Int) {
		morningTime = v
		Storage.set(v, for: .morning)
	}
	
	func setStartTime(_ v: Int) {
		startTime = v
		Storage.set(v, for: .start)
	}
	
	func setMode(_ v: Mode) {
		mode = v
		Storage.set(mode.rawValue, for: .mode)
	}
	
	func startTimer() {
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true, block: { _ in
			switch mode {
			case .pre: break
			case .night: setNightTime(Date.s - startTime)
			case .sleep: setSleepTime(Date.s - startTime)
			case .morning: setMorningTime(Date.s - startTime)
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
