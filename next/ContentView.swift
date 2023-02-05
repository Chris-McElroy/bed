//
//  ContentView.swift
//  next
//
//  Created by Chris McElroy on 10/9/22.
//

import SwiftUI
import ActivityKit

enum Mode: Int {
	case pre, night, relax, sleep, morning
}



struct ContentView: View {
	@State var nightTime: Int = Storage.int(.night)
	@State var relaxTime: Int = Storage.int(.relax)
	@State var sleepTime: Int = Storage.int(.sleep)
	@State var morningTime: Int = Storage.int(.morning)
	@State var startTime: Int = Storage.int(.start)
	@State var nightStartTime: Int = Storage.int(.nightStart)
	@State var relaxStartTime: Int = Storage.int(.relaxStart)
	@State var sleepStartTime: Int = Storage.int(.sleepStart)
	@State var morningStartTime: Int = Storage.int(.morningStart)
	@State var morningEndTime: Int = Storage.int(.morningEnd)
	@State var timer: Timer? = nil
	@State var mode: Mode = Mode(rawValue: Storage.int(.mode)) ?? .pre
	
	var body: some View {
		VStack {
			Spacer().frame(height: 100)
			Button("copy") {
				let wake = getCopyString(morningStartTime)
				let night = getCopyString(nightTime)
				let sleep = getCopyString(sleepTime)
				let morn = getCopyString(morningTime)
				UIPasteboard.general.string = wake + "\t" + night + "\t" + sleep + "\t" + morn
				UINotificationFeedbackGenerator().notificationOccurred(.success)
			}
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
			VStack {
				Text(getStringFromTime(nightStartTime))
					.font(.system(size: 40))
					.foregroundColor(.secondary)
				Text(getStringFromTime(nightTime))
					.font(.system(size: mode == .night ? 100 : 50))
				Text(getStringFromTime(relaxStartTime))
					.font(.system(size: 40))
					.foregroundColor(.secondary)
				Text(getStringFromTime(relaxTime))
					.font(.system(size: mode == .relax ? 100 : 50))
				Text(getStringFromTime(sleepStartTime))
					.font(.system(size: 40))
					.foregroundColor(.secondary)
				Text(getStringFromTime(sleepTime))
					.font(.system(size: mode == .sleep ? 100 : 50))
				Text(getStringFromTime(morningStartTime))
					.font(.system(size: 40))
					.foregroundColor(.secondary)
				Text(getStringFromTime(morningTime))
					.font(.system(size: mode == .morning ? 100 : 50))
				Text(getStringFromTime(morningEndTime))
					.font(.system(size: 40))
					.foregroundColor(.secondary)
			}
			Spacer()
			
			Button("next mode") {
				switch mode {
				case .pre:
					reset()
					startTimer()
					setNightStartTime()
					setMode(.night)
				case .night:
					setRelaxStartTime()
					setMode(.relax)
				case .relax:
					setSleepStartTime()
					setMode(.sleep)
				case .sleep:
					setMorningStartTime()
					setMode(.morning)
				case .morning:
					setMorningEndTime()
					stopTimer()
					setMode(.pre)
				}
				setStartTime(Date.s)
				Task {
					await LiveActivityManager.endAllActivities()
					if mode != .pre {
						LiveActivityManager.startActivity(with: startTime)
					}
				}
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
		startTimer()
		if mode != .pre	{
			Task {
				await LiveActivityManager.endAllActivities()
				LiveActivityManager.startActivity(with: startTime)
			}
		}
	}
	
	func reset() {
		timer?.invalidate()
		timer = nil
		setNightStartTime(0)
		setNightTime(0)
		setSleepStartTime(0)
		setSleepTime(0)
		setMorningStartTime(0)
		setMorningTime(0)
		setMorningEndTime(0)
		setStartTime(0)
		setMode(.pre)
		Task {
			await LiveActivityManager.endAllActivities()
		}
	}
	
	func getStringFromTime(_ t: Int) -> String {
		let hours = t/3600
		let min = (t/60) % 60
		
		return (hours != 0 ? "\(hours)." : "") + "\(min)"
	}
	
	func getCopyString(_ t: Int) -> String {
		let hours = String(t/3600) + ":"
		let min = String(format: "%02d", (t/60) % 60)
		
		return hours + min
	}
	
	func setNightStartTime(_ v: Int = -Int(Calendar.current.startOfDay(for: Date()).timeIntervalSinceNow)) {
		nightStartTime = v
		Storage.set(v, for: .nightStart)
	}
	
	func setNightTime(_ v: Int) {
		nightTime = v
		Storage.set(v, for: .night)
	}
	
	func setRelaxStartTime(_ v: Int = -Int(Calendar.current.startOfDay(for: Date()).timeIntervalSinceNow)) {
		relaxStartTime = v
		Storage.set(v, for: .relaxStart)
	}
	
	func setRelaxTime(_ v: Int) {
		relaxTime = v
		Storage.set(v, for: .relax)
	}
	
	func setSleepStartTime(_ v: Int = -Int(Calendar.current.startOfDay(for: Date()).timeIntervalSinceNow)) {
		sleepStartTime = v
		Storage.set(v, for: .sleepStart)
	}
	
	func setSleepTime(_ v: Int) {
		sleepTime = v
		Storage.set(v, for: .sleep)
	}
	
	func setMorningStartTime(_ v: Int = -Int(Calendar.current.startOfDay(for: Date()).timeIntervalSinceNow)) {
		morningStartTime = v
		Storage.set(v, for: .morningStart)
	}
	
	func setMorningTime(_ v: Int) {
		morningTime = v
		Storage.set(v, for: .morning)
	}
	
	func setMorningEndTime(_ v: Int = -Int(Calendar.current.startOfDay(for: Date()).timeIntervalSinceNow)) {
		morningEndTime = v
		Storage.set(v, for: .morningEnd)
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
			case .relax: setRelaxTime(Date.s - startTime)
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
	static var s: Int {
		Int(timeIntervalSinceReferenceDate)
	}
}
