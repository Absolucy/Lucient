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
	weak var timeTimer: Timer?
	weak var weatherTimer: Timer?
	weak var flipTimer: Timer?
	var notifsVisible = false
	var musicVisible = false
	var musicSuggestionsVisible = false
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
		flipTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
			NotificationCenter.default.post(name: NSNotification.Name("moe.absolucy.lucient.flip"), object: nil)
		}
	}

	final func stopTimers() {
		timeTimer?.invalidate()
		weatherTimer?.invalidate()
		flipTimer?.invalidate()
	}

	final func updateVisibility() {
		let visible = notifsVisible || musicVisible || musicSuggestionsVisible
		let leftOrRight = UserDefaults(suiteName: "/var/mobile/Library/Preferences/moe.absolucy.lucient.plist")?
			.object(forKey: "timeOnTheRight") as? Bool ?? false
		timeConstraintCx?.isActive = !visible
		timeConstraintCy?.isActive = !visible
		timeConstraintDateLeft?.isActive = visible && !leftOrRight
		timeConstraintDateBottom?.isActive = visible && !leftOrRight
		timeConstraintRight?.isActive = visible && leftOrRight
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

@_cdecl("setMusicSuggestionsVisible")
internal func setMusicSuggestionsVisible(_ visible: Bool) {
	SharedData.global.musicSuggestionsVisible = visible
	SharedData.global.updateVisibility()
}

@_cdecl("setScreenOn")
internal func setScreenOn(_ status: Bool) {
	SharedData.global.updateScreen(status)
	NotificationCenter.default.post(name: NSNotification.Name("moe.absolucy.lucient.time"), object: nil)
	NotificationCenter.default.post(name: NSNotification.Name("moe.absolucy.lucient.weather"), object: nil)
}
