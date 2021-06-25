//
//  Color+HexString.swift
//  NomaePreferences
//
//  Created by Eamon Tracey.
//  Copyright © 2021 Eamon Tracey. All rights reserved.
//

import SwiftUI

internal extension Color {
	init?(hex string: String) {
		var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		if string.hasPrefix("#") {
			_ = string.removeFirst()
		}

		// Double the last value if incomplete hex
		if !string.count.isMultiple(of: 2), let last = string.last {
			string.append(last)
		}

		// Fix invalid values
		if string.count > 8 {
			string = String(string.prefix(8))
		}

		// Scanner creation
		let scanner = Scanner(string: string)

		var color: UInt64 = 0
		scanner.scanHexInt64(&color)

		if string.count == 2 {
			let mask = 0xFF

			let g = Int(color) & mask

			let gray = Double(g) / 255.0

			self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)

		} else if string.count == 4 {
			let mask = 0x00FF

			let g = Int(color >> 8) & mask
			let a = Int(color) & mask

			let gray = Double(g) / 255.0
			let alpha = Double(a) / 255.0

			self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)

		} else if string.count == 6 {
			let mask = 0x0000FF
			let r = Int(color >> 16) & mask
			let g = Int(color >> 8) & mask
			let b = Int(color) & mask

			let red = Double(r) / 255.0
			let green = Double(g) / 255.0
			let blue = Double(b) / 255.0

			self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)

		} else if string.count == 8 {
			let mask = 0x0000_00FF
			let r = Int(color >> 24) & mask
			let g = Int(color >> 16) & mask
			let b = Int(color >> 8) & mask
			let a = Int(color) & mask

			let red = Double(r) / 255.0
			let green = Double(g) / 255.0
			let blue = Double(b) / 255.0
			let alpha = Double(a) / 255.0

			self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)

		} else {
			return nil
		}
	}

	func hexString() -> String {
		let (r, g, b, a) = components
		var hex = String(
			format: "#%02lX%02lX%02lX",
			lroundf(Float(r * 255)),
			lroundf(Float(g * 255)),
			lroundf(Float(b * 255))
		)
		if a < 1.0 {
			hex.append(String(format: "%02lX", lroundf(Float(a * 255))))
		}
		return hex
	}
}

/// Conform `Color` to `RawRepresentable` for use with `Preference` and `ColorPicker`.
extension Color: RawRepresentable {
	public init?(rawValue: String) {
		guard let color = Color(hex: rawValue) else { return nil }
		self = color
	}

	public var rawValue: String {
		hexString()
	}
}
