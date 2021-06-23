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
	var wallpaperTimer: Timer?
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
		wallpaperTimer = Timer.scheduledTimer(withTimeInterval: 90, repeats: true) { _ in
			NotificationCenter.default.post(name: NSNotification.Name("moe.absolucy.lucient.wallpaper"), object: nil)
		}
	}

	final func stopTimers() {
		timeTimer?.invalidate()
		timeTimer = nil
		weatherTimer?.invalidate()
		weatherTimer = nil
		wallpaperTimer?.invalidate()
		wallpaperTimer = nil
	}

	final func updateVisibility() {
		let visible = notifsVisible || musicVisible
		let leftOrRight = UserDefaults(suiteName: "/var/mobile/Library/Preferences/moe.absolucy.lucient.plist")?
			.object(forKey: "timeOnTheRight") as? Bool ?? false
		timeConstraintCx?.isActive = !visible
		timeConstraintCy?.isActive = !visible
		timeConstraintDateLeft?.isActive = visible && !leftOrRight
		timeConstraintRight?.isActive = visible && leftOrRight
		timeConstraintDateBottom?.isActive = visible && !leftOrRight
		timeConstraintDateTop?.isActive = visible && leftOrRight
		timeView?.view?.setNeedsLayout()
		timeView?.view?.layoutIfNeeded()
		timeMinimized = visible
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
internal func setNotifsVisible(_ visible: Bool) {
	SharedData.global.notifsVisible = visible
	SharedData.global.updateVisibility()
}

@_cdecl("setMusicVisible")
internal func setMusicVisible(_ visible: Bool) {
	SharedData.global.musicVisible = visible
	SharedData.global.updateVisibility()
}

@_cdecl("setScreenOn")
internal func setScreenOn(_: Bool) {
	NotificationCenter.default.post(name: NSNotification.Name("moe.absolucy.lucient.time"), object: nil)
	NotificationCenter.default.post(name: NSNotification.Name("moe.absolucy.lucient.weather"), object: nil)
}
