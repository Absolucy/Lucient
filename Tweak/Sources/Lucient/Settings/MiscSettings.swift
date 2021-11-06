//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal class MiscSettings: ObservableObject, Codable, Equatable {
	@Published var remindersEnabled = true
	@Published var weatherEnabled = true
	@Published var cutOffReminders = true
	@Published var reminderFlipTimer: Double = 5
	@Published var weatherRefreshTimer: Double = 90
	@Published var axonCompat = true
	@Published var takoCompat = true

	init() {}

	// Encoding/decoding stuff //
	private enum CodingKeys: CodingKey {
		case remindersEnabled, weatherEnabled, cutOffReminders, reminderFlipTimer, weatherRefreshTimer, axonCompat, takoCompat
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(remindersEnabled, forKey: .remindersEnabled)
		try container.encode(weatherEnabled, forKey: .weatherEnabled)
		try container.encode(cutOffReminders, forKey: .cutOffReminders)
		try container.encode(reminderFlipTimer, forKey: .reminderFlipTimer)
		try container.encode(weatherRefreshTimer, forKey: .weatherRefreshTimer)
		try container.encode(axonCompat, forKey: .axonCompat)
		try container.encode(takoCompat, forKey: .takoCompat)
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		remindersEnabled = try container.decode(Bool.self, forKey: .remindersEnabled)
		weatherEnabled = try container.decode(Bool.self, forKey: .weatherEnabled)
		cutOffReminders = try container.decode(Bool.self, forKey: .cutOffReminders)
		reminderFlipTimer = try container.decode(Double.self, forKey: .reminderFlipTimer)
		weatherRefreshTimer = try container.decode(Double.self, forKey: .weatherRefreshTimer)
		if let axonCompat = try? container.decode(Bool.self, forKey: .axonCompat) {
			self.axonCompat = axonCompat
		}
		if let takoCompat = try? container.decode(Bool.self, forKey: .takoCompat) {
			self.takoCompat = takoCompat
		}
	}

	static func == (lhs: MiscSettings, rhs: MiscSettings) -> Bool {
		lhs.remindersEnabled == rhs.remindersEnabled
			&& lhs.weatherEnabled == rhs.weatherEnabled
			&& lhs.cutOffReminders == rhs.cutOffReminders
			&& lhs.reminderFlipTimer == rhs.reminderFlipTimer
			&& lhs.weatherRefreshTimer == rhs.weatherRefreshTimer
			&& lhs.axonCompat == rhs.axonCompat
			&& lhs.takoCompat == rhs.takoCompat
	}
}
