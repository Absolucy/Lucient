//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import SwiftUI
import UIKit

internal extension Color {
	var components: (Double, Double, Double, Double) {
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var o: CGFloat = 0

		guard UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
			// You can handle the failure here as you want
			return (0, 0, 0, 0)
		}

		return (Double(r), Double(g), Double(b), Double(o))
	}
}
