//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal enum FontStyle: String, Codable {
	case ios
	case android
	case custom

	init(old: Int) {
		switch old {
		case 0:
			self = .ios
		case 1:
			self = .android
		default:
			self = .custom
		}
	}
}
