//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import SwiftUI

internal enum Alignment: String, Codable {
	case left, center, right
}

internal extension Alignment {
	func ui() -> TextAlignment {
		switch self {
		case .left:
			return TextAlignment.leading
		case .center:
			return TextAlignment.center
		case .right:
			return TextAlignment.trailing
		}
	}
}

internal extension View {
	func align(alignment: Alignment) -> some View {
		switch alignment {
		case .left:
			return AnyView(HStack {
				self
				Spacer()
			})
		case .center:
			return AnyView(HStack {
				Spacer()
				self
				Spacer()
			})
		case .right:
			return AnyView(HStack {
				Spacer()
				self
			})
		}
	}
}
