//
//  SharedData.swift
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

import CoreFoundation
import CoreGraphics
import Foundation
import LucientC
import SwiftUI
import UIKit

internal final class SharedData: ObservableObject {
	static let global = SharedData()
	var timeTimer: Timer?
	var weatherTimer: Timer?
	var notifsVisible = false
	var musicVisible = false
	@Published internal var timeMinimized = false
	@Published internal var temperature: String? = nil
	@Published internal var weatherImage: Image? = nil

	final func startTimers() {
		stopTimers()
		timeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			NotificationCenter.default.post(name: NSNotification.Name("moe.absolucy.lucient.time"), object: nil)
		}
		weatherTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
			NotificationCenter.default.post(name: NSNotification.Name("moe.absolucy.lucient.weather"), object: nil)
		}
	}

	final func stopTimers() {
		timeTimer?.invalidate()
		timeTimer = nil
		weatherTimer?.invalidate()
		weatherTimer = nil
	}

	final func updateVisibility() {
		let visible = notifsVisible || musicVisible
		if visible {
			timeView?.view?.isHidden = true
		}
		withAnimation(.easeInOut(duration: 0.5)) {
			timeMinimized = visible
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, qos: .userInteractive) {
			timeView?.view?.isHidden = visible
		}
	}

	final func updateScreen(_ status: Bool) {
		if status {
			startTimers()
		} else {
			stopTimers()
		}
	}

	final func updateWeather() {
		guard let pd = PDDokdo.sharedInstance() else { return }
		pd.refreshWeatherData()
		guard let weatherData = pd.weatherData as NSDictionary?,
		      let temperature = weatherData["temperature"] as? NSString,
		      let image = weatherData["conditionsImage"] as? UIImage
		else {
			self.temperature = nil
			weatherImage = nil
			return
		}
		self.temperature = String(temperature)
		weatherImage = Image(uiImage: image)
	}
}

@_cdecl("setNotifsVisible")
public dynamic func setNotifsVisible(_ visible: Bool) {
	SharedData.global.notifsVisible = visible
	SharedData.global.updateVisibility()
}

@_cdecl("setMusicVisible")
public dynamic func setMusicVisible(_ visible: Bool) {
	SharedData.global.musicVisible = visible
	SharedData.global.updateVisibility()
}

@_cdecl("setScreenOn")
public dynamic func setScreenOn(_: Bool) {
	NotificationCenter.default.post(name: NSNotification.Name("moe.absolucy.lucient.time"), object: nil)
	NotificationCenter.default.post(name: NSNotification.Name("moe.absolucy.lucient.weather"), object: nil)
}
