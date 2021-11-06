//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal class StockSettings: ObservableObject, Codable, Equatable {
	@Published var hideQuickActions = true
	@Published var hideLock = true

	init() {}

	// Encoding/decoding stuff //
	private enum CodingKeys: CodingKey {
		case hideQuickActions, hideLock
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(hideQuickActions, forKey: .hideQuickActions)
		try container.encode(hideLock, forKey: .hideLock)
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		hideQuickActions = try container.decode(Bool.self, forKey: .hideQuickActions)
		hideLock = try container.decode(Bool.self, forKey: .hideLock)
	}

	static func == (lhs: StockSettings, rhs: StockSettings) -> Bool {
		lhs.hideQuickActions == rhs.hideQuickActions
			&& lhs.hideLock == rhs.hideLock
	}
}
