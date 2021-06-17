//
//  SharedData.swift
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

import Foundation
import SwiftUI
import UIKit
import LucientC

internal final class SharedData: ObservableObject {
	static let global = SharedData()
	var timeTimer: Timer?
	var weatherTimer: Timer?
	@Published internal var notifsVisible = false
	@Published internal var temperature: String? = nil
	@Published internal var weatherImage: Image? = nil

	final func startTimers() {
		stopTimers()
		timeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			NotificationCenter.default.post(name: NSNotification.Name("me.aspenuwu.lucient.time"), object: nil)
		}
		weatherTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
			NotificationCenter.default.post(name: NSNotification.Name("me.aspenuwu.lucient.weather"), object: nil)
		}
	}

	final func stopTimers() {
		timeTimer?.invalidate()
		timeTimer = nil
		weatherTimer?.invalidate()
		weatherTimer = nil
	}

	final func updateNotificationVisibility(_ visible: Bool) {
		if visible {
			timeView?.view?.isHidden = true
		}
		withAnimation(.easeInOut(duration: 0.5)) {
			notifsVisible = visible
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
	SharedData.global.updateNotificationVisibility(visible)
}

@_cdecl("setScreenOn")
public dynamic func setScreenOn(_: Bool) {
	NotificationCenter.default.post(name: NSNotification.Name("me.aspenuwu.lucient.time"), object: nil)
	NotificationCenter.default.post(name: NSNotification.Name("me.aspenuwu.lucient.weather"), object: nil)
}
