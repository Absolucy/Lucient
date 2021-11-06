//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Combine
import Foundation

internal class BatterySettings: ObservableObject, Codable, Equatable {
	@Published var enabled = true
	@Published var usingFontSettings = false
	@Published var fontSettings = FontSettings()
	@Published var fontSize: Double = 16
	@Published var offset: Double = 0

	private var cancellables = Set<AnyCancellable>()
	private func setup() {
		fontSettings.objectWillChange
			.sink { _ in
				self.objectWillChange.send()
			}
			.store(in: &cancellables)
	}

	init() {
		setup()
	}

	// Encoding/decoding stuff //
	private enum CodingKeys: CodingKey {
		case enabled, usingFontSettings, fontSettings, fontSize, offset
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(enabled, forKey: .enabled)
		try container.encode(usingFontSettings, forKey: .usingFontSettings)
		try container.encode(fontSettings, forKey: .fontSettings)
		try container.encode(fontSize, forKey: .fontSize)
		try container.encode(offset, forKey: .offset)
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		enabled = try container.decode(Bool.self, forKey: .enabled)
		usingFontSettings = try container.decode(Bool.self, forKey: .usingFontSettings)
		fontSettings = try container.decode(FontSettings.self, forKey: .fontSettings)
		fontSize = try container.decode(Double.self, forKey: .fontSize)
		offset = try container.decode(Double.self, forKey: .offset)
		setup()
	}

	static func == (lhs: BatterySettings, rhs: BatterySettings) -> Bool {
		lhs.enabled == rhs.enabled
			&& lhs.usingFontSettings == rhs.usingFontSettings
			&& lhs.fontSettings == rhs.fontSettings
			&& lhs.fontSize == rhs.fontSize
			&& lhs.offset == rhs.offset
	}
}
