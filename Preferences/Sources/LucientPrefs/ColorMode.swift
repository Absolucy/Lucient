//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

internal enum ColorMode: String, Codable {
	case custom
	case distinctive
	case primary
	case secondary
	case background

	internal init(old: Int) {
		switch old {
		case 0:
			self = .custom
		case 2:
			self = .primary
		case 3:
			self = .secondary
		case 4:
			self = .background
		default:
			self = .distinctive
		}
	}
}
