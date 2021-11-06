//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Combine
import Foundation
import SwiftUI

internal class Settings: ObservableObject, Codable, RawRepresentable, Equatable {
	static let path = "/var/mobile/Library/Preferences/moe.absolucy.lucient.json"

	@Published var enabled = true
	@Published var globalFontSettings = FontSettings()
	@Published var dateSettings = DateSettings()
	@Published var timeSettings = TimeSettings()
	@Published var miscSettings = MiscSettings()
	@Published var stockSettings = StockSettings()
	@Published var batterySettings = BatterySettings()

	private var cancellables = Set<AnyCancellable>()
	private func setup() {
		globalFontSettings.objectWillChange
			.sink { _ in
				self.objectWillChange.send()
			}
			.store(in: &cancellables)
		dateSettings.objectWillChange
			.sink { _ in
				self.objectWillChange.send()
			}
			.store(in: &cancellables)
		timeSettings.objectWillChange
			.sink { _ in
				self.objectWillChange.send()
			}
			.store(in: &cancellables)
		miscSettings.objectWillChange
			.sink { _ in
				self.objectWillChange.send()
			}
			.store(in: &cancellables)
		stockSettings.objectWillChange
			.sink { _ in
				self.objectWillChange.send()
			}
			.store(in: &cancellables)
		batterySettings.objectWillChange
			.sink { _ in
				self.objectWillChange.send()
			}
			.store(in: &cancellables)
	}

	// Encoding/decoding stuff //
	private enum CodingKeys: CodingKey {
		case enabled, font, date, time, misc, stock, battery
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(enabled, forKey: .enabled)
		try container.encode(globalFontSettings, forKey: .font)
		try container.encode(dateSettings, forKey: .date)
		try container.encode(timeSettings, forKey: .time)
		try container.encode(miscSettings, forKey: .misc)
		try container.encode(stockSettings, forKey: .stock)
		try container.encode(batterySettings, forKey: .battery)
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		enabled = try container.decode(Bool.self, forKey: .enabled)
		globalFontSettings = try container.decode(FontSettings.self, forKey: .font)
		dateSettings = try container.decode(DateSettings.self, forKey: .date)
		timeSettings = try container.decode(TimeSettings.self, forKey: .time)
		miscSettings = try container.decode(MiscSettings.self, forKey: .misc)
		if let stockSettings = try? container.decode(StockSettings.self, forKey: .stock) {
			self.stockSettings = stockSettings
		}
		if let batterySettings = try? container.decode(BatterySettings.self, forKey: .battery) {
			self.batterySettings = batterySettings
		}
	}

	typealias RawValue = String
	var rawValue: String {
		String(data: try! JSONEncoder().encode(self), encoding: .utf8)!
	}

	init() {
		setup()
	}

	required init?(rawValue: String) {
		guard let jsonData = rawValue.data(using: .utf8),
		      let json = try? JSONDecoder().decode(Settings.self, from: jsonData) else { return nil }
		enabled = json.enabled
		globalFontSettings = json.globalFontSettings
		dateSettings = json.dateSettings
		timeSettings = json.timeSettings
		miscSettings = json.miscSettings
		stockSettings = json.stockSettings
		batterySettings = json.batterySettings
		setup()
	}

	static func == (lhs: Settings, rhs: Settings) -> Bool {
		lhs.enabled == rhs.enabled
			&& lhs.globalFontSettings == rhs.globalFontSettings
			&& lhs.dateSettings == rhs.dateSettings
			&& lhs.timeSettings == rhs.timeSettings
			&& lhs.miscSettings == rhs.miscSettings
			&& lhs.stockSettings == rhs.stockSettings
			&& lhs.batterySettings == rhs.batterySettings
	}
}
