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
			self.weatherImage = nil
			return
		}
		self.temperature = String(temperature)
		self.weatherImage = Image(uiImage: image)
	}
}

@_cdecl("setNotifsVisible")
public dynamic func setNotifsVisible(_ visible: Bool) {
	SharedData.global.notifsVisible = visible
	SharedData.global.updateWeatherData()
}

@_cdecl("updateData")
public dynamic func updateData() {
	SharedData.global.updateWeatherData()
}
