//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import SwiftUI

internal class FontSettings: ObservableObject, Codable, Equatable {
	@Published var style = FontStyle.ios
	@Published var customFont = ""
	@Published var colorMode = ColorMode.distinctive
	@Published var customColor = Color.white

	init() {}

	// Encoding/decoding stuff //
	private enum CodingKeys: CodingKey {
		case style, customFont, colorMode, customColor
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(style, forKey: .style)
		try container.encode(customFont, forKey: .customFont)
		try container.encode(colorMode, forKey: .colorMode)
		try container.encode(
			try NSKeyedArchiver.archivedData(withRootObject: UIColor(customColor), requiringSecureCoding: false),
			forKey: .customColor
		)
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		style = try container.decode(FontStyle.self, forKey: .style)
		customFont = try container.decode(String.self, forKey: .customFont)
		colorMode = try container.decode(ColorMode.self, forKey: .colorMode)
		if let archivedColorData = try? container.decode(Data.self, forKey: .customColor),
		   let archivedColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: archivedColorData)
		{
			customColor = Color(archivedColor)
		} else if let hexColor = try? container.decode(String.self, forKey: .customColor),
		          let color = Color(hex: hexColor)
		{
			customColor = color
		}
	}

	static func == (lhs: FontSettings, rhs: FontSettings) -> Bool {
		lhs.style == rhs.style
			&& lhs.customFont == rhs.customFont
			&& lhs.colorMode == rhs.colorMode
			&& lhs.customColor == rhs.customColor
	}
}
