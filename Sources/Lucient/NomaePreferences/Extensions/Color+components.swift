//
//  Color+components.swift
//
//
//  Created by Lucy on 6/24/21.
//

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
