//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import SwiftUI

extension Color: Codable {
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(hexString())
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self = Color(hex: try container.decode(String.self)) ?? Color.white
	}
}
