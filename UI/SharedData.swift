//
//  SharedData.swift
//  Thanos
//
//  Created by Aspen on 6/13/21.
//

import Foundation
import SwiftUI
import UIKit

class SharedData: ObservableObject {
	internal static let global = SharedData()
	@Published internal var notifsVisible = false
	@Published internal var temperature: String? = nil
	@Published internal var weatherImage: Image? = nil
}

extension SharedData {
	func updateWeatherData() {
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
	SharedData.global.updateWeatherData()
}

@_cdecl("updateData")
public dynamic func updateData(_ screenVisible: Bool) {
	NotificationCenter.default.post(
		name: Notification.Name("me.aspenuwu.thanos.lsvis"),
		object: screenVisible
	)
	if screenVisible {
		SharedData.global.updateWeatherData()
	}
}