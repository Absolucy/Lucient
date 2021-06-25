//
//  ExportPreferences.swift
//
//
//  Created by Lucy on 6/24/21.
//

import Foundation
import SwiftUI

internal struct PreferencesJson: Codable {
	var fontStyle = FontStyle.ios
	var colorMode = ColorMode.distinctive
	var color = Color.primary
	var separatedColors = false
	var maxTimeSize: Double = 160
	var minTimeSize: Double = 72
	var timeOffset: Double = 15
	var timeOnTheRight = false
	var timeColorMode = ColorMode.secondary
	var timeColor = Color.primary
	var showWeather = true
	var dateFontSize: Double = 24
	var dateOffset: Double = 0
	var dateColorMode = ColorMode.secondary
	var dateColor = Color.primary
}

internal extension PreferencesJson {
	static func save() -> Self {
		var prefs = PreferencesJson()
		guard let defaults = UserDefaults(suiteName: "/var/mobile/Library/Preferences/moe.absolucy.lucient.plist")
		else { return prefs }
		if let fontStyle = defaults.object(forKey: "fontStyle") as? FontStyle {
			prefs.fontStyle = fontStyle
		}
		if let colorMode = defaults.object(forKey: "color") as? ColorMode {
			prefs.colorMode = colorMode
		}
		if let rawColor = defaults.object(forKey: "fontStyle") as? String,
		   let color = Color(hex: rawColor)
		{
			prefs.color = color
		}
		if let separatedColors = defaults.object(forKey: "separatedColors") as? Bool {
			prefs.separatedColors = separatedColors
		}
		if let maxTimeSize = defaults.object(forKey: "maxTimeSize") as? Double {
			prefs.maxTimeSize = maxTimeSize
		}
		if let minTimeSize = defaults.object(forKey: "minTimeSize") as? Double {
			prefs.minTimeSize = minTimeSize
		}
		if let timeOffset = defaults.object(forKey: "timeOffset") as? Double {
			prefs.timeOffset = timeOffset
		}
		if let timeOnTheRight = defaults.object(forKey: "timeOnTheRight") as? Bool {
			prefs.timeOnTheRight = timeOnTheRight
		}
		if let timeColorMode = defaults.object(forKey: "timeColorMode") as? ColorMode {
			prefs.timeColorMode = timeColorMode
		}
		if let rawTimeColor = defaults.object(forKey: "timeColor") as? String,
		   let timeColor = Color(hex: rawTimeColor)
		{
			prefs.timeColor = timeColor
		}
		if let showWeather = defaults.object(forKey: "showWeather") as? Bool {
			prefs.showWeather = showWeather
		}
		if let dateFontSize = defaults.object(forKey: "dateFontSize") as? Double {
			prefs.dateFontSize = dateFontSize
		}
		if let dateOffset = defaults.object(forKey: "dateOffset") as? Double {
			prefs.dateOffset = dateOffset
		}
		if let dateColorMode = defaults.object(forKey: "dateColorMode") as? ColorMode {
			prefs.dateColorMode = dateColorMode
		}
		if let rawDateColor = defaults.object(forKey: "dateColor") as? String,
		   let dateColor = Color(hex: rawDateColor)
		{
			prefs.dateColor = dateColor
		}
		return prefs
	}

	func load() {
		guard let defaults = UserDefaults(suiteName: "/var/mobile/Library/Preferences/moe.absolucy.lucient.plist")
		else { return }
		defaults.set(fontStyle.rawValue, forKey: "fontStyle")
		defaults.set(colorMode.rawValue, forKey: "colorMode")
		defaults.set(color.hexString(), forKey: "color")
		defaults.set(separatedColors, forKey: "separatedColors")
		defaults.set(maxTimeSize, forKey: "maxTimeSize")
		defaults.set(minTimeSize, forKey: "minTimeSize")
		defaults.set(timeOffset, forKey: "timeOffset")
		defaults.set(timeOnTheRight, forKey: "timeOnTheRight")
		defaults.set(timeColorMode.rawValue, forKey: "timeColorMode")
		defaults.set(timeColor.hexString(), forKey: "timeColor")
		defaults.set(showWeather, forKey: "showWeather")
		defaults.set(dateFontSize, forKey: "dateFontSize")
		defaults.set(dateOffset, forKey: "dateOffset")
		defaults.set(dateColorMode.rawValue, forKey: "dateColorMode")
		defaults.set(dateColor.hexString(), forKey: "dateColor")
	}
}

extension Color: Codable {
	enum CodingKeys: String, CodingKey {
		case red, green, blue, alpha
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let r = try container.decode(Double.self, forKey: .red)
		let g = try container.decode(Double.self, forKey: .green)
		let b = try container.decode(Double.self, forKey: .blue)
		let a = try container.decode(Double.self, forKey: .alpha)

		self.init(.displayP3, red: r, green: g, blue: b, opacity: a)
	}

	public func encode(to encoder: Encoder) throws {
		let (r, g, b, a) = components

		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(r, forKey: .red)
		try container.encode(g, forKey: .green)
		try container.encode(b, forKey: .blue)
		try container.encode(a, forKey: .alpha)
	}
}
