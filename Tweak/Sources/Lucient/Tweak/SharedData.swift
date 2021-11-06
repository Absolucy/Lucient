//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.


import CoreFoundation
import CoreGraphics
import Foundation
import LucientC
import SwiftUI
import UIKit

internal final class SharedData: ObservableObject {
	internal static let global = SharedData()
	internal var timeTimer: Timer?
	internal var weatherTimer: Timer?
	internal var flipTimer: Timer?
	internal var llTimer: Timer?
	internal var notifsVisible = false
	internal var axonVisible = false
	internal var takoThingyVisible = false
	internal var musicVisible = false
	internal var musicSuggestionsVisible = false
	internal var ensureTimerRunning = false
	internal var screenOn = false
	internal var aodOn = false
	@Published internal var date = Date()
	@Published internal var timeMinimized = false
	@Published internal var temperature: String? = nil
	@Published internal var weatherImage: Image? = nil
	@Published internal var showingReminders = false
	@Published internal var offset: Double = 0

	final func startTimers() {
		stopTimers()
		date = Date()
		updateWeather()
		timeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			self.date = Date()
			NotificationCenter.default.post(name: NSNotification.Name("moe.absolucy.lucient.battery"), object: nil)
		}
		let miscSettings = UserDefaults.lucientSettings.miscSettings
		weatherTimer = Timer.scheduledTimer(withTimeInterval: miscSettings.weatherRefreshTimer, repeats: true) { _ in
			self.updateWeather()
		}
		flipTimer = Timer.scheduledTimer(withTimeInterval: miscSettings.reminderFlipTimer, repeats: true) { _ in
			let animation: Animation? = {
				(UIAccessibility.isReduceMotionEnabled || UIAccessibility.isReduceTransparencyEnabled) ? nil : Animation
					.easeInOut(duration: 0.75)
			}()
			withAnimation(animation) {
				EventHandler.instance.getEvents()
				self.showingReminders.toggle()
			}
		}
	}

	final func stopTimers() {
		timeTimer?.invalidate()
		weatherTimer?.invalidate()
		flipTimer?.invalidate()
	}

	final func updateScreen(_ status: Bool) {
		screenOn = status
	}

	final func updateAod(_ status: Bool) {
		aodOn = status
	}

	final func updateTimers() {
		if screenOn || aodOn {
			startTimers()
		} else {
			stopTimers()
		}
	}

	final func updateVisibility() {
		let animation: Animation? = {
			UIAccessibility.isReduceMotionEnabled ? nil : Animation.easeInOut(duration: 0.25)
		}()
		if let axonManagerClass = objc_getClass("AXNManager") as? AXNManager.Type {
			updateAxon(axonManagerClass.sharedInstance())
		}
		if let takoControllerClass = objc_getClass("TKOController") as? TKOController.Type {
			updateTako(takoControllerClass.sharedInstance())
		}
		withAnimation(animation) {
			timeMinimized = (!takoThingyVisible && notifsVisible) || axonVisible || musicVisible || musicSuggestionsVisible
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

	final func updateAxon(_ manager: AXNManager!) {
		if UserDefaults.lucientSettings.miscSettings.axonCompat {
			if let axonView = manager.view {
				axonVisible = axonView.list.count > 0
			}
		} else {
			axonVisible = false
		}
	}

	final func updateTako(_ manager: TKOController!) {
		if UserDefaults.lucientSettings.miscSettings.takoCompat {
			if let takoView = manager.view {
				axonVisible = takoView.cellsInfo.count > 0 && manager?.groupView?.isVisible != true
			}
			takoThingyVisible = manager?.groupView?.isVisible == true
		} else {
			axonVisible = false
		}
	}

	final func updateNowPlaying() {
		if let mediaControllerClass = objc_getClass("SBMediaController") as? SBMediaController.Type,
		   let mediaController = mediaControllerClass.sharedInstance()
		{
			musicVisible = mediaController.nowPlayingApplication() != nil
		} else {
			musicVisible = false
		}
		updateVisibility()
	}

	final func updateSuggestions() {
		if let mruNowPlayingView = mruNowPlayingView,
		   let suggestionsView = mruNowPlayingView.suggestionsView
		{
			musicSuggestionsVisible = suggestionsView._viewDelegate()?.parent?.parent?.parent?.parent != nil && mruNowPlayingView
				.showSuggestionsView
		} else {
			musicSuggestionsVisible = false
		}
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
	SharedData.global.updateSuggestions()
	SharedData.global.updateVisibility()
}

@_cdecl("setMusicSuggestionsVisible")
internal func setMusicSuggestionsVisible(_ visible: Bool) {
	SharedData.global.musicSuggestionsVisible = visible
	SharedData.global.updateNowPlaying()
	SharedData.global.updateVisibility()
}

@_cdecl("setScreenOn")
internal func setScreenOn(status: Bool) {
	SharedData.global.updateScreen(status)
	SharedData.global.updateNowPlaying()
	SharedData.global.updateSuggestions()
	SharedData.global.updateVisibility()
	SharedData.global.updateTimers()
}

@_cdecl("setAodOn")
internal func setAodOn(status: Bool) {
	SharedData.global.updateAod(status)
	SharedData.global.updateTimers()
}

@_cdecl("setNotificationsOffset")
internal func setNotificationsOffset(_ offset: CGFloat) {
	SharedData.global.offset = Double(-offset.rounded(.towardZero))
}

@_cdecl("updateAxon")
internal func updateAxon(manager: AXNManager!) {
	SharedData.global.updateAxon(manager)
	SharedData.global.updateVisibility()
}

@_cdecl("updateTako")
internal func updateTako(manager: TKOController!) {
	SharedData.global.updateTako(manager)
	SharedData.global.updateVisibility()
}
